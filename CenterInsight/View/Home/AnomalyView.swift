//
//  AnomalyView.swift
//  CenterInsight
//
//  Created by Vladislav Andreev on 07.12.2025.
//

import Foundation
import SwiftUI

struct AnomalyView: View {
    
    @State private var anomalies: [AnomalyItem] = []
        @State private var unreadCount: Int = 0
        
        var body: some View {
            ScrollView {
                ZStack {
                    Color.white.ignoresSafeArea()
                    LinearGradient(
                        gradient: Gradient(colors: [.gradient2, .gradient1]),
                        startPoint: .trailing,
                        endPoint: .bottom
                    ).ignoresSafeArea()
                }
                .ignoresSafeArea()
                LazyVStack(spacing: 12) {
                    
                    if !anomalies.isEmpty {
                        Text("Аномальные операции")
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                    }
                    
                    ForEach(anomalies.indices, id: \.self) { i in
                        AnomalyItemView(
                            anomaly: $anomalies[i],
                            onRead: {
                                markAsRead(index: i, sendToServer: true)
                            },
                            onAppearRead: {
                                handleAppear(index: i)
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .task {
                await loadAnomalies()
            }
        }
        
        // MARK: - Networking
        
        private func loadAnomalies() async {
            do {
                let result = try await fetchAnomalies()
                await MainActor.run {
                    anomalies = result.items
                    unreadCount = result.unread_count
                }
            } catch {
                print("Ошибка загрузки аномалий:", error)
            }
        }
        
        /// Локально пометить как прочитанное + опционально отправить PATCH
        private func markAsRead(index: Int, sendToServer: Bool) {
            guard anomalies.indices.contains(index) else { return }
            guard !anomalies[index].is_read else { return }
            
            anomalies[index].is_read = true
            unreadCount = anomalies.filter { !$0.is_read }.count
            
            if sendToServer {
                let id = anomalies[index].id
                Task {
                    do {
                        try await markAnomalyReadRemote(id: id)
                    } catch {
                        print("Ошибка PATCH аномалии \(id):", error)
                    }
                }
            }
        }
        
        /// Автоматическое прочтение по .onAppear с небольшой задержкой
        private func handleAppear(index: Int) {
            guard anomalies.indices.contains(index) else { return }
            guard !anomalies[index].is_read else { return }
            
            let id = anomalies[index].id
            
            Task {
                // небольшая задержка, чтобы не отмечать мгновенно при скролле
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 0.5 сек
                
                // после задержки проверяем, не изменилось ли состояние
                guard anomalies.indices.contains(index),
                      !anomalies[index].is_read else { return }
                
                // помечаем прочитанным локально и на сервере
                markAsRead(index: index, sendToServer: true)
            }
        }

        /// изменяем состояние при нажатии
        func markAsRead(index: Int) {
            guard anomalies.indices.contains(index) else { return }
            anomalies[index].is_read = true
            unreadCount = anomalies.filter { !$0.is_read }.count
        }
    
    private func fetchAnomalies(skip: Int = 0, limit: Int = 100) async throws -> AnomalyResponse {
        guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/anomalies?skip=\(skip)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AnomalyResponse.self, from: data)
    }
}

#Preview {
    AnomalyView()
}

struct AnomalyResponse: Codable {
    let total_count: Int
    let unread_count: Int
    let items: [AnomalyItem]
}

struct AnomalyItem: Codable, Identifiable {
    let id: Int
    let date: String
    let amount: Double
    let category: String
    let title: String
    let description: String
    var is_read: Bool
}

struct AnomalyItemView: View {

    @Binding var anomaly: AnomalyItem
    let onRead: () -> Void          // тап по карточке
    let onAppearRead: () -> Void    // появление в зоне видимости

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: anomaly.is_read ? "exclamationmark.circle" : "exclamationmark.triangle.fill")
                    .foregroundColor(anomaly.is_read ? .gray : .red)
                    .font(.system(size: 28))
                
                Text(anomaly.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(anomaly.is_read ? .gray : .red)
                
                Spacer()
            }

            Text(anomaly.description)
                .font(.system(size: 15))
                .foregroundColor(anomaly.is_read ? .gray.opacity(0.6) : .black.opacity(0.8))

            HStack {
                Text(formatDate(anomaly.date))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                Spacer()

                if anomaly.is_read {
                    Text("Прочитано")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.green)
                } else {
                    Text("Новое")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(
            anomaly.is_read
            ? Color.white
            : Color.red.opacity(0.08)
        )
        .cornerRadius(16)
        .onTapGesture {
            onRead()
        }
        .onAppear {
            // триггерим автопрочтение, когда карточка появилась
            onAppearRead()
        }
    }

    func formatDate(_ iso: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let d = f.date(from: iso) else { return iso }

        let out = DateFormatter()
        out.locale = .init(identifier: "ru_RU")
        out.dateFormat = "d MMMM yyyy"

        return out.string(from: d)
    }
}

struct AnomalyStatusUpdateRequest: Codable {
    let is_read: Bool
}

func markAnomalyReadRemote(id: Int) async throws {
    guard let url = URL(string: "https://v487263.hosted-by-vdsina.com/api/v1/anomalies/\(id)/status") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = AnomalyStatusUpdateRequest(is_read: true)
    request.httpBody = try JSONEncoder().encode(body)
    
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard let http = response as? HTTPURLResponse,
          200..<300 ~= http.statusCode else {
        throw URLError(.badServerResponse)
    }
}
