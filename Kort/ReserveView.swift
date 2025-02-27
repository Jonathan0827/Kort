//
//  ReserveView.swift
//  Kort
//
//  Created by 임준협 on 2/27/25.
//

import SwiftUI

struct ReserveView: View {
    let date: String
    let time: String
    let acs: PassengerCount
    let from: korailStations
    let to: korailStations
    @State private var seatPref: SeatPref = .generalFirst
    @Binding var isPresented: Bool
    @State private var showRealReservation: Bool = false
    @State private var loading: Bool = true
    @State private var trains = Array<TrainInfo>()
    @State private var selectedTrains = Array<TrainInfo>()
    var body: some View {
        NavigationView {
            VStack {
                Text("Train departing for \(to.rawValue) from \(from.rawValue) on \(date) at \(time)")
                    .font(.caption)
                Text("Adult: \(acs.adult), Child: \(acs.child), Senior: \(acs.senior)")
                    .font(.caption2)
                ScrollView {
                    ForEach(trains, id: \.id) { train in
                        HStack {
                            Button(action: {
                                if selectedTrains.contains(train) {
                                    if let index = selectedTrains.firstIndex(of: train) {
                                        selectedTrains.remove(at: index)
                                    }

                                } else {
                                    selectedTrains.append(train)
                                }
                            }, label: {
                                if selectedTrains.contains(train) {
                                    Text("✅")
                                } else {
                                    Text("🟥")
                                }
                            })
                            Text("\(train.trainFullNm): \(train.trainShortNm)\(train.trainNo) 일반석: \(train.genPsbNm.split(separator: "\n")[0]) 특실: \(train.spePsbNm.split(separator: "\n")[0]) \(train.depTime) -> \(train.arrTime)")
                            Spacer()
                        }
                        .padding()
                    }
                }
                Button(action: {
                    showRealReservation = true
                }, label: {
                    Text("Start Reservation")
                        .foregroundStyle(!selectedTrains.isEmpty ? Color.white : Color.gray)
                        
                })
                .frame(width: 360, height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(!selectedTrains.isEmpty ? Color(UIColor.systemBlue) : Color(UIColor.systemGray5))
                }
                .disabled(selectedTrains.isEmpty)
            }
            .navigationTitle("Reservation")
            .toolbar {
                Button("Close") {
                    isPresented = false
                }
            }
            .onAppear {
                SearchKorailTrain(date: date, time: time, dep: from, arr: to, includeSoldOut: true, includeWaiting: true, passengers: acs) { r in
                    trains = r
                    loading = false
                }
            }
            .sheet(isPresented: $showRealReservation) {
                RealReservationView(date: date, time: time, acs: acs, from: from, to: to, seatPref: seatPref, selectedTrains: selectedTrains, isPresented: $showRealReservation)
            }
        }
    }
}

struct RealReservationView: View {
    let date: String
    let time: String
    let acs: PassengerCount
    let from: korailStations
    let to: korailStations
    let seatPref: SeatPref
    let selectedTrains: Array<TrainInfo>
    @State private var DONE = false
    @Binding var isPresented: Bool
    @State private var attempt = 0
    @State private var stat = ""
    var body: some View {
        VStack {
            HStack {
                ForEach(selectedTrains, id: \.self.trainNo) { train in
                    Text("\(train.trainShortNm)\(train.trainNo)")
                }
            }
            Button(action: {
                DONE = true
                isPresented = false
            }, label: {
                Text("STOP")
            })
            Text(attempt.description)
            Text(stat)
        }
        .onAppear {
            Task {
                while !DONE {
                    await SearchKorailTrain(date: date, time: time, dep: from, arr: to, includeSoldOut: false, includeWaiting: true, passengers: acs) { r in
                        selectedTrains.forEach { train in
                            print("Trying \(train.trainNo)")
                            attempt += 1
                            for t in r {
                                if (t.trainNo == train.trainNo && t.trainFullNm == train.trainFullNm && !DONE) {
                                    print(t.trainNo)
                                    print(t.isReservable)
                                    guard t.isReservable else { return }
                                    var reserveOption = RealReservationOptions(seatType: .general, passengers: acs)
                                    switch seatPref {
                                    case .generalOnly:
                                        if train.genRsv == .available {
                                            reserveOption.seatType = .general
                                        } else {
                                            return
                                        }
                                    case .generalFirst:
                                        if train.genRsv == .available {
                                            reserveOption.seatType = .general
                                        } else if train.speRsv == .available {
                                            reserveOption.seatType = .special
                                        } else {
                                            return
                                        }
                                    case .specialOnly:
                                        if train.speRsv == .available {
                                            reserveOption.seatType = .special
                                        } else {
                                            return
                                        }
                                    case .specialFirst:
                                        if train.speRsv == .available {
                                            reserveOption.seatType = .special
                                        } else if train.genRsv == .available {
                                            reserveOption.seatType = .general
                                        } else {
                                            return
                                        }
                                    }
                                    DONE = true
                                    MakeReservation(t, reserveOption) { r in
//                                        debugPrint(r)
                                        if r.strResult == "FAIL" {
                                            DONE = false
                                        } else {
                                            print("DONNNNE")
                                            stat = "OHHHHHHHHHHH"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // Poll every 1 second
                }
            }
        }
        
    }
}
