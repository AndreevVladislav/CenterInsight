//
//  Double.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation

extension Double {
    func rubFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        formatter.currencySymbol = "₽"
        formatter.currencyCode = "RUB"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        // Ключ — меняем порядок элементов!
        formatter.positiveFormat = "#,##0.## ¤"
        formatter.negativeFormat = "-#,##0.## ¤"

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
