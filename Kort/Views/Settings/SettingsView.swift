//
//  SettingsView.swift
//  Kort
//
//  Created by 임준협 on 3/15/25.
//
import SwiftUI
import AlertToast
struct SettingsView: View {
    @AppStorage("KorailNo") private var korailMBNo: String = ""
    @AppStorage("KorailPwd") private var korailMBPwd: String = ""
    @EnvironmentObject var globalState: GlobalState
    @State private var showKorailAccountInformation: Bool = false
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                List {
                    Section(header: Label("Korail 계정", systemImage: "person.circle")) {
                        if !(korailMBNo == "" || korailMBPwd == "") {
                            Button(action: {
//                                showKorailAccountInformation = true
                            }, label: {
                                HStack {
                                    Text("\(globalState.KorailUserName)")
                                    Spacer()
//                                    Image(systemName: "arrow.up.right")
//                                        .foregroundStyle(.secondary)
                                }
                                .fontWeight(.bold)
                            })
                            
                        }
                        Button(action: {
                            if korailMBNo == "" || korailMBPwd == "" {
                                globalState.showKorailLogin = true
                            } else {
                                KorailLogout()
                                withAnimation {
                                    korailMBNo = ""
                                    korailMBPwd = ""
                                }
                                globalState.showToast = true
                                globalState.toast = AlertToast(displayMode: .hud, type: .regular, title: "로그아웃 되었습니다")
                            }
                        }, label: {
                            Text(korailMBNo.isEmpty || korailMBPwd.isEmpty ? "로그인" : "로그아웃")
                                .foregroundColor(korailMBNo.isEmpty || korailMBPwd.isEmpty ? Color(.cprimary): .red)
                        })
                        
                    }
                    .listRowBackground(Color(.goodGray))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("설정")
        }
    }
}

struct Preferences: Codable {
    
}

