//
//  ContentView.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label(Localized("Dashboard", "Ana Sayfa"), systemImage: "leaf.fill")
                }
            
            ActivityListView()
                .tabItem {
                    Label(Localized("History", "Geçmiş"), systemImage: "list.bullet.rectangle.portrait")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
