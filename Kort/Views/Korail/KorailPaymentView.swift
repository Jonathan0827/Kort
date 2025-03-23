//
//  KorailPaymentView.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import SwiftUI

struct KorailPaymentView: View {
    let train: ReservationResult?
    let demo: Bool
    @Binding var isPresented: Bool
    @Binding var selectedCard: Card
    @Binding var complete: Bool
    @Binding var result: KorailPaymentResult
    @State private var showAddCard: Bool = false
    @State private var cardCnt: Int = 0
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("결제 \(complete ? (result.result ? "성공" : "실패") : "")")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
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
                if cardCnt == 0 {
                    VStack {
                        Spacer()
                        Button("카드를 추가해주세요", action: {
                            showAddCard = true
                        })
                        Spacer()
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("총액")
                            .fontWeight(.bold)
                        if let amount = Int(train?.reqResult?.hTotRcvdAmt ?? "0") {
                            Text("\(amount)원\(complete ? "을" : "")")
                                .font(.system(size: complete ? 55 : 40, weight: .bold))
//                                .padding(.vertical, 7)
//                                .padding(.horizontal, 15)
//                                .background{
//                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                        .fill(Color(.goodGray))
//                                        .shadow(color: .blue.opacity(complete ? 1.0 : 0), radius: 3)
//                                }
                        }
                        if complete {
                            if result.result {
                                Text("결제했어요")
                                    .font(.system(size: 25, weight: .bold))
                                VStack(alignment: .leading) {
                                    Text("결제 수단: \(selectedCard.name.isEmpty ? "신용/체크카드"  : selectedCard.name)")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                }
                            } else {
                                Text("결제하지 못했습니다")
                                    .font(.system(size: 25, weight: .bold))
                                VStack(alignment: .leading) {
                                    Text("\(result.msg)")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                    Text("KorailTalk에서 다시 결제를 해주세요")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        } else {
                            Text("결제 수단을 선택해주세요")
                                .font(.caption)
                                .foregroundStyle(.secondary)
//                                .padding(.top, 5)
                            ScrollView {
                                ForEach(1...cardCnt, id: \.self) { crd in
                                    let card = getCard(crd)
                                    if card.available {
                                        Button(action: {
                                            withAnimation {
                                                self.selectedCard = card
                                            }
                                        }, label: {
                                            HStack {
//                                                if ($selectedCard == card) {
//                                                    Image(systemImage: "checkmark")
//                                                }
                                                Text("\(card.name) - \(card.number.suffix(4))")
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(.goodGray)
                                                    .shadow(color: Color.blue.opacity(selectedCard == card ? 1 : 0), radius: 3)
                                                    

                                            }
                                        })
                                        .buttonStyle(GoodButton())
                                    }
                                }
                                .padding(5)
                                //                            .padding(.vertical)
                            }
                            .frame(height: UIScreen.main.bounds.width * 0.8)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            if getCardAmount() == 0 {
                showAddCard = true
            }
        }
        .sheet(isPresented: $showAddCard) {
            AddPaymentMethodView(cardNo: .constant(-1), isPresented: $showAddCard)
        }
        .onChange(of: showAddCard, initial: true) {
            reloadCard()
        }
    }
    private func reloadCard() {
        cardCnt = getCardAmount()
    }
}
