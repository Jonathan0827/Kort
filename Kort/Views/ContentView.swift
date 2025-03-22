//
//  ContentView.swift
//  Kort
//
//  Created by 임준협 on 12/8/24.
//
import SwiftUI
import AlertToast

struct ContentView: View {
    @AppStorage("KorailNo") private var korailMBNo: String = ""
    @AppStorage("KorailPwd") private var korailMBPwd: String = ""

    @State private var tabSelection: Int = 0
    @StateObject private var globalState = GlobalState()

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.goodBG)
                .ignoresSafeArea()

            NavigationView {
                switch tabSelection {
                case 0:
                    KorailView()
                        .environmentObject(globalState)
                case 1:
                    SettingsView()
                        .environmentObject(globalState)
                default:
                    KorailView()
                }
            }
            .padding(.bottom, 50)

            GoodTabBar(
                selectedTab: $tabSelection,
                tabs: [
                    tabbartabs(label: "Korail", image: "train.side.rear.car", color: .blue),
//                    tabbartabs(label: "SRT", image: "train.side.front.car", color: .purple),
                    tabbartabs(label: "설정", image: "gear", color: .blue)
                ]
            )
        }
        .fullScreenCover(isPresented: $globalState.showKorailLogin) {
//        .sheet(isPresented: $globalState.showKorailLogin) {
            KorailLoginView()
                .environmentObject(globalState)
        }
        .toast(isPresenting: $globalState.showToast) {
            globalState.toast
        }
    }
}

class GlobalState: ObservableObject {
    @Published var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "", subTitle: "")
    @Published var showToast: Bool = false
    @Published var finishedFirstKorailLogin: Bool = false
    @Published var showKorailLogin: Bool = false
    @Published var KorailUserName: String = ""
}
