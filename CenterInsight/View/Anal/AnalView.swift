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
    
    @EnvironmentObject var tabRouter: TabRouter
    @State private var animTick = 0  // увеличиваем — кольцо перезапускается
    
    @State private var openZdorovie: Bool = false
    
    @State private var openDenegVsego: Bool = false
    
    @State private var openOstatok: Bool = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [.gradient2, .gradient1]),
                startPoint: .trailing,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .opacity(0.1)
            ScrollView {
                VStack(spacing: 16) {
                    //Блок финансовое здоровье
                    VStack {
                        let level = FinancialHealthLevel.level(for: healthValue)
                        Button(action: {
                            openZdorovie = true
                        }) {
                            HStack {
                                VStack {
                                    Text("Процент вашего финансового здоровья")
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
                                    .foregroundStyle(.red)
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
                        let level = FinancialTegLevel.medium
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
                                    Text("денег всего")
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
                                    .foregroundStyle(.yellow.darker())
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
                        let level = FinancialTegLevel.bad
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
                                    .foregroundStyle(.blue.darker())
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
                .padding(.horizontal)
            }
        }
        .navigationTitle("Аналитика")
        .onAppear { animTick &+= 1 } // первый запуск при первом появлении
        .onChange(of: tabRouter.selected) { newValue in
            if newValue == 3 { animTick &+= 1 } // вкладка «Аналитика»
        }
        .sheet(isPresented: $openZdorovie) {
            ZdorovieView()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openDenegVsego) {
            EmptyView()
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openOstatok) {
            EmptyView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    AnalView()
        .environmentObject(TabRouter())
}
