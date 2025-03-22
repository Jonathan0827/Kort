//
//  KorailRealReservationView.swift
//  Kort
//
//  Created by 임준협 on 3/8/25.
//

import SwiftUI

struct RealReservationView: View {
    let date: String
    let time: String
    let acs: PassengerCount
    let from: korailStations
    let to: korailStations
    let seatPref: SeatPref
    let selectedTrains: Array<TrainInfo>
    let demo: Bool
    @State private var DONE = false
    @State private var attempt = 0
    @State private var stat = ""
    @State private var reservedTrain: ReservationResult? = nil
    @State private var runFunction: Bool = true
    @Binding var currentLevel: Int
    @Binding var isPresented: Bool
    var body: some View {
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("예매 \(DONE ? "성공" : "시도중: \(attempt.description)")")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Spacer()
                        Button(action: {
                            runFunction = false
                            isPresented = false
                        }, label: {
                            Text("\(DONE ? "완료" : "취소")")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 15)
                                .background {
                                    Capsule()
                                        .fill(Color(.cprimary))
                                }
                                .foregroundStyle(Color(.mode))
                        })
                        .buttonStyle(GoodButton())
                    }
                    .padding(.horizontal)
                    if !DONE {
                        HStack {
                            Spacer()
                            VStack {
                                Text(from.rawValue)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                Text("출발 역")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, -20)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "arrow.right.circle.dotted")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .symbolRenderingMode(.palette)
                                    .symbolEffect(.pulse)
                                    .foregroundStyle(.primary, .blue)
                                Text("align")
                                    .font(.caption)
                                    .foregroundStyle(.clear)
                                    .padding(.top, -20)
                            }
                            Spacer()
                            VStack {
                                Text(to.rawValue)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                Text("도착 역")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, -20)
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading) {
                            Text("좌셕 옵션: \(seatPref.rawValue)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("인원수")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                            Text("어른: \(acs.adult)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("어린이: \(acs.child)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("노인: \(acs.senior)")
                                .font(.title3)
                                .fontWeight(.bold)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(selectedTrains, id: \.self.trainNo) { train in
                                        Text("\(train.trainShortNm)\(train.trainNo)")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal)
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color(.goodGray))
                                            }
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            if demo && !DONE {
                                Text("demo mode: will finish after 3 attempts")
                                Button("demo: stop function", action: {
                                    runFunction.toggle()
                                })
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    if DONE {
                        let journey = reservedTrain!.reqResult!.jrnyInfos.jrnyInfo[0]
                        VStack {
                            HStack {
                                VStack {
                                    HStack {
                                        Text("\(journey.hTrnClsfNm == "S-train" ? "S-train" : journey.hTrnClsfNm.prefix(3))\(journey.hTrnNo)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("\(journey.hTrnClsfNm)")
                                            .font(.caption)
                                        Spacer()
                                    }
                                }
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("\(journey.hDptRsStnNm)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text("\(journey.hDptTm.prefix(2))시 \(journey.hDptTm.dropFirst(2).prefix(2))분")
                                            .font(.caption)
                                    }
                                    Image(systemName: "arrow.right.circle.dotted")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .symbolRenderingMode(.palette)
                                        .symbolEffect(.pulse)
                                        .foregroundStyle(.primary, .blue)
                                    VStack {
                                        Text("\(journey.hArvRsStnNm)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Text("\(journey.hArvTm.prefix(2))시 \(journey.hArvTm.dropFirst(2).prefix(2))분")
                                            .font(.caption)
                                    }
                                    Spacer()
                                }
                            }
                            HStack {
                                Image(systemName: "calendar")
                                Text("\(journey.hDptDt.prefix(4))년 \(journey.hDptDt.dropFirst(4).prefix(2))월 \(journey.hDptDt.suffix(2))일")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.goodGray))
                        }
                        .padding()
                        ScrollView {
                            ForEach(journey.seatInfos.seatInfo, id: \.self.id) { seat in
                                HStack {
                                    Text("\(Int(seat.hSrcarNo)!)호차")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("\(seat.hSeatNo)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(seat.hPsrmClNm)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.goodGray))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                            }
                        }
                        if DONE {
                            Text("LetsKorail 또는 KorailTalk 앱에서 결제를 진행해 주세요")
                        }
                    }
                }
            }
        }
        .onAppear {
            if !demo {
                Task {
                    while runFunction {
                        await SearchKorailTrain(date: date, time: time, dep: from, arr: to, includeSoldOut: false, includeWaiting: true, passengers: acs) { r in
                            attempt += 1
                            selectedTrains.forEach { train in
                                for t in r {
                                    if (t.trainNo == train.trainNo && t.trainFullNm == train.trainFullNm && !DONE && runFunction) {
                                        print("\(t.trainNo): \(t.isReservable)")
                                        guard t.isReservable else { return }
                                        print("rsv psg1 pass")
                                        runFunction = false
                                        var reserveOption = RealReservationOptions(seatType: .general, passengers: acs)
                                        switch seatPref {
                                        case .generalOnly:
                                            if t.genRsv == .available {
                                                reserveOption.seatType = .general
                                            } else {
                                                print("rsv psg2 fail")
                                                runFunction = true
                                                return
                                            }
                                        case .generalFirst:
                                            if t.genRsv == .available {
                                                reserveOption.seatType = .general
                                            } else if t.speRsv == .available {
                                                reserveOption.seatType = .special
                                            } else {
                                                print("rsv psg2 fail")
                                                runFunction = true
                                                return
                                            }
                                        case .specialOnly:
                                            if t.speRsv == .available {
                                                reserveOption.seatType = .special
                                            } else {
                                                print("rsv psg2 fail")
                                                runFunction = true
                                                return
                                            }
                                        case .specialFirst:
                                            if t.speRsv == .available {
                                                reserveOption.seatType = .special
                                            } else if t.genRsv == .available {
                                                reserveOption.seatType = .general
                                            } else {
                                                print("rsv psg2 fail")
                                                runFunction = true
                                                return
                                            }
                                        }
                                        print("rsv psg2 pass")
                                        if !DONE {
                                            MakeReservation(t, reserveOption) { r in
                                                //                                        print(r)
                                                if r.strResult == "FAIL" {
                                                    runFunction = true
                                                    print("rsv fail")
                                                } else {
                                                    print("rsv suc")
                                                    print(r)
                                                    print("-------------------------------")
                                                    print("\(r.strResult!)")
                                                    let count = Int(r.reqResult!.hPsgCnt)
                                                    let journey = r.reqResult!.jrnyInfos.jrnyInfo[0]
                                                    for c in 0..<count! {
                                                        print("\(journey.seatInfos.seatInfo[c].hPsrmClNm)")
                                                        print("\(Int(journey.seatInfos.seatInfo[c].hSrcarNo)!)호차 \(journey.seatInfos.seatInfo[c].hSeatNo)")
                                                    }
                                                    print("\(journey.hTrnClsfNm)")
                                                    print("\(journey.hTrnNo)")
                                                    print("-------------------------------")
                                                    reservedTrain = r
                                                    withAnimation {
                                                        DONE = true
                                                        stat = "done"
                                                        currentLevel = 2
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 sec
                    }
                }
            } else {
                // Demo
                let demoData = ReservationResult(code: ReservationCode.success, rsvInfo: nil, additionalInfo: "", moreAdditionalInfo: "", strResult: "2025년 3월 8일 19시 57분 이내 미결제시 승차권이 자동으로 취소됩니다.", reqResult: KorailReservationResponse(hAcntApvNo: "00000000000", hNtisuLmtDt: "20250308", hPsgCnt: "0002", hMsgTxt: "결제하지 않으면 예약이 취소됩니다.", psgDiscAddInfos: PsgDiscAddInfos(psgDiscAddInfo: []), hPayCnt: "000", hPnrNo: "", hWctNo: "82002", hSeatAttDiscFlg: "", hPreStlTgtFlg: "Y", hDlayApvFlg: "", hTmpJobSqno1: "004899", hPayLimitMsg: "", hTmpJobSqno2: "000000", hNtisuLmtTm: "195748", jrnyInfos: JrnyInfos(jrnyInfo: [JrnyInfo(hJrnyTpCD: "11", hDptDt: "20250318", lumpStlTgtNo: "", hArvTm: "212700", hTotSeatCnt: "00002", seatInfos: SeatInfos(seatInfo: [SeatInfo(hDcntKndCd1: "000", hFrbsCD: "", hSeatAttCD2: "009", hEtcSeatAttCD: "", hCERTNo: "", hCERTDvCD: "", hSeatFare: "00000000000000", hTotDiscAmt: "00000000000", hDcntKndCDNm1: "", hDcntKndCd1Nm: "", hDcntKndCDNm2: "", hDiscCardUseCnt: "000000000", hDirSeatAttCD: "009", hDiscCardReCnt: "000000000", hSmkSeatAttCD: "", hPsrmClNm: "일반실", hDcntKndCd2Nm: "", hSeatPrc: "00000000008400", hDcntKndCd2: "000", hBkclsCD: "", hPsrmClCD: "1", hSeatNo: "5A", hDcntReldNo: "", hMoviePsrmFlg: "", hContSeatCnt: "0001", hLOCSeatAttCD: "012", hRqSeatAttCD: "015", hSGRNm: "", hDiscCardKnd: "", hRcvdAmt: "00000008400", hPsgTpCD: "1", hSrcarNo: "0005"), SeatInfo(hDcntKndCd1: "000", hFrbsCD: "", hSeatAttCD2: "009", hEtcSeatAttCD: "", hCERTNo: "", hCERTDvCD: "", hSeatFare: "00000000000000", hTotDiscAmt: "00000000000", hDcntKndCDNm1: "", hDcntKndCd1Nm: "", hDcntKndCDNm2: "", hDiscCardUseCnt: "000000000", hDirSeatAttCD: "009", hDiscCardReCnt: "000000000", hSmkSeatAttCD: "", hPsrmClNm: "일반실", hDcntKndCd2Nm: "", hSeatPrc: "00000000008400", hDcntKndCd2: "000", hBkclsCD: "", hPsrmClCD: "1", hSeatNo: "5B", hDcntReldNo: "", hMoviePsrmFlg: "", hContSeatCnt: "0001", hLOCSeatAttCD: "013", hRqSeatAttCD: "015", hSGRNm: "", hDiscCardKnd: "", hRcvdAmt: "00000008400", hPsgTpCD: "1", hSrcarNo: "0005")]), hTrnClsfCD: "07", hTrnNo: "195", hArvRsStnNm: "서울", hDptRsStnCD: "0390", hDptTm: "211000", hFresCnt: "00000", hSeatCnt: "000002", hObFlg: "", hTrnGpCD: "100", hDptRsStnNm: "행신", hTrnClsfNm: "KTX-산천", hArvRsStnCD: "0001", hTotStndCnt: "00000")]), hJrnyCnt: "0001", hLunchboxChgFlg: "", hMsgCD: "IRR000018", psgInfos: PsgInfos(psgInfo: [PsgInfo(hDcspNo2: "", hDcspNo: "", hDcntKndCD: "", hPsgInfoPerPrnb: "0001", hPsgTpCD: "1", hDcntKndCd2: ""), PsgInfo(hDcspNo2: "", hDcspNo: "", hDcntKndCD: "", hPsgInfoPerPrnb: "0001", hPsgTpCD: "1", hDcntKndCd2: "")]), hMsgMndry: "", hGuide: "※ 인터넷특가할인은 인터넷 또는 코레일톡에서만 할인이 적용되며, 예약 즉시 결제·발권하셔야 합니다.\n할인승차권을 역 창구에서 변경 시 할인이 취소될 수 있습니다.\n\n와이파이(WiFi) 서비스는 KTX에서 이용하실 수 있습니다.", hAddSrvFlg: "Y", strResult: "SUCC", hTableFlg: "", hDiscCnt: "0000", hDiscCrdReisuFlg: "", hFmlyInfoCfmFlg: "", hMsgTxt2: "", hMsgTxt3: "", hDlayApvTxt: "", hMsgTxt4: "", hMsgTxt5: "결제하지 않으면 예약이 취소됩니다.", hTotRcvdAmt: "0000000000016800", hNtisuLmt: "2025년 3월 8일 19시 57분 이내 미결제시 승차권이 자동으로 취소됩니다."))
                Task {
                    while runFunction {
                        attempt += 1
                        if attempt == 3 {
                            withAnimation {
                                runFunction = false
                                reservedTrain = demoData
                                DONE = true
                                stat = "done"
                                currentLevel = 2
                            }
                        }
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                    }
                }
            }
        }
    }
}
