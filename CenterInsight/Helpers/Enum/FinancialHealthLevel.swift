//
//  FinancialHealthLevel.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

enum FinancialHealthLevel {
    case good
    case medium
    case bad

    static func level(for value: Double) -> FinancialHealthLevel {
        switch value {
        case 70...100: return .good
        case 40..<70:  return .medium
        default:       return .bad
        }
    }

    var text: String {
        switch self {
        case .good:
            return "Финансы под контролем 👍"
        case .medium:
            return "Можно улучшить 👀"
        case .bad:
            return "Требуется внимание ⚠️"
        }
    }

    var color: Color {
        switch self {
        case .good:   return .green
        case .medium: return .yellow
        case .bad:    return .red
        }
    }
    
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
        case .medium: return .yellow.opacity(0.30)
        case .bad:    return .red.opacity(0.25)
        }
    }

    var textColor: Color {
        switch self {
        case .good:   return .green
        case .medium: return .yellow.darker() // можно оставить .yellow
        case .bad:    return .red
        }
    }
}
