//
//  KorailTrainSelector.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import SwiftUI

struct KorailTrainSelector: View {
    @Binding var showOptions: Bool
    @Binding var isPresented: Bool
    @Binding var seatPref: SeatPref
    @Binding var trains: Array<TrainInfo>
    @Binding var selectedTrains: Array<TrainInfo>
    @State private var loading: Bool = true
    let date: String
    let time: String
    let acs: PassengerCount
    let from: korailStations
    let to: korailStations
    var body: some View {
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
                            VStack {
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
                                        Text("\(train.genPsbNm.split(separator: "\n").filter { $0.contains("원") }[0])")
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
                                            Text("\(train.spePsbNm.split(separator: "\n").filter { $0.contains("원") }[0])")
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
                                HStack {
                                    Image(systemName: "calendar.circle")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.primary, .blue)
                                    Text("\(getYMDString(train.depDate))")
                                        .fontWeight(.semibold)
                                        .padding(.leading, -3)
                                }
                                .padding(.bottom, -5)
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
        .onAppear {
            SearchKorailTrain(date: date, time: time, dep: from, arr: to, includeSoldOut: true, includeWaiting: true, passengers: acs) { r in
                trains = r
                withAnimation {
                    loading = false
                }
            }
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
    private func getYMDString(_ date: String) -> String {
        return "\(date.prefix(4))년 \(date.prefix(6).suffix(2))월 \(date.suffix(2))일"
    }
}
