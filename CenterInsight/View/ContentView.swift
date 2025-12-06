//
//  ContentView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var tabRouter = TabRouter()
    
    var body: some View {
        
        TabView(selection: $tabRouter.selected) {
            NavigationStack {
                HomeView()
            }
            .tint(.white)
            .tabItem {
                Label("Главная", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                OperaciiView()
            }
            .tint(.white)
            .tabItem {
                Label("Операции", systemImage: "arrow.left.arrow.right.square.fill")
            }
            .tag(1)
            
            NavigationStack {
                PlanView()
            }
            .tint(.white)
            .tabItem {
                Label("Планы", systemImage: "calendar")
            }
            .tag(2)
            
            NavigationStack {
                AnalView()
            }
            .tint(.white)
            .tabItem {
                Label("Аналитика", systemImage: "chart.bar.xaxis.ascending")
            }
            .tag(3)
            
        }
        .colorScheme(.light)
        .tint(Consts.Colors.greyBack)
        .environmentObject(tabRouter)
    }
}

#Preview {
    ContentView()
}
