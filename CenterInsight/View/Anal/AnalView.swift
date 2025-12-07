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
    
    @State private var avg_monthly_expense: Double = 0
    
    @State private var incomeThisMonth: Double = 0
    
    @State private var expensesThisMonth: Double = 0

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
                                let status = monthStatus(income: incomeThisMonth, avgMonthlyExpense: avg_monthly_expense)
                                let level = status.level
                                Button(action: {
                                    openDenegVsego = true
                                }) {
                                    HStack {
                                        VStack {
                                            
                                            Text(incomeThisMonth.rubFormatted())
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
                                let level = calculateLevel(income: incomeThisMonth, expenses: expensesThisMonth)
                                Button(action: {
                                    openOstatok = true
                                }) {
                                    HStack {
                                        VStack {
                                            
                                            Text((incomeThisMonth-expensesThisMonth).rubFormatted())
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
        .onAppear {
            Task {
                do {
                    let analytics = try await fetchMonthlyAnalytics()
                    print("labels:", analytics.labels)
                    print("incomes:", analytics.incomes)
                    self.incomeThisMonth = analytics.incomes.last ?? 0
                    self.expensesThisMonth = analytics.expenses.last ?? 0
                    print("expenses:", analytics.expenses)
                    print("avg_monthly_expense:", analytics.avg_monthly_expense)
                    self.avg_monthly_expense = analytics.avg_monthly_expense
                } catch {
                    print("Ошибка запроса monthly:", error)
                }
            }
        }
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
    
    func calculateLevel(income: Double, expenses: Double) -> FinancialTegLevel {
        let leftover = income - expenses
        let percent = leftover / max(income, 1) * 100
        
        if percent > 15 {
            return .good
        } else if percent > 5 {
            return .medium
        } else {
            return .bad
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TabRouter())
}

struct MonthlyAnalyticsResponse: Decodable {
    let labels: [String]          // "2023-06", "2023-07", ...
    let incomes: [Double]         // доходы по месяцам
    let expenses: [Double]        // расходы по месяцам
    let avg_monthly_expense: Double
}
