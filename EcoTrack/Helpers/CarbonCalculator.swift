//
//  CarbonCalculator.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import Foundation

struct CarbonCalculator {
    enum ActivityType: String, CaseIterable, Codable {
        case transportation = "Transportation"
        case food = "Food"
        case energy = "Energy"
        
        var icon: String {
            switch self {
            case .transportation: return "car.fill"
            case .food: return "fork.knife"
            case .energy: return "bolt.fill"
            }
        }
        
        var localizedName: String {
            switch self {
            case .transportation: return Localized("Transportation", "Ulaşım")
            case .food: return Localized("Food", "Gıda")
            case .energy: return Localized("Energy", "Enerji")
            }
        }
        
        var unit: String {
            switch self {
            case .transportation: return "km"
            case .food: return "kcal"
            case .energy: return "kWh"
            }
        }
    }
    
    enum TransportType: String, CaseIterable, Codable {
        case car = "Car"
        case plane = "Plane"
        case bus = "Bus"
        case train = "Train"
        
        var localizedName: String {
            switch self {
            case .car: return Localized("Car", "Araba")
            case .plane: return Localized("flight", "Uçak")
            case .bus: return Localized("Bus", "Otobüs")
            case .train: return Localized("Train", "Tren")
            }
        }
        
        // Co2 factor per km
        var factor: Double {
            switch self {
            case .car: return 0.19
            case .plane: return 0.25 // Short haul avg
            case .bus: return 0.10
            case .train: return 0.04
            }
        }
    }
    
    // Base Emission factors
    private static let factors: [ActivityType: Double] = [
        .transportation: 0.19,     // Default (Car)
        .food: 0.00125,            // 2.5kg / 2000kcal
        .energy: 0.4               // Global average per kWh
    ]
    
    static func calculate(type: ActivityType, value: Double, transportType: TransportType? = nil) -> Double {
        if type == .transportation, let transport = transportType {
            return value * transport.factor
        }
        
        let factor = factors[type] ?? 0.0
        return value * factor
    }
}
