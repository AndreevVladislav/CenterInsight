//
//  CenterInsightApp.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import SwiftUI

@main
struct CenterInsightApp: App {
    var body: some Scene {
        LaunchScreen(config: .init(forceHideLogo: false)) {
            Image(.launchScreenLogo)
        } rootContent: {
            RootView()
        }
    }
}
