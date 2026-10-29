//
//  Activity+Helpers.swift
//  EcoTrack
//
//  Created by ali kağan on 8.01.2026.
//

import Foundation
import CoreData

// Extend the auto-generated Activity class
extension Activity {
    
    // Computed property to convert the stored String back to our Enum
    var type: CarbonCalculator.ActivityType {
        get {
            guard let raw = typeRawValue else { return .transportation }
            return CarbonCalculator.ActivityType(rawValue: raw) ?? .transportation
        }
        set {
            typeRawValue = newValue.rawValue
        }
    }
    
    // Helper for Transport Subtype
    var transportType: CarbonCalculator.TransportType? {
        get {
            guard let raw = subtypeRawValue else { return nil }
            return CarbonCalculator.TransportType(rawValue: raw)
        }
        set {
            subtypeRawValue = newValue?.rawValue
        }
    }
    
    // Safer date accessor
    var wrappedDate: Date {
        date ?? Date()
    }
}
