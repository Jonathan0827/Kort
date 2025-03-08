//
//  TestView.swift
//  Kort
//
//  Created by 임준협 on 12/11/24.
//

import SwiftUI
import AlertToast

struct KorailView: View {
    @AppStorage("KorailNo") var korailMBNo: String = ""
    @AppStorage("KorailPwd") var korailMBPwd: String = ""
    @State private var date: Date = Date()
    @State private var time: String = "00"
    @State private var ymd: [String] = ["0000","00","00"]
    @State private var timeString: String = ""
    @AppStorage("KorailDep") private var dep: korailStations = .daejeon
    @AppStorage("KorailArr") private var arr: korailStations = .seoul
    @State private var console: String = ""
    @State private var trainList: [TrainInfo] = [TrainInfo]()
    @State private var selindx: Int = 0
    @State private var openReservation: Bool = false
    @State private var acs: PassengerCount = PassengerCount(adult: 1)
    @State private var showDateAndTimePicker: Bool = false
    @State private var showStationPicker: Bool = false
    @EnvironmentObject var globalState: GlobalState
    @State private var loginKorail: Bool = true
    @State private var selectedArrDep: Int = 0
    
    @State var calSize: [CGSize] = [CGSize]()
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            withAnimation {
                                selectedArrDep = 1
                                showStationPicker = true
                            }
                        }, label: {
                            Text(dep.rawValue)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.goodGray))
                                        .shadow(color: .blue.opacity(selectedArrDep == 1 ? 1.0 : 0), radius: 3)
                                }
                        })
                        .buttonStyle(GoodButton())
                        Text("출발 역")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
                    }
                    Spacer()
                    VStack {
                        Button(action: {
                            withAnimation {
                                selectedArrDep = 2
                                showStationPicker = true
                            }
                        }, label: {
                            Text(arr.rawValue)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.goodGray))
                                        .shadow(color: .blue.opacity(selectedArrDep == 2 ? 1.0 : 0), radius: 3)
                                }
                        })
                        .buttonStyle(GoodButton())
                        Text("도착 역")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                Text("출발일, 시간")
                    .font(.title)
                    .fontWeight(.bold)
                Button(action: {
                    withAnimation {
                        showDateAndTimePicker = true
                    }
                }, label: {
                    Text("\(ymd[0])년 \(ymd[1])월 \(ymd[2])일 \(time)시")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.goodGray))
                                .shadow(color: .blue.opacity(showDateAndTimePicker ? 1.0 : 0), radius: 3)
                        }
                })
                .buttonStyle(GoodButton())
                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                Text("탑승 인원")
                    .font(.title)
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    HStack {
                        Text("성인")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(acs.adult)명")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            withAnimation {
                                acs.adult += 1
                            }
                        }, label: {
                            Text("+")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                        .padding(.trailing, -5)
                        Button(action: {
                            withAnimation {
                                acs.adult -= 1
                            }
                        }, label: {
                            Text("-")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                    }
                    HStack {
                        Text("어린이")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(acs.child)명")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            withAnimation {
                                acs.child += 1
                            }
                        }, label: {
                            Text("+")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                        .padding(.trailing, -5)
                        Button(action: {
                            withAnimation {
                                acs.child -= 1
                            }
                        }, label: {
                            Text("-")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                    }
                    HStack {
                        Text("노인")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(acs.senior)명")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            withAnimation {
                                acs.senior += 1
                            }
                        }, label: {
                            Text("+")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                        .padding(.trailing, -5)
                        Button(action: {
                            withAnimation {
                                acs.senior -= 1
                            }
                        }, label: {
                            Text("-")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, -3)
                                .frame(width: 25, height: 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.goodGray))
                                }
                        })
                        .buttonStyle(GoodButton())
                    
                    }
                }
                .padding(.horizontal, 20)
                Button(action: {
                    withAnimation {
                        openReservation = true
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("열차 조회")
//                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .frame(height: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                    }
                })
                .padding(.top, 30)
                .padding(.horizontal, 15)
                .buttonStyle(GoodButton())
            }
            .navigationTitle("Korail")
            .onChange(of: date, initial: true) { oV, nV in
                let df = DateFormatter()
                df.dateFormat = "yyyy"
                ymd[0] = df.string(from: nV)
                df.dateFormat = "MM"
                ymd[1] = df.string(from: nV)
                df.dateFormat = "dd"
                ymd[2] = df.string(from: nV)
            }
            .onChange(of: time, initial: true) { oV, nV in
                timeString = "\(nV)0000"
            }
            .fullScreenCover(isPresented: $openReservation) {
                KorailReserveView(date: ymd[0]+ymd[1]+ymd[2], time: timeString, acs: acs, from: dep, to: arr, isPresented: $openReservation)
            }
            .sheet(isPresented: $showDateAndTimePicker){
                ZStack {
                    Color(.goodBG)
                        .ignoresSafeArea()
                    DateAndTimeSelector(date: $date, time: $time, showDateAndTimeSelector: $showDateAndTimePicker)
                    .padding()
                    .saveSize(in: $calSize)
                }
                .presentationDetents(
                    calSize.first.map { [.height($0.height)] } ?? [.medium]
                )
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $loginKorail.not) {
                KorailLoginView(canBeLoggedIn: $loginKorail)
            }
            .sheet(isPresented: $showStationPicker, onDismiss: {
                withAnimation {
                    selectedArrDep = 0
                }
            }) {
                ZStack {
                    Color(.goodBG)
                        .ignoresSafeArea()
                    StationSelector(selectedArrDep: $selectedArrDep, dep: $dep, arr: $arr)
                    .padding(.top)
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.visible)
            }
//            .onChange(of: korailMBNo) { oV, nV in
//                if nV.isEmpty {
//                    loginKorail = false
//                }
//            }
//            .onChange(of: korailMBPwd) { oV, nV in
//                if nV.isEmpty {
//                    loginKorail = false
//                }
//            }
            .onChange(of: selectedArrDep) { oV, nV in
                showStationPicker = (nV != 0)
            }
            .onAppear {
                let df = DateFormatter()
                df.dateFormat = "HH"
                time = df.string(from: Date())
                if korailMBNo.isEmpty || korailMBPwd.isEmpty {
                    loginKorail = false
                } else  {
                    KorailLogin(KorailLoginParameters(korailID: korailMBNo, korailPwd: korailMBPwd)) { r in
                        loginKorail = r.state
                        if r.state && !globalState.finishedFirstKorailLogin {
                            print(r.value!.strMBCrdNo)
                            globalState.toast = AlertToast(displayMode: .hud,type: .complete(.green), title: "로그인 성공!", subTitle: "\(r.value!.strCustNm)으로 로그인 되었습니다")
                            globalState.showToast = true
                        }
                        globalState.finishedFirstKorailLogin = r.state
                    }
                }
            }
        }
    }
}
