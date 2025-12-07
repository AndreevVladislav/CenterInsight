//
//  RashodiView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI
import Charts

struct RashodiView: View {
    
    @State private var selection: Period = .month
    
    @State private var graphType: GraphType = .donut
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    
    var appDownloads: [AppDownload] = [
        .init(category: .food,      downloads: 12),
        .init(category: .rent,      downloads: 1),
        .init(category: .shopping,  downloads: 5),
        .init(category: .transport, downloads: 8),
        .init(category: .misc,      downloads: 3)
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
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
                VStack(spacing: 0) {
                    VStack {
                        VStack(spacing: 0) {
                            VStack {
                                Text("Расходы")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 28, weight: .bold))
                                    .padding(.top, 40)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    
                                    Text("Декабрь")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 18, weight: .semibold))
                                    Spacer()
                                    CustomSegmentedControl(selection: $selection)
                                        .onChange(of: selection) { newValue in
                                            print("Выбран период в родителе: \(newValue.rawValue)")
                                        }
                                    .frame(width: 200)
                                    
                                }
                                .padding(.horizontal)
                                
                                ZStack {
                                    if let highestDownloads = appDownloads.max(by: {
                                        $1.downloads > $0.downloads
                                    }) {
                                        if graphType == .bar {
                                            ChartPopOverView(highestDownloads.downloads,
                                                             highestDownloads.month,
                                                             true)
                                            .opacity(barSelection == nil ? 1 : 0)
                                        } else {
                                            if let barSelection,
                                               let selectedDownloads = appDownloads.findDownloads(barSelection) {
                                                ChartPopOverView(selectedDownloads, barSelection, true, true)
                                            } else {
                                                ChartPopOverView(highestDownloads.downloads,
                                                                 highestDownloads.month,
                                                                 true)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                                
                                Chart {
                                    ForEach(appDownloads.sorted(by: { graphType == .bar ? false : $0.downloads > $1.downloads })) { dowload in
                                        if graphType == .bar {
                                            BarMark(
                                                x: .value("Month", dowload.month),
                                                y: .value("Downkiads", dowload.downloads)
                                            )
                                            .cornerRadius(4)
                                            .foregroundStyle(by: .value("Month", dowload.month))
                                        } else {
                                            SectorMark(
                                                angle: .value("Downloads",dowload.downloads),
                                                innerRadius: .ratio(0.6),
                                                angularInset: graphType == .donut ? 8 : 1
                                            )
                                            .cornerRadius(4)
                                            .foregroundStyle(by: .value("Month", dowload.month))
                                            .opacity(barSelection == nil ? 1 : (barSelection == dowload.month ? 1 : 0.4))
                                        }
                                    }
                                    
                                    if let barSelection {
                                        RuleMark(x: .value("Month", barSelection))
                                            .foregroundStyle(.gray.opacity(0.35))
                                            .zIndex(-10)
                                            .offset(yStart: -10)
                                            .annotation(
                                                position: .top,
                                                spacing: 0,
                                                overflowResolution: .init(x: .fit, y: .disabled)
                                            ){
                                                if let downloads = appDownloads.findDownloads(barSelection)
                                                {
                                                    ChartPopOverView(downloads, barSelection)
                                                }
                                                
                                            }
                                    }
                                }
                                .chartXSelection(value: $barSelection)
                                .chartAngleSelection(value: $pieSelection)
                                .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
                                .frame(height: 200)
                                .padding(10)
                                .animation(.snappy, value: graphType)
                                
                            }
                            .onChange(of: pieSelection, initial: false) { oldValue, newValue in
                                // игнорируем сброс жеста (когда newValue == nil, палец убрали)
                                guard let newValue,
                                      let tappedMonth = findDownload(newValue) else { return }

                                // если уже выбран этот же сектор — снимаем выделение
                                if barSelection == tappedMonth {
                                    barSelection = nil
                                } else {
                                    // иначе выбираем новый сектор
                                    barSelection = tappedMonth
                                    print(barSelection)
                                }
                            }
                            .padding(.bottom, 35)
                            .frame(maxWidth: .infinity)
                            VStack {
                                ForEach(0..<40) { index in
//                                    TransactionItem()
                                }
                            }
                            .padding()
                            .background(
                                ZStack {
                                    Color.white
                                    LinearGradient(
                                        gradient: Gradient(colors: [.gradient2, .gradient1]),
                                        startPoint: .trailing,
                                        endPoint: .bottom
                                    ).opacity(0.1)
                                }
                            )
                            .cornerRadius(16)
                            .padding(.top, -20)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func ChartPopOverView(_ downloads: Double, _ month: String, _ isTitleView: Bool = false, _ isSelection: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(isTitleView && !isSelection ? "Все транзакции" : "Детали") ")
                .font(.title3)
                .foregroundStyle(.gray)

            HStack(spacing: 4) {
                Text(String(format: "%.0f", downloads))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)

                Text(month)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(Color.white.opacity(isTitleView ? 0 : 1), in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
    
    func findDownload(_ rangeValue: Double) -> String? {
        // Converting Download Model into Array of Tuples
        var initalValue: Double = 0.0
        let convertedArray = appDownloads
            .sorted(by: { $0.downloads > $1.downloads })
            .compactMap { download -> (String, Range<Double>) in
                let rangeEnd = initalValue + download.downloads
                let tuple = (download.month, initalValue..<rangeEnd)
                // Updating Initial Value for next Iteration
                initalValue = rangeEnd
                return tuple
            }

        // Now Finding the Value lies in the Range
        if let download = convertedArray.first(where: {
            $0.1.contains(rangeValue)
        }) {
            return download.0      // возвращаем месяц
        }

        return nil
    }
}

#Preview {
    RashodiView()
}

