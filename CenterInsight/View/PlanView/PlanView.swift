//
//  PlanView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct PlanView: View {
    
    @State private var openZdorovie: Bool = false
    
    @State private var openDenegVsego: Bool = false
    
    @State private var openOstatok: Bool = false
    
    @State private var categories: [CategoryBudget] = [
        .init(title: "Еда",       systemImage: "basket.fill",  spent: 5600, limit: nil),
        .init(title: "Шоппинг",   systemImage: "tag.fill",    spent: 5700, limit: nil),
        .init(title: "Транспорт", systemImage: "bus.fill",    spent: 8500, limit: nil),
        .init(title: "Прочее",    systemImage: "questionmark",spent: 3000, limit: nil)
    ]
    
    @State private var activeCategoryIndex: Int? = nil
    
    
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
                    Text("Планы")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                    VStack {
                        VStack(spacing: 16) {
                            
                            
                            //Блок
                            VStack {
                                VStack {
                                    HStack {
                                        VStack {
                                            Text("Лимиты на текущий месяц")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            
                                        }
                                        Image(systemName: "dial.high.fill")
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                                                    startPoint: .trailing,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .font(.system(size: 30))
                                    }
                                    .padding(.horizontal)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 24) {
                                            
                                            ForEach(categories.indices, id: \.self) { index in
                                                let cat = categories[index]
                                                CategoryLimitView(
                                                    title: cat.title,
                                                    systemImage: cat.systemImage,
                                                    spent: cat.spent,
                                                    limit: cat.limit
                                                ) {
                                                    activeCategoryIndex = index
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.vertical)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .cornerRadius(24)
                            
                            VStack {
                                Button(action: {
                                    openZdorovie = true
                                }) {
                                    HStack {
                                        VStack {
                                            Text("Обязательные платежи")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            
                                        }
                                        Image(systemName: "rublesign.gauge.chart.leftthird.topthird.rightthird")
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                                                    startPoint: .trailing,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .font(.system(size: 30))
                                    }
                                    .padding()
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .cornerRadius(24)
                            
                            VStack {
                                Button(action: {
                                    openZdorovie = true
                                }) {
                                    HStack {
                                        VStack {
                                            Text("Запланировать покупку")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(Font.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                            
                                        }
                                        Image(systemName: "cart.fill")
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                                                    startPoint: .trailing,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .font(.system(size: 30))
                                    }
                                    .padding()
                                }
                                
                            }
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
            CategoryLimit()
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
        .sheet(isPresented: Binding(
            get: { activeCategoryIndex != nil },
            set: { if !$0 { activeCategoryIndex = nil } }
        )) {
            if let index = activeCategoryIndex {
                LimitSheet(category: $categories[index])
            }
        }
    }
}


#Preview {
    PlanView()
}

struct LimitSheet: View {
    
    @Binding var category: CategoryBudget
    @State private var tempLimit: Double = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: category.systemImage)
                        .font(.system(size: 22))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Лимит для этой категории")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Уже потрачено")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                Text(category.spent.rubFormatted())
                    .font(.system(size: 20, weight: .bold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Лимит")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                HStack {
                    TextField("0", value: $tempLimit, format: .number)
                        .keyboardType(.numberPad)
                        .font(.system(size: 24, weight: .bold))
                    Text("₽")
                        .font(.system(size: 24, weight: .bold))
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                let maxValue = max(category.spent * 2, 1)
                
                Slider(
                    value: $tempLimit,
                    in: 0...maxValue,
                    step: 1
                )
                .onChange(of: tempLimit) { newValue in
                    tempLimit = round(newValue)
                }
                .tint(
                    LinearGradient(
                        gradient: Gradient(colors: [.gradient2, .gradient1]),
                        startPoint: .trailing,
                        endPoint: .bottom
                    )
                )
            }
            
            Spacer()
            
            Button {
                // если 0 или меньше — считаем, что лимита нет
                category.limit = tempLimit > 0 ? tempLimit : nil
                dismiss()
            } label: {
                Text("Сохранить лимит")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.gradient2, .gradient1]),
                            startPoint: .trailing,
                            endPoint: .bottom
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .onAppear {
            tempLimit = category.limit ?? 0
        }
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .presentationBackground(.white)   // <- НЕ liquid glass, обычный белый фон
    }
}
