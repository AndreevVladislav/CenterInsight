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
        case .good:   return "Хорошо"
        case .medium: return "Уже неплохо"
        case .bad:    return "Плохо"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .good:   return .green.opacity(0.25)
        case .medium: return .yellow.opacity(0.2)
        case .bad:    return .red.opacity(0.25)
        }
    }

    var textColor: Color {
        switch self {
        case .good:   return .green
        case .medium: return .yellow
        case .bad:    return .red
        }
    }
}

// — Можно добавить лёгкое «утемнение» желтому, если нужно
extension Color {
    func darker(_ amount: Double = 0.25) -> Color {
        self.opacity(1 - amount)
    }
}
