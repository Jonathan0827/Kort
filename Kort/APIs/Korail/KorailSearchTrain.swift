//
//  KorailSearchTrain.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

import Foundation
import Alamofire

struct PassengerCount {
    let adult: Int
    let child: Int
    let toddler: Int
    let senior: Int
    init(adult: Int = 0, child: Int = 0, toddler: Int = 0, senior: Int = 0) {
        self.adult = adult
        self.child = child
        self.toddler = toddler
        self.senior = senior
    }
}

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
        "txtPsgFlg_8": "0",
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
                    trainInfoArr.append(TrainInfo(isReservable: (train["h_rsv_psb_flg"] ?? "" == "Y"), trainFullNm: train["h_trn_clsf_nm"] ?? "", trainShortNm: train["h_trn_gp_nm"] ?? "",trainNo: train["h_trn_no"] ?? "", trainCode: train["h_trn_clsf_cd"] ?? "",trainGrpCode: train["h_trn_gp_cd"] ?? "",expDelay: train["h_expct_dlay_hr"] ?? "", genPsbNm: train["h_rsv_psb_nm"] ?? "", spePsbNm: train["h_spe_rsv_psb_nm"] ?? "", depDate: train["h_dpt_dt"] ?? "", depTime: train["h_dpt_tm"] ?? "", arrDate: train["h_arv_dt"] ?? "", arrTime: train["h_arv_tm"] ?? "", depCode: train["h_dpt_rs_stn_cd"] ?? "", arrCode: train["h_arv_rs_stn_cd"] ?? "", runDate: train["h_run_dt"] ?? "",speRsv: korailSeatAvailablity(rawValue: train["h_spe_rsv_cd"] ?? "")!, genRsv: korailSeatAvailablity(rawValue: train["h_gen_rsv_cd"] ?? "")!))
                }
//                print(trainInfoArr)
                completion(trainInfoArr)
            case .failure(let error):
                print(error)
                debugPrint(res)
            }
        }
}

enum korailStations: String, Identifiable, CaseIterable {
    case seoul = "서울"
    case yongsan = "용산"
    case yeongdeungpo = "영등포"
    case gwangmyeong = "광명"
    case suwon = "수원"
    case cheonanAsan = "천안아산"
    case osong = "오송"
    case daejeon = "대전"
    case seodaejeon = "서대전"
    case gimcheonGumi = "김천구미"
    case dongdaegu = "동대구"
    case gyeongju = "경주"
    case pohang = "포항"
    case miryang = "밀양"
    case gupo = "구포"
    case busan = "부산"
    case ulsanTongdosa = "울산(통도사)"
    case masan = "마산"
    case changwonJungang = "창원중앙"
    case gyeongsan = "경산"
    case nongsan = "논산"
    case iksan = "익산"
    case jeongeup = "정읍"
    case gwangjuSongjeong = "광주송정"
    case mokpo = "목포"
    case jeonju = "전주"
    case suncheon = "순천"
    case yeosuExpo = "여수EXPO(구,여수역)"
    case cheongnyangni = "청량리"
    case gangneung = "강릉"
    case haengsin = "행신"
    case jeongdongjin = "정동진"
    var id: Self { self }
}

enum korailTrains: String {
    case ktx = "100"              // KTX, KTX-산천
    case saemaeul = "101"         // 새마을호, ITX-새마을
    case mugunghwa = "102"        // 무궁화호, 누리로
    case tongguen = "103"         // 통근열차
    case itxCheongchun = "104"    // ITX-청춘
    case airport = "105"          // 공항직통
    case all = "109"              // 전체
}

struct TrainInfo {
    let isReservable: Bool
    let trainFullNm: String
    let trainShortNm: String
    let trainNo: String
    let trainCode: String
    let trainGrpCode: String
    let expDelay: String
    let genPsbNm: String
    let spePsbNm: String
    let depDate: String
    let depTime: String
    let arrDate: String
    let arrTime: String
    let depCode: String
    let arrCode: String
    let runDate: String
    let speRsv: korailSeatAvailablity
    let genRsv: korailSeatAvailablity
}

enum korailSeatAvailablity: String {
    case available = "11"
    case soldout = "13"
    case lack = "12"
    case noseattype = "00"
}

//enum korailWaitAvailability: String {
//    case seatAvailable = "-2"
//    case waitAvailable = " 9"
//    case waitSoldOut = " 0"
//}
