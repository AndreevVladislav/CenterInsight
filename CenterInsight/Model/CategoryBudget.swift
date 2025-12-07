//
//  Untitled.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 07.12.2025.
//
import Foundation

struct CategoryBudget {
    var title: String       // "Еда"
    var apiTitle: String    // "Food"
    var systemImage: String
    var spent: Double       // потрачено в текущем месяце
    var limit: Double?      // лимит (nil = без лимита)
}
