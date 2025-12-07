//
//  VsegoView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI
import Charts

struct AppDownload2: Identifiable {
    var id = UUID()
    var month: String      // подпись колонки (название месяца)
    var downloads: Double  // доход за месяц
}

extension [AppDownload2] {
    func findDownloads(_ on: String) -> Double? {
        first(where: { $0.month == on })?.downloads
    }
}

extension AppDownload2 {
    static func lastSixMonths(incomes: [Double]) -> [AppDownload2] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("LLL")  // вместо dateFormat = "MMM"

        let now = Date()
        let count = min(6, incomes.count)

        return (0..<count).map { index in
            let offset = count - 1 - index
            let date = calendar.date(byAdding: .month, value: -offset, to: now) ?? now
            let monthName = formatter.string(from: date)   // будет ближе к "июн" / "июнь", а не "июня"
            return AppDownload2(month: monthName, downloads: incomes[index])
        }
    }
}


struct VsegoView: View {

    // Задаёшь доходы за последние месяцы (от старого к новому)
    @State private var appDownloads: [AppDownload2] =
        AppDownload2.lastSixMonths(incomes: [
            0, 0, 0, 0, 0, 0   // пример
        ])

    @State private var barSelection: String?
    
    @State private var avg_monthly_expense: Double = 0
    
    @State private var incomeThisMonth: Double = 0
    

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

                    // Диаграмма
                    VStack {
                        VStack {
                            ZStack {
                                // Поповер по умолчанию — последний месяц
                                if let last = appDownloads.last {
                                    ChartPopOverView(last.downloads, last.month, true, false)
                                        .opacity(barSelection == nil ? 1 : 0)
                                }

                                // Поповер для ВЫБРАННОГО месяца
                                if let barSelection,
                                   let selectedDownloads = appDownloads.findDownloads(barSelection) {
                                    ChartPopOverView(selectedDownloads, barSelection, true, true)
                                        .opacity(barSelection == nil ? 0 : 1)
                                }
                            }
                            Chart {
                                ForEach(appDownloads) { download in
                                    BarMark(
                                        x: .value("Month", download.month),
                                        y: .value("Income", download.downloads)
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.yellow, .yellow.darker()]),
                                            startPoint: .trailing,
                                            endPoint: .bottom
                                        )
                                    )
                                }

                                // Полосочка для выбранной колонки
                                if let barSelection {
                                    RuleMark(x: .value("Month", barSelection))
                                        .foregroundStyle(.gray.opacity(0.35))
                                        .zIndex(-10)
                                        .offset(yStart: -10)
                                }
                            }
                            .chartXSelection(value: $barSelection)
                            .chartLegend(.hidden)
                            .frame(height: 200)
                            .padding(10)
                        }
                        .padding()
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Любые другие карточки ниже
                    let status = monthStatus(income: incomeThisMonth, avgMonthlyExpense: avg_monthly_expense)
                    let level = status.level

                    VStack {
                        VStack {
                            Text(status.text)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 22, weight: .bold))
                            
                            Text("При ваших средних тратах \(avg_monthly_expense.rubFormatted())")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 16, weight: .regular))
                            
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
                        .padding()
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
        .onAppear {
            Task {
                do {
                    let analytics = try await fetchMonthlyAnalytics()
                    print("labels:", analytics.labels)
                    print("incomes:", analytics.incomes)
                    self.appDownloads = AppDownload2.lastSixMonths(incomes: Array(analytics.incomes.dropFirst()))
                    self.incomeThisMonth = analytics.incomes.last ?? 0
                    print("expenses:", analytics.expenses)
                    print("avg_monthly_expense:", analytics.avg_monthly_expense)
                    self.avg_monthly_expense = analytics.avg_monthly_expense
                } catch {
                    print("Ошибка запроса monthly:", error)
                }
            }
        }
    }

    @ViewBuilder
    func ChartPopOverView(
        _ downloads: Double,
        _ month: String,
        _ isTitleView: Bool = false,
        _ isSelection: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Доход за месяц")
                .font(.title3)
                .foregroundStyle(.gray)

            HStack(spacing: 4) {
                Text(downloads.rubFormatted())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.black)

            }
        }
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.black.opacity(0.05), in: .rect(cornerRadius: 14))
        
    }
    
    private func fetchMonthlyAnalytics() async throws -> MonthlyAnalyticsResponse {
        let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/analytics/monthly")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(MonthlyAnalyticsResponse.self, from: data)
        return result
    }
    
    private func monthStatus(income: Double, avgMonthlyExpense: Double) -> (text: String, level: FinancialTegLevel) {
        guard avgMonthlyExpense > 0 else {
            // если нет данных по тратам — считаем нейтрально
            return ("Недостаточно данных", .medium)
        }
        
        let ratio = income / avgMonthlyExpense
        
        if ratio >= 1.1 {
            return ("Хватит больше чем на месяц", .good)
        } else if ratio >= 0.9 {
            return ("Хватит ровно на месяц", .medium)
        } else {
            return ("Хватит меньше чем на месяц", .bad)
        }
    }
}

#Preview {
    VsegoView()
}
