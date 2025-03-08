//
//  ContentView.swift
//  Kort
//
//  Created by 임준협 on 12/8/24.
//

//import SwiftUI
//import AlertToast
//struct ContentView: View {
//    @AppStorage("KorailNo") var korailMBNo: String = ""
//    @AppStorage("KorailPwd") var korailMBPwd: String = ""
//    @State private var canBeLoggedIn: Bool = true
//    @State private var tabSelection: Int = 0
//    @StateObject private var globalState = stobj()
//    var body: some View {
//        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
//            Color(.goodBG)
//                .ignoresSafeArea()
//            NavigationView {
//                switch tabSelection {
//                case 0:
//                    KorailView()
//                        .environmentObject(globalState)
//                case 1:
//                    //                    SRTView()
//                    Text("Not ready yet")
//                case 2:
//                    Text("Not ready yet")
//                    //                    SettingsView()
//                    
//                default:
//                    KorailView()
//                }
//            }
//            .padding(.bottom, 50)
//            GoodTabBar(selectedTab: $tabSelection, tabs: [tabbartabs(label: "Korail", image: "train.side.rear.car", color: Color.blue), tabbartabs(label: "SRT", image:"train.side.front.car", color: Color.purple), tabbartabs(label: "설정", image:"gear", color: Color.blue)])
//        }
//        .toast(isPresenting: $globalState.showToast) {
//            globalState.toast
//        }
//    }
//    
//    
//}
//
//class stobj: ObservableObject {
//    @Published var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "", subTitle: "")
//    @Published var showToast: Bool = false
//    @Published var finishedFirstKorailLogin: Bool = false
//}
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
                case 1, 2:
                    PlaceholderView(text: "Not ready yet")
                default:
                    KorailView()
                }
            }
            .padding(.bottom, 50)

            GoodTabBar(
                selectedTab: $tabSelection,
                tabs: [
                    tabbartabs(label: "Korail", image: "train.side.rear.car", color: .blue),
                    tabbartabs(label: "SRT", image: "train.side.front.car", color: .purple),
                    tabbartabs(label: "설정", image: "gear", color: .blue)
                ]
            )
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
}

struct PlaceholderView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}
