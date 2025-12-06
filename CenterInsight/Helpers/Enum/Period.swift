//
//  Period.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation

enum Period: String, CaseIterable, Identifiable {
    case week = "Нед"
    case month = "Мес"
    case year = "Год"
    
    var id: Self { self }
}
