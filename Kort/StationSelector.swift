//
//  StationSelector.swift
//  Kort
//
//  Created by 임준협 on 3/1/25.
//

import SwiftUI

struct StationSelector: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var selectedArrDep: Int
    @Binding var dep: korailStations
    @Binding var arr: korailStations
    @Namespace var namespace
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    if selectedArrDep == 1 {
                        Spacer()
                    }
                    Button(action: {
                        withAnimation {
                            selectedArrDep = 1
                        }
                    }, label: {
                        Text("출발 역")
                            .font(selectedArrDep == 1 ? .title : .title3)
                            .fontWeight(.bold)
                            .foregroundStyle(selectedArrDep == 1 ? .primary : .secondary)
                        
                    })
                    .disabled(selectedArrDep == 1)
                    .padding(.leading, selectedArrDep == 2 || selectedArrDep == 0 ? 60 : 0)
                    .buttonStyle(GoodButton())
                    Spacer()
                    
                }
                
                //                .matchedGeometryEffect(id: "geo", in: namespace, isSource: selectedArrDep == 1)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            selectedArrDep = 2
                        }
                    }, label: {
                        Text("도착 역")
                            .font(selectedArrDep == 2 ? .title : .title3)
                            .fontWeight(.bold)
                            .foregroundStyle(selectedArrDep == 2 ? .primary : .secondary)
                    })
                    .padding(.trailing, selectedArrDep == 1 || selectedArrDep == 0 ? 60 : 0)
                    .buttonStyle(GoodButton())
                    .disabled(selectedArrDep == 2)
                    if selectedArrDep == 2 {
                        Spacer()
                    }
                }
                //                .matchedGeometryEffect(id: "geo", in: namespace, isSource: selectedArrDep == 2)
            }
            .padding(.bottom, -5)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(korailStations.allCases, id: \.self) { station in
                        Button(action: {
                            withAnimation {
                                if selectedArrDep == 1 {
                                    dep = station
                                } else {
                                    arr = station
                                }
                            }
                        }, label: {
                            Text(station.rawValue)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle((selectedArrDep == 2 && dep == station) ? .secondary : (selectedArrDep == 1 && arr == station ? .secondary : .primary))
                                .background{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.goodGray))
                                        .shadow(color: (selectedArrDep == 1 && dep == station) || (selectedArrDep == 2 && arr == station) ? .blue.opacity(1.0) : .clear, radius: 3)
                                    
                                }
                        })
                        .buttonStyle(GoodButton())
                        .disabled((selectedArrDep == 2 && dep == station) || (selectedArrDep == 1 && arr == station))
                        .scaleEffect(((selectedArrDep == 2 && dep == station) || (selectedArrDep == 1 && arr == station)) ? 0.9 : 1.0)
                        
                    }
                }
                .padding([.bottom, .leading, .trailing])
                .padding(.top, 5)
            }
            
            .ignoresSafeArea()
            Button(action: {
                withAnimation {
                    selectedArrDep = 0
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
