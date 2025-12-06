//
//  OperaciiView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 05.12.2025.
//

import Foundation
import SwiftUI

struct OperaciiView: View {
    
    /// Положение прокрутки
    @State private var scrollOffset = CGFloat.zero
    
    @State private var selection: Period = .month
    
    @State private var openRashodi: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                    startPoint: .trailing,
                    endPoint: .bottom
                )
                LinearGradient(
                    gradient: Gradient(colors: [.gradient2, .gradient1]),
                    startPoint: .trailing,
                    endPoint: .bottom
                ).opacity(0.1)
                .frame(maxHeight: 200)
                
            }
            .ignoresSafeArea()
            ObservedScrollView(scrollOffset: $scrollOffset) { proxy in
                VStack(spacing: 0) {
                    VStack {
                        Text("Операции")
                            .foregroundStyle(.white)
                            .font(.system(size: 28, weight: .bold))
                            .padding(.top, 40)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            
                            Text("Декабрь")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            CustomSegmentedControl(selection: $selection)
                                .onChange(of: selection) { newValue in
                                    print("Выбран период в родителе: \(newValue.rawValue)")
                                }
                            .frame(width: 200)
                            
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            VStack {
                                Text("2000")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Расходы")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            .onTapGesture {
                                openRashodi = true
                            }
                            
                            VStack {
                                Text("2000")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Поступления")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                        }
                        .padding(.horizontal)
                        .opacity((self.scrollOffset > 115) ? 0 : 1)
                    }
                    .padding(.bottom, 35)
                    .frame(maxWidth: .infinity)
                    VStack {
                        ForEach(0..<40) { index in
                            TransactionItem()
                        }
                    }
                    .padding()
                    .background(
                        ZStack {
                            Color.white
                            LinearGradient(
                                gradient: Gradient(colors: [.gradient2, .gradient1]),
                                startPoint: .trailing,
                                endPoint: .bottom
                            ).opacity(0.1)
                        }
                    )
                    .cornerRadius(16)
                    .padding(.top, -20)
                }
                
            }
            
            .ignoresSafeArea()
            .sheet(isPresented: $openRashodi) {
                RashodiView()
                    .presentationDragIndicator(.visible)
            }
            
            if(self.scrollOffset > 115) {
                VStack {
                    VStack {
                        HStack {
                            VStack {
                                Text("2000")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Расходы")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                            
                            VStack {
                                Text("2000")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Поступления")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(0.12))
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.gradient2, .gradient2]),
                            startPoint: .trailing,
                            endPoint: .bottom
                        )
                        
                    )
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OperaciiView()
}

struct CustomSegmentedControl: View {
    @Binding var selection: Period
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Period.allCases) { period in
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        selection = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selection == period ? .black : .white)
                        .background(
                            ZStack {
                                if selection == period {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.85))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.12))
        )
    }
}
