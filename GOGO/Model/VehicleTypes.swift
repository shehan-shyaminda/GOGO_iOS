//
//  VehicleModel.swift
//  GOGO
//
//  Created by Snippets on 8/30/25.
//  

import Foundation


struct VehicleTypes {
    let id: String
    let icon: String
    let name: String
    let perKm: Double
    var tripCharge: Double
    
    init?(id: String, dict: [String: Any]) {
        guard let name = dict["name"] as? String,
              let icon = dict["icon"] as? String,
              let perKm = dict["perKm"] as? Double else {
            return nil
        }
        self.id = id
        self.icon = icon
        self.name = name
        self.perKm = perKm
        self.tripCharge = 0.0
    }
}
