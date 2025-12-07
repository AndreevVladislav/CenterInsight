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
    
    @State private var balance: Double = 0
    
    @State private var healthValue: Double = 0
    
    @State private var last3: [TransactionResponse] = []
    
    @State private var openAnomaly: Bool = false
    
    @State private var plannedPurchase: PlannedPurchase? = nil
    
    @State private var unreadCount: Int = 0
    
    var body: some View {
        let level = FinancialHealthLevel.level(for: healthValue)
        
        ZStack {
            Consts.Colors.background.ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Text("Центр-инсайт")
                                .foregroundStyle(.white)
                                .font(.system(size: 28, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ZStack {
                                Button(action: {
                                    openAnomaly = true
                                }) {
                                    VStack {
                                        Image(systemName: "bell")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 20, weight: .semibold))
                                            .padding(8)
                                    }
                                    .background {
                                        Color.black.opacity(0.1)
                                    }
                                    .cornerRadius(50)
                                    
                                }
                                if unreadCount != 0 {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .foregroundStyle(.yellowTeg)
                                                    .frame(width: 18)
                                                Text("\(unreadCount)")
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 12, weight: .bold))
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .frame(maxWidth: 50,maxHeight: 50)
                        }
                        
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
                    .padding(.horizontal)
                    .padding(.bottom)
                    
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
                                    ForEach(last3) { item in
                                        TransactionItem(id: item.id, date: item.trx_date, type: item.type, amount: item.amount, category: item.category)
                                        Divider()
                                            .padding(.horizontal)

                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.top)
                                .onTapGesture {
                                    tabRouter.selected = 1
                                }
                                
                                if let purchase = plannedPurchase {
                                    
                                    VStack {
                                        Text("Планы")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading)
                                            .padding(.top)
                                            .foregroundStyle(.black.opacity(0.6))
                                        PlannedPurchaseCard(purchase: purchase)
                                            .padding(.horizontal)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .padding(.top)
                                    .padding(.bottom, 80)
                                    .onTapGesture {
                                        tabRouter.selected = 2
                                    }
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
        .sheet(isPresented: $openAnomaly) {
            AnomalyView()
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            animTick &+= 1
            Task {
                do {
                    let balance = try await fetchBalance()
                    print("Баланс:", balance.balance)
                    self.balance = balance.balance
                } catch {
                    print("Ошибка запроса:", error)
                }
            }
            
            Task {
                do {
                    let last3 = try await fetchLastThreeTransactions()
                    print(last3)
                    self.last3 = last3
                } catch {
                    print("Ошибка:", error)
                }
            }
            
            Task {
                do {
                    let health = try await fetchHealthScore()
                    print("Здоровье:", health.score)
                    healthValue = Double(health.score)
                    print("Статус:", health.status)
                } catch {
                    print("Ошибка получения финансового здоровья:", error)
                }
            }
            
            plannedPurchase = loadPlannedPurchase()
            
            Task {
                do {
                    let response = try await fetchAnomalies()
                    self.unreadCount = response.unread_count   // <-- используем в UI
                } catch {
                    print("Ошибка загрузки:", error)
                }
            }
            
        } // первый запуск при первом появлении
        .onChange(of: tabRouter.selected) { newValue in
            if newValue == 3 { animTick &+= 1 } // вкладка «Аналитика»
        }
        .onChange(of: healthValue) { newValue in
            animTick &+= 1  
        }
    }
    
    private func fetchLastThreeTransactions() async throws -> [TransactionResponse] {
        let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/transactions?skip=0&limit=3")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([TransactionResponse].self, from: data)
    }
    
    func fetchHealthScore() async throws -> FinancialHealthResponse {
        guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/analytics/health") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(FinancialHealthResponse.self, from: data)
        return decoded
    }
    
    private func fetchAnomalies(skip: Int = 0, limit: Int = 100) async throws -> AnomalyResponse {
        guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/anomalies?skip=\(skip)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(AnomalyResponse.self, from: data)
        
        // 🟦 Выводим количество непрочитанных уведомлений
        print("Непрочитанных уведомлений: \(result.unread_count)")
        
        return result
    }
}


#Preview {
    RootView()
        .environmentObject(TabRouter())
}


struct BalanceResponse: Decodable {
    let balance: Double
    let last_transaction_date: String?
    let system_date: String
}

func fetchBalance() async throws -> BalanceResponse {
    let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/balance")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(BalanceResponse.self, from: data)
}

struct TransactionResponse: Identifiable, Codable, Equatable {
    let amount: Double
    let type: String
    let trx_date: String
    let id: Int
    let category: String
    let is_anomaly: Bool
    let is_corrected: Bool
}


struct FinancialHealthResponse: Codable {
    let score: Int      // 0–100
    let status: String  // "Good", "Neutral", "Critical" и т.д.
}
