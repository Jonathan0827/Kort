//
//  TestView.swift
//  Kort
//
//  Created by 임준협 on 12/11/24.
//

import SwiftUI

struct TestView: View {
    @AppStorage("KorailNo") var korailMBNo: String = ""
    @AppStorage("KorailPwd") var korailMBPwd: String = ""
    @State private var date: String = ""
    @State private var time: String = ""
    @State private var dep: korailStations = .busan
    @State private var arr: korailStations = .seoul
    @State private var console: String = ""
    @State private var trainList: [TrainInfo] = [TrainInfo]()
    @State private var selindx: Int = 0
    var body: some View {
        VStack {
            TextField("Korail mb no", text: $korailMBNo)
            TextField("Korail mb pwd", text: $korailMBPwd)
            TextField("Date yymmdd", text: $date)
            TextField("Time hhmmss", text: $time)
            Button(action: {
                login(KorailLoginParameters(korailID: korailMBNo, korailPwd: korailMBPwd)) { loginData in
                    console = console + ("-------------<Login Info>-------------\n")
                    console = console + ("Name: \(loginData.value!.strCustNm)\n")
                    console = console + ("Member No. : \(loginData.value!.strMBCrdNo)\n")
                    console = console + ("Email Address: \(loginData.value!.strEmailAdr)\n")
                    console = console + ("--------------------------------------\n")
                }
            }, label: {
                Text("Login")
            })
            Button(action: {
                logout()
            }, label: {
                Text("Log Out")
            })
            Button(action: {
                getTickets()
            }, label: {
                Text("GTKT")
            })
            Button(action: {
                getReservations()
            }, label: {
                Text("GTRV")
            })
            Picker(selection: $dep, label: Text("Dep")) {
                ForEach(korailStations.allCases) { st in
                    Text("\(st.id)")
                }
            }
            Picker(selection: $arr, label: Text("arr")) {
                ForEach(korailStations.allCases) { st in
                    Text("\(st.id)")
                }
            }
            Button(action: {
                SearchKorailTrain(date: "20241212", time: "000000", dep: .seoul, arr: .haengsin, includeSoldOut: true, includeWaiting: true, passengers: PassengerCount(adult: 1)) {trarr in
                    trainList = trarr
                    for train in trarr {
                        console = console + ("-------------<Train Info>-------------\n")
                        console = console + ("Type: \(train.trainFullNm)\n")
                        console = console + ("Train No. \(train.trainShortNm)\(train.trainNo)\n")
                        console = console + ("Can be reserved: \(train.isReservable)\n")
                        console = console + ("Gen avb: \(train.genRsv)\n")
                        console = console + ("Spe avb: \(train.speRsv)\n")
                        console = console + ("Gen price: \(train.genPsbNm.split(separator: "\n")[0])\n")
                        console = console + ("Spe price: \(train.spePsbNm.split(separator: "\n")[0])\n")
                        console = console + ("Properties: gr \(train.genRsv.rawValue)\nsr\(train.speRsv.rawValue)\n")
                        console = console + ("--------------------------------------")
                    }
                }
            }, label: {
                Text("Search Train")
            })
            TextField("index", value: $selindx, formatter: NumberFormatter())
            Button(action: {
                Reserve(trainList[selindx], ReservationOptions(seatPref: .generalOnly, passengers: PassengerCount(adult: 0, child: 1, senior: 0))) { r in
                    debugPrint(r)
                }
            }, label: {
                Text("GTRV")
            })
            ScrollView {
                Text("\(console)")
            }
        }
    }
}
