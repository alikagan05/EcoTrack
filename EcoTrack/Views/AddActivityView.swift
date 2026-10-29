//
//  AddActivityView.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    // Observe LanguageManager to trigger redraw on toggle
    @ObservedObject var languageManager = LanguageManager.shared
    
    @State private var selectedType: CarbonCalculator.ActivityType = .transportation
    @State private var selectedTransportType: CarbonCalculator.TransportType = .car
    @State private var value: Double = 0
    @State private var date: Date = Date()
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var estimatedCO2: Double {
        if selectedType == .transportation {
            return CarbonCalculator.calculate(type: selectedType, value: value, transportType: selectedTransportType)
        } else {
            return CarbonCalculator.calculate(type: selectedType, value: value)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(Localized("Activity Details", "Aktivite Detayları"))) {
                    Picker(Localized("Type", "Tür"), selection: $selectedType) {
                        ForEach(CarbonCalculator.ActivityType.allCases, id: \.self) { type in
                            Label(type.localizedName, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    
                    if selectedType == .transportation {
                        Picker(Localized("Vehicle", "Araç"), selection: $selectedTransportType) {
                            ForEach(CarbonCalculator.TransportType.allCases, id: \.self) { type in
                                Text(type.localizedName)
                                    .tag(type)
                            }
                        }
                    }
                    
                    HStack {
                        Text("\(Localized("Amount", "Miktar")) (\(selectedType.unit))")
                        Spacer()
                        TextField("0", value: $value, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker(Localized("Date", "Tarih"), selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    HStack {
                        Text(Localized("Estimated CO2", "Tahmini CO2"))
                        Spacer()
                        Text("\(estimatedCO2, specifier: "%.2f") kg")
                            .fontWeight(.bold)
                            .foregroundColor(estimatedCO2 > 10 ? .red : .green)
                    }
                }
            }
            .navigationTitle(Localized("Log Activity", "Aktivite Ekle"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localized("Cancel", "İptal")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Localized("Save", "Kaydet")) {
                        saveActivity()
                    }
                    .disabled(value <= 0)
                }
            }
        }
    }
    
    private func saveActivity() {
        withAnimation {
            let newActivity = Activity(context: viewContext)
            newActivity.id = UUID()
            newActivity.date = date
            newActivity.type = selectedType
            newActivity.value = value
            newActivity.carbonAmount = estimatedCO2
            
            if selectedType == .transportation {
                newActivity.transportType = selectedTransportType
            }
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
