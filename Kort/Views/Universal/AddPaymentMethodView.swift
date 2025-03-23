//
//  AddPaymentMethodView.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import SwiftUI

struct AddPaymentMethodView: View {
    @State private var cardNumber: String
    @State private var cardBD: String
    @State private var cardExpirationDate: String
    @State private var cardPwd: String
    @State private var cardName: String
    @Binding private var cardNo: Int
    @Binding var isPresented: Bool
    init(cardNumber: String = "", cardBD: String = "", cardExpirationDate: String = "", cardPwd: String = "", cardName: String = "", cardNo: Binding<Int>, isPresented: Binding<Bool>) {
        self.cardNumber = cardNumber
        self.cardBD = cardBD
        self.cardExpirationDate = cardExpirationDate
        self.cardPwd = cardPwd
        self.cardName = cardName
        self._cardNo = cardNo
        self._isPresented = isPresented
    }
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("카드 \(cardNo == -1 ? "추가" : "수정")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    if cardNo != -1 {
                        Button(action: {
                            removeCard(cardNo)
                            isPresented = false
                        }, label: {
                            Image(systemName: "trash.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(7)
                                .background {
                                    Capsule()
                                        .fill(.red)
                                }
                                .foregroundStyle(.white)
                        })
                        .buttonStyle(GoodButton())
                    }
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(7)
                            .background {
                                Capsule()
                                    .fill(Color(.cprimary))
                            }
                            .foregroundStyle(Color(.mode))
                    })
                    .buttonStyle(GoodButton())
                }
                .padding(.top, 30)
                VStack(spacing: 10) {
                    GoodTextField(text: $cardNumber, placeholder: "카드 번호", isSecure: true, focusColor: Color.blue)
                    GoodTextField(text: $cardBD, placeholder: "생년월일 (YYMMDD) / 사업자등록번호", isSecure: false, focusColor: Color.blue)
                    GoodTextField(text: $cardExpirationDate, placeholder: "만료일 (YYMM)", isSecure: false, focusColor: Color.blue)
                    GoodTextField(text: $cardPwd, placeholder: "카드 비밀번호 앞 2자리", isSecure: true, focusColor: Color.blue)
                    GoodTextField(text: $cardName, placeholder: "카드 별칭", isSecure: false, focusColor: Color.blue)
                }
                Spacer()
                Button(action: {
                    if cardNo == -1 {
                        print(addCard(cardNumber, cardPwd, cardExpirationDate, cardBD, cardName))
                    } else {
                        print(editCard(cardNo, cardNumber, cardPwd, cardExpirationDate, cardBD, cardName))
                        cardNo = -1
                    }
                    isPresented = false
                }, label: {
                    Text("\(cardNo == -1 ? "추가" : "수정")")
                        .fontWeight(.bold)
                        .foregroundStyle(readyToAdd() ? Color.gray : Color.white)
                        .frame(width: 360, height: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(readyToAdd() ? Color(.goodGray) : Color(UIColor.systemBlue))
                        }
                        .disabled(!readyToAdd())
                })
                .buttonStyle(GoodButton())
            }
            .padding(.horizontal)
        }
        .onAppear {
            if cardNo != -1 {
                let card = getCard(cardNo)
                cardNumber = card.number
                cardBD = card.birth
                cardPwd = card.pwd
                cardExpirationDate = card.exp
                cardName = card.name
            }
        }
    }
    private func readyToAdd() -> Bool {
        return (cardNumber.isEmpty || cardBD.isEmpty || cardExpirationDate.isEmpty || cardPwd.isEmpty || cardName.isEmpty)
    }
}
