//
//  TransactionItem.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

struct TransactionItem: View {
    
    let id: Int            // id транзакции из API
    let date: String       // "2023-12-13T00:00:00"
    let type: String       // "withdrawal" / "deposit"
    let amount: Double
    var category: String   // строка из API, например "Misc"
    
    @State private var categoryString: String = ""
    @State private var denga: String = ""
    @State private var iconName: String = "questionmark.circle"
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // основная строка транзакции
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.gradient2, .gradient1]),
                            startPoint: .trailing,
                            endPoint: .bottom
                        )
                    )
                    .font(.system(size: 40))
                
                VStack {
                    Text(formatDate(date))
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.system(size: 14, weight: .regular))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(categoryString)
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(denga)
                    .foregroundStyle(.black.opacity(0.8))
                    .font(.system(size: 18, weight: .bold))
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(duration: 0.25)) {
                    isExpanded.toggle()
                }
            }
            
            // дропдаун категорий
            // Выбираем список категорий в зависимости от типа транзакции
            let availableCategories: [TransactionCategory] = {
                if type == "deposit" {
                    return TransactionCategory.allCases        // показываем зарплату
                } else {
                    return TransactionCategory.allCases.filter { $0 != .salary } // скрываем её
                }
            }()

            if isExpanded {
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Изменить категорию")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)

                    ForEach(availableCategories, id: \.self) { cat in
                        Button {
                            Task {
                                do {
                                    try await correctTransactionCategory(id: id, newCategory: cat.apiValue)
                                    print("Категория успешно изменена на \(cat.apiValue)")
                                } catch {
                                    print("Ошибка изменения категории:", error)
                                }
                            }

                            categoryString = cat.title
                            iconName = cat.iconName

                            print("Change category for transaction id \(id) to \(cat.apiValue)")

                            withAnimation(.spring(duration: 0.25)) {
                                isExpanded = false
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: cat.iconName)
                                    .font(.system(size: 16))
                                Text(cat.title)
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(16)
        .onAppear {
            // знак +/− и формат суммы
            if type == "withdrawal" {
                denga = "- \(amount.rubFormatted())"
            } else {
                denga = "+ \(amount.rubFormatted())"
            }
            
            // начальные категория и иконка
            if let cat = TransactionCategory(apiValue: category) {
                categoryString = cat.title
                iconName = cat.iconName
            } else {
                categoryString = "Неизвестная категория"
                iconName = "questionmark.circle"
            }
        }
    }
    
    func formatDate(_ isoString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = inputFormatter.date(from: isoString) else {
            return isoString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        return outputFormatter.string(from: date)
    }
}


