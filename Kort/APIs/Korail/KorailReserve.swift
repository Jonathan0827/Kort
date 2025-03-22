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
        MakeReservation(train, reserveOption) { r in
            debugPrint(r)
            completion(r)
        }
    }
}
func MakeReservation(_ trainInfo: TrainInfo, _ options: RealReservationOptions,completion: @escaping (ReservationResult) -> Void) {
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
//    print(parameters)
    SD.session.request(apiPath("certification.TicketReservation"), method: .get, parameters: parameters)
        .response { r in
            debugPrint(r)
            switch r.result {
            case .success(let data):
//                print(data)
                break
            case .failure(let error):
                print(error)
                completion(ReservationResult(code: .error))
                return
            }
        }
        .responseDecodable(of: KorailReservationResponse.self) { res in
            switch res.result {
            case .success(let value):
                completion(ReservationResult(code: .success, strResult: value.hNtisuLmt,reqResult: value))
            case .failure:
                completion(ReservationResult(code: .error, strResult: "FAIL"))
            }
        }
    
}


func makePassengerArray(_ p: PassengerCount) -> Array<Passenger> {
    var arr = [Passenger]()
    arr += Array(repeating: Adult, count: p.adult)
    arr += Array(repeating: Child, count: p.child)
    arr += Array(repeating: Toddler, count: p.toddler)
    arr += Array(repeating: Senior, count: p.senior)
    return arr
}
