//
//  KorailMakeReservation.swift
//  Kort
//
//  Created by 임준협 on 12/10/24.
//

import Foundation
import Alamofire

func Reserve(_ train: TrainInfo, _ rsvOpt: ReservationOptions, completion: @escaping (ReservationResult) -> Void) {
    var reserveOption = RealReservationOptions(seatType: .general, passengers: rsvOpt.passengers)
    if !train.isReservable {
        completion(ReservationResult(code: .soldOut, additionalInfo: "예약할 수 없습니다", moreAdditionalInfo: "isReservable is false."))
        return
    } else {
        switch rsvOpt.seatPref {
        case .generalOnly:
            if train.genRsv == .available {
                reserveOption.seatType = .general
            } else {
                completion(ReservationResult(code: .soldOut, additionalInfo: "예약할 수 없습니다", moreAdditionalInfo: "genRsv is not available while seatPref is generalOnly."))
                return
            }
        case .generalFirst:
            if train.genRsv == .available {
                reserveOption.seatType = .general
            } else if train.speRsv == .available {
                reserveOption.seatType = .special
            } else {
                completion(ReservationResult(code: .soldOut, additionalInfo: "예약할 수 없습니다", moreAdditionalInfo: "Both genRsv and speRsv are not available."))
                return
            }
        case .specialOnly:
            if train.speRsv == .available {
                reserveOption.seatType = .special
            } else {
                completion(ReservationResult(code: .soldOut, additionalInfo: "예약할 수 없습니다", moreAdditionalInfo: "speRsv is not available while seatPref is specialOnly."))
                return
            }
        case .specialFirst:
            if train.speRsv == .available {
                reserveOption.seatType = .special
            } else if train.genRsv == .available {
                reserveOption.seatType = .general
            } else {
                completion(ReservationResult(code: .soldOut, additionalInfo: "예약할 수 없습니다", moreAdditionalInfo: "Both genRsv and speRsv are not available."))
                return
            }
        }
        reserveForReal(train, reserveOption) { r in
            debugPrint(r)
            completion(r)
        }
    }
}
func reserveForReal(_ trainInfo: TrainInfo, _ options: RealReservationOptions,completion: @escaping (ReservationResult) -> Void) {
    var parameters = [
        "Device": "AD",
        "Version": version,
        "Key": UD.key,
        "txtGdNo": "",
        "txtJobId": "1101",
        "txtTotPsgCnt": "\(options.passengers.adult+options.passengers.child+options.passengers.senior)",
        "txtSeatAttCd1": "000",
        "txtSeatAttCd2": "000",
        "txtSeatAttCd3": "000",
        "txtSeatAttCd4": "015",
        "txtSeatAttCd5": "000",
        "hidFreeFlg": "N",
        "txtStndFlg": "N",
        "txtMenuId": "11",
        "txtSrcarCnt": "0",
        "txtJrnyCnt": "1",
        "txtJrnySqno1": "001",
        "txtJrnyTpCd1": "11",
        "txtDptDt1": trainInfo.depDate,
        "txtDptRsStnCd1": trainInfo.depCode,
        "txtDptTm1": trainInfo.depTime,
        "txtArvRsStnCd1": trainInfo.arrCode,
        "txtTrnNo1": trainInfo.trainNo,
        "txtRunDt1": trainInfo.runDate,
        "txtTrnClsfCd1": trainInfo.trainCode,
        "txtPsrmClCd1": options.seatType.rawValue,
        "txtTrnGpCd1": trainInfo.trainGrpCode,
        "txtChgFlg1": "",
        "txtJrnySqno2": "",
        "txtJrnyTpCd2": "",
        "txtDptDt2": "",
        "txtDptRsStnCd2": "",
        "txtDptTm2": "",
        "txtArvRsStnCd2": "",
        "txtTrnNo2": "",
        "txtRunDt2": "",
        "txtTrnClsfCd2": "",
        "txtPsrmClCd2": "",
        "txtChgFlg2": "",
    ]
    var index = 1
    let passengers = makePassengerArray(options.passengers)
    for passenger in passengers {
        parameters["txtPsgTpCd\(index)"] = passenger.typeCode
        parameters["txtDiscKndCd1\(index)"] = passenger.discountType
        parameters["txtCompaCnt\(index)"] = "1"
        parameters["txtCardCode_\(index)"] = ""
        parameters["txtCardNo_\(index)"] = ""
        parameters["txtCardPw_\(index)"] = ""
        index += 1
    }
//    var index = 1
//    while index < options.passengers.adult+1 {
//        parameters["txtPsgTpCd\(index)"] = "1"
//        parameters["txtDiscKndCd1\(index)"] = "000"
//        parameters["txtCompaCnt\(index)"] = "1"
//        parameters["txtCardCode_\(index)"] = ""
//        parameters["txtCardNo_\(index)"] = ""
//        parameters["txtCardPw_\(index)"] = ""
//        index += 1
//    }
//    var index2 = index + 1
//    while index2 < options.passengers.child + index + 1 {
//        parameters["txtPsgTpCd\(index2)"] = "3"
//        parameters["txtDiscKndCd1\(index2)"] = "000"
//        parameters["txtCompaCnt\(index2)"] = "1"
//        parameters["txtCardCode_\(index2)"] = ""
//        parameters["txtCardNo_\(index2)"] = ""
//        parameters["txtCardPw_\(index2)"] = ""
//        index2 += 1
//    }
//    var index3 = index2
//    while index3 < options.passengers.adult + index2 + 1{
//        parameters["txtPsgTpCd\(index)"] = "1"
//        parameters["txtDiscKndCd1\(index)"] = "131"
//        parameters["txtCompaCnt\(index)"] = "1"
//        parameters["txtCardCode_\(index)"] = ""
//        parameters["txtCardNo_\(index)"] = ""
//        parameters["txtCardPw_\(index)"] = ""
//        index3 += 1
//    }
    print(parameters)
    SD.session.request(apiPath("certification.TicketReservation"), method: .get, parameters: parameters)
        .response { r in
            debugPrint(r)
            switch r.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
}
enum ReservationCode {
    case success
    case error
    case soldOut
}
struct ReservationResult {
    let code: ReservationCode
    let rsvInfo: TrainInfo?
    let additionalInfo: String
    let moreAdditionalInfo: String
    init(code: ReservationCode, rsvInfo: TrainInfo? = nil, additionalInfo: String = "", moreAdditionalInfo: String = "") {
        self.code = code
        self.rsvInfo = rsvInfo
        self.additionalInfo = additionalInfo
        self.moreAdditionalInfo = moreAdditionalInfo
    }
}
enum SeatPref {
    case generalOnly
    case generalFirst
    case specialOnly
    case specialFirst
}
struct ReservationOptions {
    let seatPref: SeatPref
    let passengers: PassengerCount
}
enum Seats: String {
    case special = "2"
    case general = "1"
}
struct RealReservationOptions {
    var seatType: Seats
    var passengers: PassengerCount
}

struct Passenger {
    let typeCode: String
    let discountType: String
}

let Adult = Passenger(typeCode: "1", discountType: "000")
let Child = Passenger(typeCode: "3", discountType: "000")
let Toddler = Passenger(typeCode: "3", discountType: "321")
let Senior = Passenger(typeCode: "1", discountType: "131")

func makePassengerArray(_ p: PassengerCount) -> Array<Passenger> {
    var arr = [Passenger]()
    arr += Array(repeating: Adult, count: p.adult)
    arr += Array(repeating: Child, count: p.child)
    arr += Array(repeating: Toddler, count: p.toddler)
    arr += Array(repeating: Senior, count: p.senior)
    return arr
}
