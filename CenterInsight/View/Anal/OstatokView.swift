//
//  OstatokView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 07.12.2025.
//

import Foundation
import SwiftUI
import Charts

struct AppDownload3: Identifiable, Equatable {
    var id = UUID()
    var month: String        // подпись месяца
    var income: Double       // доход за месяц
    var expense: Double      // траты за месяц

    var leftover: Double {   // остаток = доход - траты
        income - expense
    }

    var leftoverPercent: Double {   // доля остатка от дохода (0...1)
        guard income > 0 else { return 0 }
        return max(0, leftover / income)
    }
}

extension [AppDownload3] {
    func month(named name: String) -> AppDownload3? {
        first { $0.month == name }
    }
}

extension AppDownload3 {
    static func lastSixMonths(incomes: [Double], expenses: [Double]) -> [AppDownload3] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("LLL")

        let now = Date()
        let count = min(6, incomes.count, expenses.count)

        return (0..<count).map { index in
            let offset = count - 1 - index
            let date = calendar.date(byAdding: .month, value: -offset, to: now) ?? now
            let monthName = formatter.string(from: date)
            return AppDownload3(
                month: monthName,
                income: incomes[index],
                expense: expenses[index]
            )
        }
    }
}


struct OstatokView: View {

    // доходы и расходы за последние 6 месяцев (от старого к новому)
    private let appDownloads: [AppDownload3] =
        AppDownload3.lastSixMonths(
            incomes:  [150_000, 160_000, 155_000, 170_000, 165_000, 180_000],
            expenses: [130_000, 120_000, 140_000, 150_000, 148_000, 200_000]
        )

    @State private var barSelection: String?   // выбранный месяц (по оси X)

    // Текущий месяц для отображения (по умолчанию — последний)
    private var currentMonth: AppDownload3 {
        if let barSelection,
           let found = appDownloads.month(named: barSelection) {
            return found
        }
        return appDownloads.last!
    }
    
    @State private var level = FinancialTegLevel.bad
    
    @State private var percent: Int = 0

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

                    // ===== Верхняя карточка: остаток + доходы/траты =====
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Остаток от дохода")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.secondary)

                        Text("\(Int(currentMonth.leftover)) ₽")
                            .font(.system(size: 28, weight: .bold))

                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Траты")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color.red)

                                Text("\(Int(currentMonth.expense)) ₽")
                                    .font(.system(size: 16, weight: .semibold))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Доходы")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color.blue.darker())

                                Text("\(Int(currentMonth.income)) ₽")
                                    .font(.system(size: 16, weight: .semibold))
                            }

                            Spacer()
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // ===== Карточка с диаграммой =====
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Динамика по месяцам")
                                .font(.system(size: 16, weight: .semibold))

                            Chart {
                                ForEach(appDownloads) { month in
                                    // Траты
                                    BarMark(
                                        x: .value("Month", month.month),
                                        y: .value("Amount", month.expense)
                                    )
                                    .position(by: .value("Type", "Траты"))
                                    .foregroundStyle(Color.red)
                                    .cornerRadius(4)

                                    // Доходы
                                    BarMark(
                                        x: .value("Month", month.month),
                                        y: .value("Amount", month.income)
                                    )
                                    .position(by: .value("Type", "Доходы"))
                                    .foregroundStyle(Color.blue.darker())
                                    .cornerRadius(4)
                                }

                                // Полоска для выбранного месяца
                                if let barSelection {
                                    RuleMark(x: .value("Month", barSelection))
                                        .foregroundStyle(.gray.opacity(0.35))
                                        .zIndex(-10)
                                }
                            }
                            .chartXSelection(value: $barSelection)      // выбор месяца
                            .chartLegend(.hidden)                       // без точек/легенды
                            .frame(height: 200)
                        }
                        .padding()
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // ===== Нижняя карточка: процент остатка =====
                    VStack(alignment: .leading, spacing: 8) {
                        

                        Text("Осталось \(percent)% дохода")
                            .font(.system(size: 20, weight: .bold))

                        Text("При ваших текущих тратах и доходах за выбранный месяц.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                        
                        
                        
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
                        .onAppear {
                            
                            
                            
                        }
                        .onChange(of: currentMonth) { oldValue, newValue in
                            percent = Int(newValue.leftoverPercent * 100)
                            if percent > 15 {
                                level = .good
                            } else if percent <= 15 && percent > 5 {
                                level = .medium
                            } else {
                                level = .bad
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    OstatokView()
}
