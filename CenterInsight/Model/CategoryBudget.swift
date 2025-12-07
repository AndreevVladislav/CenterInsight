//
//  Untitled.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 07.12.2025.
//
import Foundation

struct CategoryBudget: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    var spent: Double
    var limit: Double?
}
