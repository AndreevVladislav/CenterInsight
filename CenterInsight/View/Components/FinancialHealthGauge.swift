//
//  FinancialHealthGauge.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

/// Верхняя полудуга от левого низа к правому
struct GaugeArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        return path
    }
}

struct FinancialHealthGauge: View {
    var value: Double   // 0...100

    private var clamped: Double {
        min(max(value, 0), 100)
    }

    private var progress: Double {
        clamped / 100.0
    }

    var body: some View {
        GeometryReader { geo in
            let size   = min(geo.size.width, geo.size.height)
            let radius = size / 2
            let angle  = 180.0 - 180.0 * progress    // 180° слева → 0° справа
            let rad    = angle * .pi / 180.0

            let knobRadius = radius - 8              // чуть внутрь, чтобы лежал на дуге
            let knobX = CGFloat(cos(rad)) * knobRadius
            let knobY = CGFloat(sin(rad)) * knobRadius

            ZStack {
                // Серый фон-полудуга
                GaugeArc()
                    .stroke(
                        Color.white.opacity(0.12),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: size, height: size)

                // Цветная часть с градиентом
                GaugeArc()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.red, .yellow, .green]),
                            center: .center,
                            startAngle: .degrees(180),
                            endAngle: .degrees(0)
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .animation(.easeOut(duration: 0.3), value: progress)

                // Кружок-ползунок на конце дуги
                Circle()
                    .fill(color(for: clamped))
                    .frame(width: 22, height: 22)
                    .offset(x: knobX, y: knobY)
                    .animation(.easeOut(duration: 0.3), value: progress)

                // Число в центре
                Text("\(Int(clamped))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func color(for value: Double) -> Color {
        switch value {
        case 0..<40:   return .red
        case 40..<70:  return .yellow
        default:       return .green
        }
    }
}
