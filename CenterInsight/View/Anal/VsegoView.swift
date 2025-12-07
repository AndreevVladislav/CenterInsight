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
    private let appDownloads: [AppDownload2] =
        AppDownload2.lastSixMonths(incomes: [
            20000, 23000, 18000, 25000, 27000, 30000   // пример
        ])

    @State private var barSelection: String?

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
                    VStack {
                        VStack {
                            Text("Хватит меньше чем на месяц")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 24, weight: .bold))

                            Text("При ваших средних тратах 200 000 ₽")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 18, weight: .regular))
                            
                            let level = FinancialTegLevel.bad
                            
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
}

#Preview {
    VsegoView()
}
