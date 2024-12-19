//
//  ContentView.swift
//  Kort
//
//  Created by 임준협 on 12/8/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("KorailNo") var korailMBNo: String = ""
    @AppStorage("KorailPwd") var korailMBPwd: String = ""
    @State private var canBeLoggedIn: Bool = true
    var body: some View {
        VStack {
            TestView()
        }
        .fullScreenCover(isPresented: $canBeLoggedIn.not) {
            LoginView(canBeLoggedIn: $canBeLoggedIn)
        }
        .onChange(of: korailMBNo) { oV, nV in
            if nV.isEmpty {
                canBeLoggedIn = false
            }
        }
        .onChange(of: korailMBPwd) { oV, nV in
            if nV.isEmpty {
                canBeLoggedIn = false
            }
        }
        .onAppear {
            if korailMBNo.isEmpty || korailMBPwd.isEmpty {
                canBeLoggedIn = false
            }
        }
    }
    
    
}
//#Preview {
//    ContentView()
//}
extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
