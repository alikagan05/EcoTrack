//
//  ActivityListView.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import CoreData

struct ActivityListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // Observe LanguageManager
    @ObservedObject var languageManager = LanguageManager.shared
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)],
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities) { activity in
                    HStack {
                        Image(systemName: activity.type.icon)
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(activity.type.localizedName)
                                    .font(.headline)
                                
                                if activity.type == .transportation, let subtype = activity.transportType {
                                    Text("(\(subtype.localizedName))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Text(activity.wrappedDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(activity.carbonAmount, specifier: "%.2f") kg CO2")
                                .fontWeight(.bold)
                            Text("\(activity.value, specifier: "%.1f") \(activity.type.unit)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle(Localized("History", "Geçmiş"))
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { activities[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
