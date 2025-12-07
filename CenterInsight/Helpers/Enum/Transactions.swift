//
//  Transactions.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation

enum TransactionCategory: String, CaseIterable {
    case food
    case rent
    case shopping
    case transport
    case misc
    case salary

    var title: String {
        switch self {
        case .food:      return "Еда"
        case .rent:      return "Аренда"
        case .shopping:  return "Покупки"
        case .transport: return "Транспорт"
        case .misc:      return "Другое"
        case .salary:    return "Зарплата"
        }
    }
    
    var iconName: String {
        switch self {
        case .food:      return "basket.fill"
        case .rent:      return "chair.lounge.fill"
        case .shopping:  return "tag.fill"
        case .transport: return "bus.fill"
        case .misc:      return "questionmark.circle"
        case .salary:    return "creditcard"
        }
    }
    
    /// Как строка для API (например "Misc")
    var apiValue: String {
        switch self {
        case .food:      return "Food"
        case .rent:      return "Rent"
        case .shopping:  return "Shopping"
        case .transport: return "Transport"
        case .misc:      return "Misc"
        case .salary:    return "Salary"
        }
    }
    
    /// Инициализация из строки, пришедшей с API
    init?(apiValue: String) {
        self.init(rawValue: apiValue.lowercased())
    }
    
    /// Безопасный вариант с дефолтом `.misc`
    static func fromAPI(_ value: String) -> TransactionCategory {
        TransactionCategory(rawValue: value.lowercased()) ?? .misc
    }
}

