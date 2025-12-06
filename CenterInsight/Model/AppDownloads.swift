//
//  AppDownloads.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

struct AppDownload: Identifiable {
    var id: UUID = .init()
    var category: TransactionCategory
    var downloads: Double   // количество транзакций (или сумма, если захочешь)

    // график по-прежнему использует `month`,
    // но теперь это название категории
    var month: String {
        category.title
    }
}

extension [AppDownload] {
    func findDownloads(_ on: String) -> Double? {
        if let download = self.first(where: {
            $0.month == on
        }) {
            return download.downloads
        }
        return nil
    }

    func index(_ on: String) -> Int {
        if let index = self.firstIndex(where: {
            $0.month == on
        }) {
            return index
        }
        return 0
    }
}



extension Date {
    static func createDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year

        let calendar = Calendar.current
        let date = calendar.date(from: components) ?? .init()

        return date
    }
}

