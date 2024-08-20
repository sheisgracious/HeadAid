//
//  HeadacheData.swift
//  HeadAid
//
//

import Foundation

struct HeadacheData: Identifiable {
    let id: UUID
    var date: Date
    var duration: TimeInterval
    var intensity: Int // Scale of 1 to 10
    var triggers: [String]
    var symptoms: [String]
    var notes: String?
    
    init(date: Date, duration: TimeInterval, intensity: Int, triggers: [String], symptoms: [String], notes: String? = nil) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.intensity = intensity
        self.triggers = triggers
        self.symptoms = symptoms
        self.notes = notes
    }
}

