//
//  GradientRingView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct GradientRingView: View {
    var value: Double          // 0...100
    var lineWidth: CGFloat = 8
    var duration: Double = 1.2
    var trigger: Int = 0       // 👈 внешний триггер перезапуска

    private let startOffset: CGFloat = 0.01

    private var targetTo: CGFloat {
        let clamped = min(max(value, 0), 100)
        let progress = clamped / 100.0
        return startOffset + CGFloat(progress) * (1.0 - startOffset)
    }

    @State private var animatedTo: CGFloat = 0.01

    private var gradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(stops: [
                .init(color: .red,    location: 0.0),
                .init(color: .red,    location: 0.37),
                .init(color: .yellow, location: 0.42),
                .init(color: .yellow, location: 0.68),
                .init(color: .green,  location: 0.73),
                .init(color: .green,  location: 0.99),
                .init(color: .green,  location: 1.0)
            ]),
            center: .center
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            Circle()
                .trim(from: startOffset, to: animatedTo)
                .stroke(gradient,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // старт с 12 часов, по часовой
        }
        .padding(lineWidth / 2)
        .onAppear { restartAnimation() }
        .onChange(of: value)   { _ in restartAnimation() } // если меняется значение — плавно перерисуем
        .onChange(of: trigger) { _ in restartAnimation() } // 👈 внешний перезапуск
    }

    private func restartAnimation() {
        let to = targetTo
        // мгновенный сброс в старт без анимации
        withAnimation(.none) { animatedTo = startOffset }
        // на следующем тике — плавная заливка к цели
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: duration)) {
                animatedTo = to
            }
        }
    }
}
