//
//  RootView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct RootView: View {
    
    @State private var showLaunchScreen = true // Управляет видимостью LaunchScreenView
    
    var body: some View {
        contentView()
            .onAppear {
               
                
            }
            
    }
    
    @ViewBuilder
    private func contentView() -> some View {
//        if showOnboarding {
//            OnboardingView()
//        } else if showPaywall {
//            PaywallView()
//        } else if showRateUs {
//            RateUsView()
//        } else {
            ContentView()
//        }
    }
}
