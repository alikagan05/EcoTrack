//
//  DashboardView.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import CoreData
import Charts

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Observe LanguageManager
    @ObservedObject var languageManager = LanguageManager.shared
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)],
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    @State private var showingAddActivity = false
    
    var totalCO2Today: Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return activities
            .filter { calendar.startOfDay(for: $0.wrappedDate) == today }
            .reduce(0) { $0 + $1.carbonAmount }
    }
    
    struct DailyData: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Double
    }

    var weeklyData: [DailyData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var data: [DailyData] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dailyAmount = activities
                    .filter { calendar.startOfDay(for: $0.wrappedDate) == date }
                    .reduce(0) { $0 + $1.carbonAmount }
                data.append(DailyData(date: date, amount: dailyAmount))
            }
        }
        return data.reversed()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Card
                    VStack(alignment: .leading) {
                        Text(Localized("Today's Carbon Footprint", "Bugünkü Ayak İzi"))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("\(totalCO2Today, specifier: "%.2f") kg")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Chart
                    VStack(alignment: .leading) {
                        Text(Localized("Weekly Trends", "Haftalık Grafikler"))
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(weeklyData) { item in
                                    BarMark(
                                        x: .value("Day", item.date, unit: .day),
                                        y: .value("CO2", item.amount)
                                    )
                                    .foregroundStyle(Color.green.gradient)
                                    .cornerRadius(4)
                                }
                            }
                            .frame(height: 200)
                        } else {
                            // Fallback for iOS 15
                            HStack(alignment: .bottom, spacing: 10) {
                                ForEach(weeklyData) { item in
                                    VStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.green)
                                            .cornerRadius(4)
                                            .frame(height: item.amount == 0 ? 1 : CGFloat(item.amount) * 5) // Simple scale
                                        Text(item.date, format: .dateTime.weekday())
                                            .font(.caption2)
                                    }
                                }
                            }
                            .frame(height: 150)
                            .padding()
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Button(action: { showingAddActivity = true }) {
                        Label(Localized("Log Activity", "Aktivite Ekle"), systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("EcoTrack")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { LanguageManager.shared.toggle() }) {
                        Text(LanguageManager.shared.language == "en" ? "🇬🇧" : "🇹🇷")
                            .font(.largeTitle)
                    }
                }
            }
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView()
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
