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
    
    /// Только нужные категории (без Rent и Salary)
    @State private var categories: [CategoryBudget] = [
        .init(title: "Еда",       apiTitle: "Food",      systemImage: "basket.fill",   spent: 0, limit: nil),
        .init(title: "Шоппинг",   apiTitle: "Shopping",  systemImage: "tag.fill",      spent: 0, limit: nil),
        .init(title: "Транспорт", apiTitle: "Transport", systemImage: "bus.fill",      spent: 0, limit: nil),
        .init(title: "Прочее",    apiTitle: "Misc",      systemImage: "questionmark",  spent: 0, limit: nil)
    ]
    
    @State private var activeCategoryIndex: Int? = nil
    
    @State private var showPlannedPurchaseSheet = false
    @State private var plannedPurchase: PlannedPurchase? = nil
    
    
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
                )
                .opacity(0.1)
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
                            
                            // Блок лимитов
                            VStack {
                                VStack {
                                    HStack {
                                        VStack {
                                            Text("Лимиты на текущий месяц")
                                                .foregroundStyle(Consts.Colors.greyBack)
                                                .font(.system(size: 18, weight: .heavy))
                                                .frame(maxWidth: .infinity, alignment: .leading)
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
                            .background(Color.white)
                            .cornerRadius(24)
                            
                            // Остальные блоки оставляем как у тебя
//                            VStack {
//                                Button(action: {
//                                    openZdorovie = true
//                                }) {
//                                    HStack {
//                                        VStack {
//                                            Text("Обязательные платежи")
//                                                .foregroundStyle(Consts.Colors.greyBack)
//                                                .font(.system(size: 18, weight: .heavy))
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                        }
//                                        Image(systemName: "rublesign.gauge.chart.leftthird.topthird.rightthird")
//                                            .foregroundStyle(
//                                                LinearGradient(
//                                                    gradient: Gradient(colors: [.gradient2, .gradient1]),
//                                                    startPoint: .trailing,
//                                                    endPoint: .bottom
//                                                )
//                                            )
//                                            .font(.system(size: 30))
//                                    }
//                                    .padding()
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(24)
                            
                            VStack {
                                Button(action: {
                                    showPlannedPurchaseSheet = true
                                }) {
                                    VStack {
                                        HStack {
                                            VStack {
                                                Text("Плановая покупка")
                                                    .foregroundStyle(Consts.Colors.greyBack)
                                                    .font(.system(size: 18, weight: .heavy))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
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
                                                .onTapGesture {
                                                    clearPlannedPurchase()
                                                }
                                        }
                                        if let purchase = plannedPurchase {
                                            PlannedPurchaseCard(purchase: purchase)
                                                .padding(.horizontal)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
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
        // подгружаем бюджеты при первом появлении
        .task {
            await loadBudgets()
        }
        .sheet(isPresented: $showPlannedPurchaseSheet) {
            PlannedPurchaseSheet { purchase in
                self.plannedPurchase = purchase
                // позже сюда можно добавить вызов API /calculate-strategy
            }
        }
        .onAppear {
            plannedPurchase = loadPlannedPurchase()   // ⬅️ поднимаем из кеша
        }
    }
    
    // MARK: - Загрузка бюджетов
    
    private func loadBudgets() async {
        do {
            let budgets = try await fetchBudgets()
            
            await MainActor.run {
                // обновляем только те категории, что показаны в UI
                for i in categories.indices {
                    let apiTitle = categories[i].apiTitle
                    if let backend = budgets.first(where: { $0.category == apiTitle }) {
                        categories[i].spent = backend.spent_in_current_month
                        categories[i].limit = backend.amount_limit > 0 ? backend.amount_limit : nil
                    }
                }
            }
        } catch {
            print("Ошибка загрузки бюджетов:", error)
        }
    }
}
func fetchBudgets() async throws -> [BudgetResponse] {
    guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/budgets") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse,
          200..<300 ~= http.statusCode else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode([BudgetResponse].self, from: data)
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
                    in: 0...10000,
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
                
                Task {
                    do {
                        let result = try await setBudget(category: category.apiTitle, limit: tempLimit)
                        print("Лимит установлен:", result)
                        category.limit = tempLimit > 0 ? tempLimit : nil
                        dismiss()
                    } catch {
                        print("Ошибка установки лимита:", error)
                    }
                }
                
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
    
    private func setBudget(category: String, limit: Double) async throws -> BudgetResponse {
        guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/budgets") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = BudgetSetRequest(category: category, amount_limit: limit)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(BudgetResponse.self, from: data)
    }
}

struct BudgetSetRequest: Codable {
    let category: String
    let amount_limit: Double
}

struct BudgetResponse: Codable {
    let category: String
    let amount_limit: Double
    let spent_in_current_month: Double
    let percentage_used: Double
    let remaining: Double
}

struct PlannedPurchaseSheet: View {
    
    @State private var title: String = ""
    @State private var date: Date = .now
    @State private var amount: Double = 0
    
    let onSave: (PlannedPurchase) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
    
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Название покупки")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                TextField("Например, новый телефон", text: $title)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Дата покупки")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(Consts.Colors.gradient1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Стоимость")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                HStack {
                    TextField("0", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                        .font(.system(size: 24, weight: .bold))
                    Text("₽")
                        .font(.system(size: 24, weight: .bold))
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            
            Spacer()
            
            Button {
                let purchase = PlannedPurchase(title: title, date: date, amount: amount)
                savePlannedPurchase(purchase)   // ⬅️ сохраняем в кеш
                onSave(purchase)                // передаём наверх, если нужно
                dismiss()
            } label: {
                Text("Запланировать покупку")
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
            .disabled(title.isEmpty || amount <= 0)
            .opacity(title.isEmpty || amount <= 0 ? 0.5 : 1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .presentationBackground(.white)
    }
}

struct PlannedPurchase: Codable {
    let title: String
    let date: Date
    let amount: Double
}

enum PurchaseFeasibility {
    case high
    case medium
    case low
    
    var title: String {
        switch self {
        case .high:   return "Высокая вероятность"
        case .medium: return "Есть шансы"
        case .low:    return "Пока сложно"
        }
    }
    
    var message: String {
        switch self {
        case .high:
            return "С текущими доходами и расходами вы с большой вероятностью успеете накопить к выбранной дате."
        case .medium:
            return "Если немного поджать траты, вы сможете приблизиться к цели к выбранной дате."
        case .low:
            return "Сейчас цель выглядит тяжёлой. Подумайте о сокращении расходов или увеличении срока."
        }
    }
    
    var color: Color {
        switch self {
        case .high:   return .green
        case .medium: return .orange
        case .low:    return .red
        }
    }
}

struct PlannedPurchaseCard: View {
    let purchase: PlannedPurchase
    
    var body: some View {
        let level = feasibility(for: purchase)
        
        VStack(alignment: .leading, spacing: 12) {
           
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("К дате")
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                    Text(formatPlannedDate(purchase.date))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Цель")
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                    Text(purchase.amount.rubFormatted())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            
            // псевдо-прогресс (пока заглушка 0.6)
            let progress: CGFloat = {
                switch feasibility(for: purchase) {
                case .high:   return 0.8
                case .medium: return 0.5
                case .low:    return 0.2
                }
            }()
            
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(level.color)
                        .frame(width: progressBarWidth(progress: progress), height: 8)
                }
                
                HStack {
                    Text(level.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(level.color)
                    Spacer()
                }
            }
            
            Text(level.message)
                .font(.system(size: 16))
                .foregroundStyle(Consts.Colors.gradient1)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
    
    // маленький лайфхак чтобы прогресс-бар выглядел норм без GeometryReader
    private func progressBarWidth(progress: CGFloat) -> CGFloat {
        // макс ширина просто условно — UI всё равно подгонит
        300 * progress
    }
    
    private func formatPlannedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMMM yyyy"
        return df.string(from: date)
    }
}

func feasibility(for purchase: PlannedPurchase) -> PurchaseFeasibility {
    switch purchase.amount {
    case 0..<30000:   return .high
    case 30000..<80000: return .medium
    default:          return .low
    }
}



private let plannedPurchaseKey = "plannedPurchase"

func savePlannedPurchase(_ purchase: PlannedPurchase) {
    do {
        let data = try JSONEncoder().encode(purchase)
        UserDefaults.standard.set(data, forKey: plannedPurchaseKey)
    } catch {
        print("Ошибка кодирования plannedPurchase:", error)
    }
}

func loadPlannedPurchase() -> PlannedPurchase? {
    guard let data = UserDefaults.standard.data(forKey: plannedPurchaseKey) else {
        return nil
    }
    do {
        return try JSONDecoder().decode(PlannedPurchase.self, from: data)
    } catch {
        print("Ошибка декодирования plannedPurchase:", error)
        return nil
    }
}

/// ❗ Удаление покупки из кеша
func clearPlannedPurchase() {
    UserDefaults.standard.removeObject(forKey: plannedPurchaseKey)
}
