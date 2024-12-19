//
//  SomeGlobalThings.swift
//  Kort
//
//  Created by 임준협 on 12/19/24.
//

import Foundation
import SwiftUI
class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
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
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .animation(.linear(duration: 0.1), value: focused)
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(Color(uiColor: UIColor.systemGray6))
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? focusColor : .clear, lineWidth: 1)
        }
        .onTapGesture {
            focused = true
        }
    }
}

enum errors: Error {
    case DecodeError
}
