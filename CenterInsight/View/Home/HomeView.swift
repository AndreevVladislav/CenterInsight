//
//  HomeView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var tabRouter: TabRouter
    
    @State private var animTick = 0  // увеличиваем — кольцо перезапускается
    
    @State private var balance: Double = 9000.56
    
    @State private var healthValue: Double = 100
    
    var body: some View {
        let level = FinancialHealthLevel.level(for: healthValue)
        
        ZStack {
            Consts.Colors.background.ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    VStack {
                        Text("Центр-инсайт")
                            .foregroundStyle(.white)
                            .font(.system(size: 28, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            VStack {
                                Text("Текущий баланс")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top)
                                    .foregroundStyle(.white.opacity(0.8))
                                Text(balance.rubFormatted())
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.bottom)
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.black.opacity(0.1)
                            }
                            .cornerRadius(24)
                            
                            VStack {
                                Text("Финансовое здоровье")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top)
                                    .foregroundStyle(.white.opacity(0.8))
                                HStack {
                                    ZStack {
                                        GradientRingView(value: healthValue, lineWidth: 8, duration: 1.2, trigger: animTick)
                                            .frame(width: 70, height: 70)
                                        Text("\(Int(healthValue))%")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                    
                                    HStack {
                                        Text(level.text)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .padding()
                                    }
                                    .background {
                                        Color.gray.opacity(0.2)
                                    }
                                    .cornerRadius(16)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.black.opacity(0.1)
                            }
                            .cornerRadius(24)
                            .onTapGesture {
                                tabRouter.selected = 3
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.gradient2, .gradient1]),
                        startPoint: .trailing,
                        endPoint: .bottom
                    )
                )
                
                Spacer()
            }
            VStack {
                VStack {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                VStack {
                                    Text("Последние операции")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .padding(.top)
                                        .foregroundStyle(.black.opacity(0.6))
                                    TransactionItem()
                                    Divider()
                                        .padding(.horizontal)
                                    TransactionItem()
                                    Divider()
                                        .padding(.horizontal)
                                    TransactionItem()
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.top)
                                .onTapGesture {
                                    tabRouter.selected = 1
                                }
                                
                                VStack {
                                    Text("Планы")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .padding(.top)
                                        .foregroundStyle(.black.opacity(0.6))
                                    Text("тут будут планы")
                                        .padding(.bottom)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.top)
                                .onTapGesture {
                                    tabRouter.selected = 2
                                }
                                
                            }
                        }
                        .background(Consts.Colors.background)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(Consts.Colors.background)
            .cornerRadius(24)
            .ignoresSafeArea()
            .padding(.top, 300)
            
            
        }
        .onAppear { animTick &+= 1 } // первый запуск при первом появлении
        .onChange(of: tabRouter.selected) { newValue in
            if newValue == 3 { animTick &+= 1 } // вкладка «Аналитика»
        }
    }
}


#Preview {
    RootView()
        .environmentObject(TabRouter())
}


