//
//  ZdorovieView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 06.12.2025.
//

import Foundation
import SwiftUI

struct ZdorovieView: View {
    
    @State private var animTick = 0 
    
    @State private var healthValue: Double = 100
    
    @State private var graphType: GraphType = .donut
    
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
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        ZStack {
                            GradientRingView(value: healthValue, lineWidth: 10, duration: 1.2, trigger: animTick)
                                .frame(width: 100, height: 100)
                            Text("\(Int(healthValue))%")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 20, weight: .heavy))
                        }
                        .padding()
                        
                        Text("jahsfghjsagdf")
                            .foregroundStyle(.black.opacity(0.7))
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                    }
                    .background(.white)
                    .cornerRadius(16)
                    
                    
                    VStack {
                        VStack {
                            Text("Красные флаги")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.red.opacity(0.15))
                            .cornerRadius(12)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.red.opacity(0.15))
                            .cornerRadius(12)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.red.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(16)
                    
                    VStack {
                        VStack {
                            Text("Зеленые флаги")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.green.opacity(0.15))
                            .cornerRadius(12)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.green.opacity(0.15))
                            .cornerRadius(12)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(.green)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 4)
                                VStack {
                                    Text("ajksfhjkdahf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 18, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("ajksfhjkdahf asdjf  sadf  asdf asdf asdf asdf asdfafsdf")
                                        .foregroundStyle(.black.opacity(0.7))
                                        .font(.system(size: 15, weight: .regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(8)
                            .background(.green.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(16)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ZdorovieView()
}
