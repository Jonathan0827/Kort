//
//  Extensions.swift
//  Kort
//
//  Created by 임준협 on 2/28/25.
//

import Foundation
import SwiftUI

extension View {
    func saveSize(in size: Binding<[CGSize]>) -> some View {
        modifier(SCalc(size: size))
    }
}
struct SCalc: ViewModifier {
    
    @Binding var size: [CGSize]
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size.append(proxy.size)
//                            print(proxy.size)
                        }
                }
            )
    }
}
extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
