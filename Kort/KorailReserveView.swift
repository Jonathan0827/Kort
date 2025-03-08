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
    @State private var seatPref: SeatPref = .generalFirst
    @Binding var isPresented: Bool
    @State private var loading: Bool = true
    @State private var trains = Array<TrainInfo>()
    @State private var selectedTrains = Array<TrainInfo>()
    @State private var currentLevel: Int = 0
    @State private var showOptions: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                VStack {
                    switch currentLevel {
                    case 0:
                        VStack {
                            HStack {
                                Text("열차 예매")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                Spacer()
                                Button(action: {
                                    showOptions = true
                                }, label: {
                                    Text("옵션 변경")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 10)
                                        .background {
                                            Capsule()
                                                .fill(Color(.cprimary))
                                        }
                                        .foregroundStyle(Color(.mode))
                                })
                                .buttonStyle(GoodButton())
                                Button(action: {
                                    isPresented = false
                                }, label: {
                                    //                            Text("취소")
                                    Image(systemName: "xmark")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(7)
                                    //                                .padding(.vertical, 5)
                                        .background {
                                            Capsule()
                                                .fill(Color(.cprimary))
                                        }
                                        .foregroundStyle(Color(.mode))
                                })
                                .buttonStyle(GoodButton())
                            }
                            .padding(.horizontal)
                            .padding(.top, 30)
                            if loading {
                                VStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .padding()
                                    Text("열차 조회 중")
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            } else if trains.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("조회된 열차가 없습니다")
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            } else {
                                ScrollView {
                                    ForEach(trains, id: \.id) { train in
                                        Button(action: {
                                            if selectedTrains.contains(train) {
                                                if let index = selectedTrains.firstIndex(of: train) {
                                                    withAnimation {
                                                        selectedTrains.remove(at: index)
                                                    }
                                                }
                                            } else {
                                                withAnimation {
                                                    selectedTrains.append(train)
                                                }
                                            }
                                        }, label: {
                                            HStack {
                                                VStack {
                                                    HStack {
                                                        Text("\(train.trainShortNm)\(train.trainNo)")
                                                            .font(.title3)
                                                            .fontWeight(.bold)
                                                        Spacer()
                                                    }
                                                    
                                                    HStack {
                                                        
                                                        Text("\(train.trainFullNm)")
                                                            .font(.caption2)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        VStack {
                                                            Text("\(train.depStnNm)")
                                                                .fontWeight(.bold)
                                                            Text("\(train.depTime.prefix(2))시 \(train.depTime.dropFirst(2).prefix(2))분")
                                                                .font(.caption)
                                                        }
                                                        Image(systemName: "arrow.right.circle.dotted")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .symbolRenderingMode(.palette)
                                                        //                                                .symbolEffect(.pulse)
                                                            .foregroundStyle(.primary, .blue)
                                                        VStack {
                                                            Text("\(train.arrStnNm)")
                                                                .fontWeight(.bold)
                                                            Text("\(train.arrTime.prefix(2))시 \(train.arrTime.dropFirst(2).prefix(2))분")
                                                                .font(.caption)
                                                        }
                                                        Spacer()
                                                    }
                                                }
                                                VStack(alignment: .leading) {
                                                    Text("일반실")
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                    Text("\(train.genPsbNm.split(separator: "\n")[0])")
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                    ZStack(alignment: .leading) {
                                                        Text("\(train.genRsv == .soldout ? "매진" : "예매 가능")")
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                        Text("00,000원") //align
                                                            .font(.caption)
                                                            .foregroundStyle(.clear)
                                                    }
                                                }
                                                VStack(alignment: .leading) {
                                                    Text("특/우등")
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                    if train.speRsv == .noseattype {
                                                        Text("-")
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                        Text("00,000원") //align
                                                            .font(.caption)
                                                            .foregroundStyle(.clear)
                                                    } else {
                                                        Text("\(train.spePsbNm.split(separator: "\n")[0])")
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                        ZStack(alignment: .leading) {
                                                            Text("\(train.speRsv == .soldout ? "매진" : "예매 가능")")
                                                                .font(.caption)
                                                                .fontWeight(.bold)
                                                            Text("00,000원") //align
                                                                .font(.caption)
                                                                .foregroundStyle(.clear)
                                                        }
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color(.goodGray))
                                                    .shadow(color: .blue.opacity(selectedTrains.contains(train) ? 1.0 : 0), radius: 5)
                                            }
                                            .overlay {
                                                if train.speRsv == .noseattype && seatPref == .specialOnly {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .fill(Color(.goodGray).opacity(0.9))
                                                        Text("이 열차는 선택된 좌석 옵션(\(getStringFromSeatPref()))을 충족하지 않습니다")
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                    }
                                                    .onAppear {
                                                        if selectedTrains.contains(train) {
                                                            if let index = selectedTrains.firstIndex(of: train) {
                                                                withAnimation {
                                                                    selectedTrains.remove(at: index)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(train.speRsv == .noseattype && seatPref == .specialOnly)
                                        .buttonStyle(GoodButton())
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                    }
                                }
                                .padding(.top, -15)
                            }
                            
                        }
                        
                    case 1, 2:
                        RealReservationView(date: date, time: time, acs: acs, from: from, to: to, seatPref: seatPref, selectedTrains: selectedTrains,demo: false, currentLevel: $currentLevel, isPresented: $isPresented)
                    default:
                        Text("Kort")
                    }
                    Spacer()
                    HStack {
                        ForEach(1...3, id: \.self) { level in
                            stepView(for: level)
                        }
                    }
                    .padding(.vertical, 5)
                    if currentLevel == 0 {
                        Button(action: {
                            withAnimation {
                                currentLevel = 1
                            }
                        }, label: {
                            Text("선택 완료")
                                .fontWeight(.bold)
                                .foregroundStyle(!selectedTrains.isEmpty ? Color.white : Color.gray)
                                .frame(width: 360, height: 60)
                                .background {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(!selectedTrains.isEmpty ? Color(UIColor.systemBlue) : Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                        .disabled(selectedTrains.isEmpty)
                    }
                }
            }
            .onAppear {
                SearchKorailTrain(date: date, time: time, dep: from, arr: to, includeSoldOut: true, includeWaiting: true, passengers: acs) { r in
                    trains = r
                    withAnimation {
                        loading = false
                    }
                }
            }
            .sheet(isPresented: $showOptions) {
                ZStack {
                    Color(.goodBG)
                        .ignoresSafeArea()
                    VStack {
                        HStack {
                            Picker("좌석 옵션", selection: $seatPref) {
                                Text("일반실만").tag(SeatPref.generalOnly)
                                Text("일반실 우선").tag(SeatPref.generalFirst)
                                Text("특/우등실만").tag(SeatPref.specialOnly)
                                Text("특/우등실 우선").tag(SeatPref.specialFirst)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .buttonStyle(GoodButton())
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.goodGray))
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
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
    private func getStringFromSeatPref() -> String {
        switch seatPref {
        case .generalOnly:
            return "일반실만"
        case .generalFirst:
            return "일반실 우선"
        case .specialOnly:
            return "특/우등실만"
        case .specialFirst:
            return "특/우등실 우선"
        }
    }
}

