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
    @Binding var reservedTrain: ReservationResult?
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
                        if !DONE {
                            Button(action: {
                                runFunction = false
                                isPresented = false
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(7)
                                    .background {
                                        Capsule()
                                            .fill(Color(.cprimary))
                                    }
                                    .foregroundStyle(Color(.mode))
                            })
                            .buttonStyle(GoodButton())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
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
                                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                                                        withAnimation {
                                                            DONE = true
                                                            
                                                            stat = "done"
                                                            currentLevel = 2
                                                        }
                                                    })
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
                Task {
                    while runFunction {
                        attempt += 1
                        if attempt == 3 {
                            runFunction = false
                            reservedTrain = demoReservation
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                                withAnimation {
                                    DONE = true
                                    stat = "done"
                                    currentLevel = 2
                                }
                            })
                        }
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                    }
                }
            }
        }
    }
}
