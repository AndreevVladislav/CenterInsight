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
}
