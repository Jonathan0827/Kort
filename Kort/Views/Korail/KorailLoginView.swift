//
//  Login.swift
//  Kort
//
//  Created by 임준협 on 12/11/24.
//

import SwiftUI
import AlertToast
struct KorailLoginView: View {
    @AppStorage("KorailNo") var korailMBNo: String = ""
    @AppStorage("KorailPwd") var korailMBPwd: String = ""
    @State private var tryingLogin: Bool = false
    @State private var showError: Bool = false
    @EnvironmentObject var globalState: GlobalState
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                Spacer()
                VStack {
                    HStack {
                        Text("Korail에 로그인")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Spacer()
                        Button(action: {
                            globalState.showKorailLogin = false
                        }, label: {
                            Text("취소")
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    GoodTextField(text: $korailMBNo, placeholder: "Korail 회원번호", isSecure: false, focusColor: Color(uiColor: UIColor.systemBlue))
                        .padding(.horizontal)
                    GoodTextField(text: $korailMBPwd, placeholder: "Korail 비밀번호", isSecure: true, focusColor: Color(uiColor: UIColor.systemBlue))
                        .padding(.horizontal)
                    if showError {
                        Text("회원번호 또는 비밀번호를 확인해주세요")
                            .foregroundStyle(.red)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button(action: {
                        tryingLogin = true
                        KorailLogin(KorailLoginParameters(korailID: korailMBNo, korailPwd: korailMBPwd)) { r in
                            print(r)
                            if r.state {
                                HapticManager.instance.notification(type: .success)
                                print("Login Successful!")
                                withAnimation {
                                    globalState.toast = AlertToast(displayMode: .hud,type: .complete(.green), title: "로그인 성공!", subTitle: "\(r.value!.strCustNm)으로 로그인 되었습니다")
                                    globalState.showToast = true
                                    tryingLogin = false
                                    globalState.KorailUserName = r.value!.strCustNm
                                    globalState.showKorailLogin = false
                                    globalState.finishedFirstKorailLogin = true
                                }
                            } else {
                                HapticManager.instance.notification(type: .error)
                                print("Login fail")
                                withAnimation {
                                    tryingLogin = false
                                    showError = true
                                }
                            }
                        }
                    }, label: {
                        if tryingLogin {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Korail 계정으로 로그인")
                                .fontWeight(.bold)
                                .foregroundStyle(!(korailMBNo.isEmpty || korailMBPwd.isEmpty) ? Color.white : Color(UIColor.systemGray2))
                        }
                    })
                    
                    .buttonStyle(LoginButtonStyle())
                    .padding()
                    .padding(.bottom, 20)
                    .disabled(korailMBNo.isEmpty || korailMBPwd.isEmpty || tryingLogin)
                }
            }
        }
    }
}
