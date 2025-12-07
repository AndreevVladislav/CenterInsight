//
//  AnalView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct AnalView: View {
    
    @State private var healthValue: Double = 100
    
    @State private var balance: Double = 9000.56
    
    @State private var openZdorovie: Bool = false
    
    @State private var openDenegVsego: Bool = false
    
    @State private var openOstatok: Bool = false

    var body: some View {
        ZStack {
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                    startPoint: .trailing,
                    endPoint: .bottom
                )
                LinearGradient(
                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                    startPoint: .trailing,
                    endPoint: .bottom
                ).opacity(0.1)
                .frame(maxHeight: 200)
                
            }
            .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Аналитика")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                    VStack {
                        VStack(spacing: 16) {
                            
                            
                            //Блок финансовое здоровье
                            VStack {
                                let level = FinancialHealthLevel.level(for: healthValue)
                                Button(action: {
                                    openZdorovie = true
                                }) {
                                    HStack {
                                        VStack {
                                            Text("Процент вашего финансовоe здоровьe")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Text(level.title)
                                                    .foregroundStyle(level.textColor)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(level.backgroundColor)
                                                    .cornerRadius(12)
                                                Spacer()
                                            }
                                        }
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(level.textColor)
                                            .font(.system(size: 40))
                                    }
                                    .padding()
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .cornerRadius(24)
                            
                            //Блок денег всего
                            VStack {
                                let level = FinancialTegLevel.bad
                                Button(action: {
                                    openDenegVsego = true
                                }) {
                                    HStack {
                                        VStack {
                                            
                                            Text(balance.rubFormatted())
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            Text("доход за месяц")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Text(level.title)
                                                    .foregroundStyle(level.textColor)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(level.backgroundColor)
                                                    .cornerRadius(12)
                                                Spacer()
                                            }
                                        }
                                        Image(systemName: "chart.xyaxis.line")
                                            .foregroundStyle(level.textColor)
                                            .font(.system(size: 40))
                                    }
                                    .padding()
                                }                    }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .cornerRadius(24)
                            
                            //Блок остаток от дохода
                            VStack {
                                let level = FinancialTegLevel.good
                                Button(action: {
                                    openOstatok = true
                                }) {
                                    HStack {
                                        VStack {
                                            
                                            Text(balance.rubFormatted())
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            Text("остаток от дохода")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Text(level.title)
                                                    .foregroundStyle(level.textColor)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(level.backgroundColor)
                                                    .cornerRadius(12)
                                                Spacer()
                                            }
                                        }
                                        Image(systemName: "chart.bar.xaxis")
                                            .foregroundStyle(level.textColor)
                                            .font(.system(size: 40))
                                    }
                                    .padding()
                                }                    }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .cornerRadius(24)
                            
                            
                        }
                        .padding()
                        .padding(.bottom, 400)
                    }
                    .background(
                        ZStack {
                            Color.white
                            LinearGradient(
                                gradient: Gradient(colors: [.gradient2, .gradient1]),
                                startPoint: .trailing,
                                endPoint: .bottom
                            )
                            .opacity(0.1)
                        }
                    )
                    .cornerRadius(16)
                }
            }
        }
        .sheet(isPresented: $openZdorovie) {
            ZdorovieView()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openDenegVsego) {
            VsegoView()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openOstatok) {
            OstatokView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TabRouter())
}
