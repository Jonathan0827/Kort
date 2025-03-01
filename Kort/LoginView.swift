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
    @Binding var canBeLoggedIn: Bool
    @EnvironmentObject var globalState: stobj
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                Spacer()
                VStack {
                    GoodTextField(text: $korailMBNo, placeholder: "코레일 회원번호", isSecure: false, focusColor: Color(uiColor: UIColor.systemBlue))
                        .padding(.horizontal)
                    GoodTextField(text: $korailMBPwd, placeholder: "코레일 비밀번호", isSecure: true, focusColor: Color(uiColor: UIColor.systemBlue))
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
                                    canBeLoggedIn = true
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
                            Text("코레일 계정으로 로그인")
                                .fontWeight(.bold)
                                .foregroundStyle(!(korailMBNo.isEmpty || korailMBPwd.isEmpty) ? Color.white : Color(UIColor.systemGray2))
                        }
                    })
                    
                    .buttonStyle(LoginButtonStyle())
                    .padding()
                    .padding(.bottom, 20)
                    .disabled(korailMBNo.isEmpty || korailMBPwd.isEmpty || tryingLogin)
                }
                .navigationTitle("로그인")
            }
        }
    }
}

struct LoginButtonStyle: ButtonStyle {
    @AppStorage("KorailNo") var korailMBNo: String = ""
    @AppStorage("KorailPwd") var korailMBPwd: String = ""
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 360, height: 60)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(!(korailMBNo.isEmpty || korailMBPwd.isEmpty) ? Color(UIColor.systemBlue) : Color(UIColor.systemGray5))
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}


//#Preview {
//    LoginView(canBeLoggedIn: .constant(false))
//}
