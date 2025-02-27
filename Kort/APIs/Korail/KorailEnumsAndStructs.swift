//
//  KorailEnumsAndStructs.swift
//  Kort
//
//  Created by 임준협 on 2/27/25.
//

import Foundation
struct PassengerCount {
    var adult: Int // 어른
    var child: Int // 어린이
    var toddler: Int // 유아
    var senior: Int // 노인
    init(adult: Int = 0, child: Int = 0, toddler: Int = 0, senior: Int = 0) {
        self.adult = adult
        self.child = child
        self.toddler = toddler
        self.senior = senior
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
    let strResult: String?
    init(code: ReservationCode, rsvInfo: TrainInfo? = nil, additionalInfo: String = "", moreAdditionalInfo: String = "", strResult: String = "") {
        self.code = code
        self.rsvInfo = rsvInfo
        self.additionalInfo = additionalInfo
        self.moreAdditionalInfo = moreAdditionalInfo
        self.strResult = strResult
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

struct TrainInfo: Equatable, Identifiable {
    var id = UUID()
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
struct KorailPwdPrms {
    let password: String
    let idx: String
}
struct KorailLoginParameters {
    let korailID: String
    let korailPwd: String
}
struct CurrentUserData {
    var key = ""
    var idx = ""
}
