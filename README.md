# EcoTrack 🌱

**EcoTrack** is a personal carbon footprint and sustainability tracker for iOS, built with SwiftUI and Core Data.

## Features
- **Carbon Footprint Tracking**: Log daily activities across **Transportation** (Car, Flight, Bus, Train), **Food** (kcal), and **Energy** (kWh).
- **Dashboard & Weekly Trends**: View today's total emissions and weekly bar charts (Swift Charts on iOS 16+, custom fallback chart on iOS 15).
- **Multi-language Support**: Instant in-app toggle between **English (🇬🇧)** and **Turkish (🇹🇷)**.
- **Offline Persistence**: Powered by Core Data with full iOS 15+ compatibility.

## Tech Stack
- **UI**: SwiftUI, Swift Charts
- **Persistence**: Core Data (`NSPersistentContainer`)
- **Architecture**: MVVM / ObservableObject localization state
