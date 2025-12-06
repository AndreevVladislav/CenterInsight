//
//  TransactionItem.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

struct TransactionItem: View {
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chair.lounge.fill")
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.gradient2, .gradient1]),
                            startPoint: .trailing,
                            endPoint: .bottom
                        )
                    )
                    .font(.system(size: 40))
                VStack {
                    Text("25 октября 2025")
                        .foregroundStyle(.black.opacity(0.6))
                        .font(.system(size: 14, weight: .regular))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Транспорт")
                        .foregroundStyle(.black.opacity(0.6))
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                Spacer()
                Text("-200")
                    .foregroundStyle(.black.opacity(0.6))
                    .font(.system(size: 18, weight: .bold))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(16)
        
    }
}

#Preview {
    TransactionItem()
}
