//
//  DateAndTimeSelector.swift
//  Kort
//
//  Created by 임준협 on 3/1/25.
//

import SwiftUI

struct DateAndTimeSelector: View {
    @Binding var date: Date
    @Binding var time: String
    @Binding var showDateAndTimeSelector: Bool
    var body: some View {
        VStack {
            Text("출발일")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, -10)
            DatePicker("출발일", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
            Text("출발 시간")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, -10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0...24, id: \.self) { h in
                        Button(action: {
                            withAnimation {
                                time = h < 10 ? "0\(h)" : "\(h)"
                            }
                        }, label: {
                            Text(h < 10 ? "0\(h)" : "\(h)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background{
                                    Circle()
                                        .fill(Color(.goodGray))
                                        .shadow(color: .blue.opacity((h < 10 ? "0\(h)" : "\(h)") == time ? 1.0 : 0.0), radius: 3)
                                }
                        })
                        .scaleEffect((h < 10 ? "0\(h)" : "\(h)") == time ? 1.2 : 1.0)
                        .buttonStyle(GoodButton())
                    }
                }
                .padding()
            }
            .ignoresSafeArea()
            .padding(.top, -10)
            Button(action: {
                withAnimation {
                    showDateAndTimeSelector = false
                }
            }, label: {
                HStack {
                    Spacer()
                    Text("확인")
//                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.blue)
                }
                .ignoresSafeArea()
            })
            .padding(.horizontal, 15)
            .buttonStyle(GoodButton())
        }
    }
}
