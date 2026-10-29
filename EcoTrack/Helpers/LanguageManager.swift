//
//  LanguageManager.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var language: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en" {
        didSet {
            UserDefaults.standard.set(language, forKey: "selectedLanguage")
        }
    }
    
    private init() {}
    
    // Helper to toggle language
    func toggle() {
        language = (language == "en") ? "tr" : "en"
    }
    
    // Main localization function
    func localized(_ en: String, _ tr: String) -> String {
        return language == "en" ? en : tr
    }
}

// Global helper for cleaner syntax in views
// Usage: Localized("Hello", "Merhaba")
func Localized(_ en: String, _ tr: String) -> String {
    return LanguageManager.shared.localized(en, tr)
}
