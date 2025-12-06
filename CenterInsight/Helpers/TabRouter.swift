//
//  TabRouter.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI
import Combine

final class TabRouter: ObservableObject {
    @Published var selected: Int = 0
}
