//
//  KorailSearchTrain.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

import Foundation
import Alamofire



func SearchKorailTrain(date: String, time: String, dep: korailStations, arr: korailStations, trainType: korailTrains = .all, includeSoldOut: Bool, includeWaiting: Bool, passengers: PassengerCount, completion: @escaping (Array<TrainInfo>) -> Void) {
    let params: [String: String] = [
        "Device": "AD",
        "radJobId": "1",
        "selGoTrain": trainType.rawValue,
        "txtCardPsgCnt": "0",
        "txtGdNo": "",
        "txtGoAbrdDt": date,
        "txtGoEnd": arr.rawValue,
        "txtGoHour": time,
        "txtGoStart": dep.rawValue,
        "txtJobDv": "",
        "txtMenuId": "11",
        "txtPsgFlg_1": "\(passengers.adult)",
        "txtPsgFlg_2": "\(passengers.child)",
//        "txtPsgFlg_8": "0",
        "txtPsgFlg_3": "\(passengers.senior)",
        "txtPsgFlg_4": "0",
        "txtPsgFlg_5": "0",
        "txtSeatAttCd_2": "000",
        "txtSeatAttCd_3": "000",
        "txtSeatAttCd_4": "015",
        "txtTrnGpCd": trainType.rawValue,
        "Version": version
    ]
    SD.session.request(apiPath("seatMovie.ScheduleView"), method: .get, parameters: params)
//        .response { response in
//            debugPrint(response)
//        }
        .responseDecodable(of: SearchKorailTrainResponse.self) { res in
//            debugPrint(res)
            switch res.result {
            case .success(let value):
//                print(value)
                let trainDict = value.trnInfos.trnInfo
                var trainInfoArr: [TrainInfo] = [TrainInfo]()
                for trn in trainDict {
                    let train = trn.compactMapValues { $0 }
                    trainInfoArr.append(TrainInfo(isReservable: (train["h_rsv_psb_flg"] ?? "" == "Y"), trainFullNm: train["h_trn_clsf_nm"] ?? "", trainShortNm: train["h_trn_gp_nm"] ?? "",trainNo: train["h_trn_no"] ?? "", trainCode: train["h_trn_clsf_cd"] ?? "",trainGrpCode: train["h_trn_gp_cd"] ?? "",expDelay: train["h_expct_dlay_hr"] ?? "", genPsbNm: train["h_rsv_psb_nm"] ?? "", spePsbNm: train["h_spe_rsv_psb_nm"] ?? "", depDate: train["h_dpt_dt"] ?? "", depTime: train["h_dpt_tm"] ?? "", arrDate: train["h_arv_dt"] ?? "", arrTime: train["h_arv_tm"] ?? "", depCode: train["h_dpt_rs_stn_cd"] ?? "", arrCode: train["h_arv_rs_stn_cd"] ?? "", runDate: train["h_run_dt"] ?? "", depStnNm: train["h_dpt_rs_stn_nm"] ?? "", arrStnNm: train["h_arv_rs_stn_nm"] ?? "",speRsv: korailSeatAvailablity(rawValue: train["h_spe_rsv_cd"] ?? "")!, genRsv: korailSeatAvailablity(rawValue: train["h_gen_rsv_cd"] ?? "")!))
                }
                //                print(trainInfoArr)
                completion(trainInfoArr)
            case .failure(let error):
                print(error)
                debugPrint(res)
                completion([TrainInfo]())
            }
        }
}

//enum korailWaitAvailability: String {
//    case seatAvailable = "-2"
//    case waitAvailable = " 9"
//    case waitSoldOut = " 0"
//}
