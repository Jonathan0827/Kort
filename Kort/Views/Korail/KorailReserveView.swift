//
//  ReserveView.swift
//  Kort
//
//  Created by 임준협 on 2/27/25.
//

import SwiftUI

struct KorailReserveView: View {
    let date: String
    let time: String
    let acs: PassengerCount
    let from: korailStations
    let to: korailStations
    @Binding var isPresented: Bool
    @State private var seatPref: SeatPref = .generalFirst
    @State private var currentLevel: Int = 0
    @State private var showOptions: Bool = false
    @State private var trains = Array<TrainInfo>()
    @State private var selectedTrains = Array<TrainInfo>()
    @State private var demo: Bool = false
    @State private var reservedTrain: ReservationResult? = nil
    @State private var card: Card = Card(available: false)
    @State private var paymentInProgress: Bool = false
    @State private var showPaymentResult: Bool = false
    @State private var complete: Bool = false
    @State private var PaymentResult: KorailPaymentResult = KorailPaymentResult()
    @EnvironmentObject var globalState: GlobalState
    var body: some View {
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                VStack {
                    switch currentLevel {
                    case 0:
                        KorailTrainSelector(showOptions: $showOptions, isPresented: $isPresented, seatPref: $seatPref, trains: $trains, selectedTrains: $selectedTrains, date: date, time: time, acs: acs, from: from, to: to)
                    case 1, 2:
                        RealReservationView(date: date, time: time, acs: acs, from: from, to: to, seatPref: seatPref, selectedTrains: selectedTrains,demo: demo, reservedTrain: $reservedTrain,currentLevel: $currentLevel, isPresented: $isPresented)
                    case 3, 4:
                        KorailPaymentView(train: reservedTrain, demo: demo, isPresented: $isPresented, selectedCard: $card, complete: $complete, result: $PaymentResult)
                    default:
                        Text("Kort")
                    }
                    Spacer()
                    if demo {
                        Text("DEMO")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(5)
                            .background {
                                Capsule()
                                    .fill(.red)
                            }
                    }
                    HStack {
                        ForEach(1...3, id: \.self) { level in
                            stepView(for: level)
                        }
                    }
                    .padding(.vertical, 5)
                    if currentLevel == 0 {
                        Button(action: {
                            if isKorailLoginEmpty() {
                                globalState.showKorailLogin = true
                            } else  {
                                KorailLogin() { r in
                                    globalState.showKorailLogin = !(r.state)
                                    if r.state {
                                        globalState.KorailUserName = r.value!.strCustNm
                                        withAnimation {
                                            currentLevel = 1
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Text("선택 완료")
                                .fontWeight(.bold)
                                .foregroundStyle(!selectedTrains.isEmpty ? Color.white : Color.gray)
                                .frame(width: 360, height: 50)
                                .background {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(!selectedTrains.isEmpty ? Color(UIColor.systemBlue) : Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                        .disabled(selectedTrains.isEmpty)
                    } else if currentLevel == 2 {
                        HStack {
                            Button(action: {
                                isPresented = false
                            }, label: {
                                Text("끝내기")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.blue)
                                    .frame(width: 175, height: 50)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.blue.opacity(0.2))
                                    }
                            })
                            .buttonStyle(GoodButton())
                            Button(action: {
                                withAnimation {
                                    currentLevel = 3
                                }
                            }, label: {
                                Text("결재 진행")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 175, height: 50)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.blue)
                                    }
                            })
                            .buttonStyle(GoodButton())
                        }
                    } else if currentLevel == 3 {
                        Button(action: {
                            withAnimation {
                                paymentInProgress = true
                            }
                            if !demo {
                                KorailPayInApp(reservedTrain!.reqResult!, payment: card) { r in
                                    print(r)
                                    PaymentResult = r
                                    withAnimation {
                                        paymentInProgress = false
                                        complete = true
                                        currentLevel = 4
                                    }
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    PaymentResult = demoPayment
                                    withAnimation {
                                        paymentInProgress = false
                                        complete = true
                                        currentLevel = 4
                                    }
                                })
                            }
                        }, label: {
                            if paymentInProgress {
                                ProgressView()
                                    .foregroundStyle(Color.white)
                                    .frame(width: 360, height: 50)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.gray)
                                    }
                            } else {
                                Text("결제")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 360, height: 50)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(card.available ? Color.blue : Color.gray)
                                    }
                            }
                        })
                        .disabled(paymentInProgress || !(card.available))
                        .buttonStyle(GoodButton())
                    } else if currentLevel == 4 {
                        Button(action: {
                            isPresented = false
                        }, label: {
                            Text("완료")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .frame(width: 360, height: 50)
                                .background {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(Color.blue)
                                }
                        })
                        .buttonStyle(GoodButton())
                    }
                }
            }
            
            .sheet(isPresented: $showOptions) {
                ZStack {
                    Color(.goodBG)
                        .ignoresSafeArea()
                    List {
                        Section {
                            Picker("좌석 옵션", selection: $seatPref) {
                                ForEach(SeatPref.allCases, id: \.id) { sp in
                                    Text(sp.rawValue).tag(sp)
                                }
                            }
                        }
                        Section {
                            Toggle("Demo 활성화", isOn: $demo)
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showPaymentResult) {
                
            }
        }
    }
    @ViewBuilder
    private func stepView(for level: Int) -> some View {
        let icons = ["train.side.rear.car", "train.side.middle.car", "train.side.front.car"]
        let titles = ["선택", "예매", "결제"]
        
        VStack {
            Image(systemName: icons[level - 1])
                .foregroundStyle(currentLevel >= level ? Color.green : Color.primary)
                .font(.headline)
            Text(titles[level - 1])
                .font(.caption2)
        }
    }
}

