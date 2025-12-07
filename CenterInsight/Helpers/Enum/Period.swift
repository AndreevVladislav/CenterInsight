//
//  Period.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation

enum Period: String, CaseIterable, Identifiable {
    case week  = "Неделя"
    case month = "Месяц"
    case year  = "Год"
    // если есть "Все время" — можешь добавить .all

    var id: Self { self }
    
    /// Значение, которое ждёт backend в query-параметре `period`
    var apiValue: String {
        switch self {
        case .week:  return "week"
        case .month: return "month"
        case .year:  return "year"
        }
    }
}
