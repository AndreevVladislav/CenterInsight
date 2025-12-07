//
//  OperaciiView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct OperaciiView: View {
    
    /// Положение прокрутки
    @State private var scrollOffset = CGFloat.zero
    
    @State private var selection: Period = .month
    
    @State private var openRashodi: Bool = false
    
    @State private var openPostupleniya: Bool = false
    
    @State private var summary: AnalyticsSummary?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var last100: [TransactionResponse] = []
    
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
            ObservedScrollView(scrollOffset: $scrollOffset) { proxy in
                VStack(spacing: 0) {
                    VStack {
                        Text("Операции")
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
                                .frame(width: 200)
                                .onChange(of: selection) { newValue in
                                    Task {
                                        await loadSummary(for: newValue)
                                    }
                                }
                                .task {
                                    // первый загруз при открытии экрана
                                    await loadSummary(for: selection)
                                }
                            .frame(width: 200)
                            
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            VStack {
                                Text(summary?.expenses.rubFormatted() ?? "0")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 22, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Расходы")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            .onTapGesture {
//                                openRashodi = true
                            }
                            
                            VStack {
                                Text(summary?.income.rubFormatted() ?? "0")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 22, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Поступления")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            .onTapGesture {
//                                openPostupleniya = true
                            }
                        }
                        .padding(.horizontal)
                        .opacity((self.scrollOffset > 115) ? 0 : 1)
                    }
                    .padding(.bottom, 35)
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("История")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .foregroundStyle(.black.opacity(0.6))
                        ForEach(last100) { item in
                            LazyVStack {
                                TransactionItem(id: item.id, date: item.trx_date, type: item.type, amount: item.amount, category: item.category)
                            }
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
                
            }
            
            .ignoresSafeArea()
            .sheet(isPresented: $openRashodi) {
                RashodiView()
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $openPostupleniya) {
                PostupleniyaView()
                    .presentationDragIndicator(.visible)
            }
            
            
            if(self.scrollOffset > 115) {
                VStack {
                    VStack {
                        HStack {
                            VStack {
                                Text(summary?.expenses.rubFormatted() ?? "0")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 22, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Расходы")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            .onTapGesture {
//                                openRashodi = true
                            }
                            
                            
                            VStack {
                                Text(summary?.income.rubFormatted() ?? "0")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 22, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Поступления")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            .onTapGesture {
//                                openPostupleniya = true
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.gradient2, .gradient2]),
                            startPoint: .trailing,
                            endPoint: .bottom
                        )
                        
                    )
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let last100 = try await fetchLastThreeTransactions()
                    print(last100)
                    self.last100 = last100
                } catch {
                    print("Ошибка:", error)
                }
            }
        }
    }
    
    func loadSummary(for period: Period) async {
            isLoading = true
            errorMessage = nil
            
            do {
                let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/analytics/summary?period=\(period.apiValue)")!
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let http = response as? HTTPURLResponse,
                      http.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                let decoded = try JSONDecoder().decode(AnalyticsSummary.self, from: data)
                
                await MainActor.run {
                    self.summary = decoded
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.summary = nil
                    self.isLoading = false
                    self.errorMessage = "Ошибка загрузки данных"
                    print("Analytics error:", error)
                }
            }
        }
    
    private func fetchLastThreeTransactions() async throws -> [TransactionResponse] {
        let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/transactions?skip=0&limit=100")!
        
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
}

#Preview {
    OperaciiView()
}

struct CustomSegmentedControl: View {
    @Binding var selection: Period
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Period.allCases) { period in
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        selection = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selection == period ? .black : .white)
                        .background(
                            ZStack {
                                if selection == period {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.85))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.12))
        )
    }
}

struct AnalyticsSummary: Decodable {
    let income: Double
    let expenses: Double
    // + добавь остальные поля, если есть
}

struct CorrectCategoryRequest: Codable {
    let category: String
}

func correctTransactionCategory(id: Int, newCategory: String) async throws {
    guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/transactions/\(id)/correct") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let body = CorrectCategoryRequest(category: newCategory)
    request.httpBody = try JSONEncoder().encode(body)

    let (_, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    print("PATCH /correct response status:", http.statusCode)

    if http.statusCode != 200 {
        throw URLError(.badServerResponse)
    }
}
