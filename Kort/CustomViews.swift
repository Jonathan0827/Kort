//
//  SomeGlobalThings.swift
//  Kort
//
//  Created by 임준협 on 12/19/24.
//

import Foundation
import SwiftUI

struct GoodTextField: View {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    let focusColor: Color
    let autoCap: UITextAutocapitalizationType
    let autoCorrection: Bool
    let keyboardType: UIKeyboardType
    @FocusState var focused: Bool
    init(text: Binding<String>, placeholder: String, isSecure: Bool, focusColor: Color, autoCap: UITextAutocapitalizationType = .none, autoCorrection: Bool = false, keyboardType: UIKeyboardType = .default) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.focusColor = focusColor
        self.autoCap = autoCap
        self.autoCorrection = autoCorrection
        self.keyboardType = keyboardType
    }
    var body: some View {
        let isActive = focused || text.count > 0
        ZStack(alignment: isActive ? .topLeading : .center) {
            if isSecure {
                SecureField("", text: $text)
                    .frame(height: 24)
                    .font(.system(size: 16, weight: .regular))
                    .opacity(isActive ? 1 : 0)
                    .offset(y: 7)
                    .focused($focused)
                    .disableAutocorrection(autoCorrection)
                    .autocapitalization(autoCap)
            } else {
                TextField("", text: $text)
                    .frame(height: 24)
                    .font(.system(size: 16, weight: .regular))
                    .opacity(isActive ? 1 : 0)
                    .offset(y: 7)
                    .focused($focused)
                    .disableAutocorrection(autoCorrection)
                    .autocapitalization(autoCap)
            }
            HStack {
                Text(placeholder)
                    .foregroundColor(Color.secondary)
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .animation(.linear(duration: 0.1), value: focused)
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(Color(.goodGray))
        .cornerRadius(12)
//        .overlay {
//            RoundedRectangle(cornerRadius: 12)
////                .fill(.clear)
//                
//        }
        .onTapGesture {
            withAnimation {
                focused = true
            }
        }
        .shadow(color: focusColor.opacity(focused ? 1.0 : 0.0), radius: 2)
    }
}
struct GoodButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label    
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
// MARK: Thx to me in 2023
struct GoodTabBar: View {
    @Namespace private var animation
    @Binding var selectedTab: Int
    @State var vs1 = [CGSize]()
    @State private var vw1: [CGFloat] = [0, 0, 0]
    let tabs: [tabbartabs]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(uiColor: .systemGray6))
                .frame(height: 50)
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
            HStack {
                Spacer()
                ForEach(tabs, id: \.id) { t in
                    HStack {
                        Image(systemName: t.image)
                            .font(.system(size: 15))
                        Text(t.label)
                            .font(.system(size: 15))
                            .fontWeight(tabs.firstIndex(of: t) == selectedTab ? .bold : .regular)
                    }
                    .saveSize(in: $vs1)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
                    .foregroundColor(tabs.firstIndex(of: t) == selectedTab ? Color.white : Color(uiColor: .systemGray))
                    .background {
                        if tabs.firstIndex(of: t) == selectedTab {
                            Capsule()
                                .fill(Color(t.color))
                                .matchedGeometryEffect(id: "menuItem", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)) {
                            selectedTab = tabs.firstIndex(of: t)!
                        }
                        vw1.append(vs1[selectedTab].width)
                    }
                    Spacer()
                }
            }
        }
        .padding(.bottom, -25)
        .padding(.horizontal, 15)
        .ignoresSafeArea()
    }
}

struct tabbartabs: Identifiable, Equatable {
    var id = UUID()
    let label: String
    let image: String
    let color: Color
}
