//
//  CategoryLimit.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 07.12.2025.
//

import Foundation
import SwiftUI

struct CategoryLimit: View {

    

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [.gradient2, .gradient1]),
                startPoint: .trailing,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .opacity(0.1)

            ScrollView {
                VStack(spacing: 16) {

                    // Любые другие карточки ниже
                    VStack {
                        VStack {
                            Text("Хватит меньше чем на месяц")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 24, weight: .bold))

                            Text("При ваших средних тратах 200 000 ₽")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 18, weight: .regular))
                            
                            
                        }
                        .padding()
                    }
                    .background(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
    }

}

#Preview {
    CategoryLimit()
}


struct CategoryLimitView: View {
    let title: String
    let systemImage: String
    let spent: Double
    let limit: Double?
    let onTap: () -> Void
    
    private var hasLimit: Bool {
        if let limit, limit > 0 { return true }
        return false
    }
    
    private var progress: Double {
        guard let limit, limit > 0 else { return 0 }
        return min(spent / limit, 1)
    }
    
    private var percent: Int {
        guard let limit, limit > 0 else { return 0 }
        return Int(progress * 100)
    }
    
    private var stateColor: Color {
        guard hasLimit else { return .green }
        switch percent {
        case 0...70:  return .green
        case 71...99: return .yellow
        default:      return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
            
            ZStack {
                // фон
                Circle()
                    .fill(stateColor.opacity(0.12))
                    .frame(width: 60, height: 60)
                
                // иконка
                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(stateColor)
                
                // дуга-прогресс только если есть лимит
                if hasLimit {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            stateColor,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 70, height: 70)
                }
            }
            
            // потрачено — всегда показываем
            Text(spent.rubFormatted())
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(stateColor)
            
            // лимит — только если он задан
            if let limit, limit > 0 {
                Text(limit.rubFormatted())
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}
