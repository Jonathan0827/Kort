//
//  SettingsView.swift
//  Kort
//
//  Created by 임준협 on 3/15/25.
//
import SwiftUI
import AlertToast
struct SettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var showKorailAccountInformation: Bool = false
    @State private var showAddPaymentView: Bool = false
    @State private var selectedCrd: Int = -1
    @State private var cardCnt: Int = 0
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                List {
                    Section(header: Label("Korail 계정", systemImage: "person.circle")) {
                        if !(isKorailLoginEmpty()) {
                            Button(action: {
                                //                                showKorailAccountInformation = true
                            }, label: {
                                HStack {
                                    Text("\(globalState.KorailUserName)")
                                    Spacer()
                                    
                                }
                                .fontWeight(.bold)
                            })
                            
                        }
                        Button(action: {
                            if isKorailLoginEmpty() {
                                globalState.showKorailLogin = true
                            } else {
                                KorailLogout()
                                withAnimation {
                                    saveKorailLogin(["",""])
                                }
                                globalState.showToast = true
                                globalState.toast = AlertToast(displayMode: .hud, type: .regular, title: "로그아웃 되었습니다")
                            }
                        }, label: {
                            Text(isKorailLoginEmpty() ? "로그인" : "로그아웃")
                                .foregroundStyle(isKorailLoginEmpty() ? .blue: .red)
                        })
                        
                    }
                    .listRowBackground(Color(.goodGray))
                    if cardCnt > 0 {
                        Section(header: Label("결제 수단", systemImage: "creditcard.circle")) {
                            ForEach(1...cardCnt, id: \.self) { crd in
                                let card = getCard(crd)
                                if card.available {
                                    Button(action: {
                                        selectedCrd = crd
                                        showAddPaymentView = true
                                    }, label: {
                                        HStack {
                                            Text("\(card.name) (\(card.number.suffix(4)))")
                                            Image(systemName: "arrow.up.right")
                                                .foregroundStyle(.secondary)
                                        }
                                    })
                                }
                            }
                        }
                        .listRowBackground(Color(.goodGray))
                    }
                    Section(header: Label("결제 수단 관리", systemImage: "creditcard.and.123")) {
                        Button(action: {
                            selectedCrd = -1
                            showAddPaymentView = true
                        }, label: {
                            Text("결제 수단 등록")
                                .foregroundStyle(.blue)
                        })
                    }
                    .listRowBackground(Color(.goodGray))
                    Section(header: Label("기타", systemImage: "gearshape.2")) {
                        Button(action: {
                            resetKeychain()
                        }, label: {
                            Text("Keychain 초기화")
                                .foregroundStyle(.red)
                        })
                    }
                    .listRowBackground(Color(.goodGray))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("설정")
        }
        .sheet(isPresented: $showAddPaymentView) {
            AddPaymentMethodView(cardNo: $selectedCrd, isPresented: $showAddPaymentView)
        }
        .onChange(of: showAddPaymentView, initial: true) {
            reloadCard()
        }
    }
    private func reloadCard() {
        cardCnt = getCardAmount()
    }
}

struct Preferences: Codable {
    
}

