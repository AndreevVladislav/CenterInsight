//
//  FinancialTegLevel.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

enum FinancialTegLevel {
    case good
    case medium
    case bad
    
    var title: String {
        switch self {
        case .good:   return "Всё ок"
        case .medium: return "На грани"
        case .bad:    return "Опасно"
        }
    }
    
    var textColor: Color {
        switch self {
        case .good:   return .green
        case .medium: return .orange
        case .bad:    return .red
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .good:   return Color.green.opacity(0.15)
        case .medium: return Color.orange.opacity(0.15)
        case .bad:    return Color.red.opacity(0.15)
        }
    }
}



// — Можно добавить лёгкое «утемнение» желтому, если нужно
extension Color {
    func darker(_ amount: Double = 0.25) -> Color {
        self.opacity(1 - amount)
    }
}
