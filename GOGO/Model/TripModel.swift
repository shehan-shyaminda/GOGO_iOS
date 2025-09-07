//
//  TripModel.swift
//  GOGO
//
//  Created by Snippets on 8/30/25.
//

import Foundation

struct TripModel {
    let id: String
    let driverId: String
    let passengerId: String
    let pickDescription: String
    let dropDescription: String
    let pickLocation: String
    let dropLocation: String
    let tripTimeStamp: TimeInterval
    let dropLongitude: Double
    let dropLatitude: Double
    let pickLongitude: Double
    let pickLatitude: Double
    let tripStatus: Int
    var tripCharge: Double
    var vehicleType: String
    var driverTripCompleted: Int
    var passengerTripCompleted: Int
    
    init(id: String,
         driverId: String,
         passengerId: String,
         pickDescription: String,
         dropDescription: String,
         pickLocation: String,
         dropLocation: String,
         tripTimeStamp: TimeInterval,
         dropLongitude: Double,
         dropLatitude: Double,
         pickLongitude: Double,
         pickLatitude: Double,
         tripStatus: Int,
         tripCharge: Double,
         vehicleType: String,
         passengerTripCompleted: Int,
         driverTripCompleted: Int) {
        self.id = id
        self.driverId = driverId
        self.passengerId = passengerId
        self.pickDescription = pickDescription
        self.dropDescription = dropDescription
        self.pickLocation = pickLocation
        self.dropLocation = dropLocation
        self.tripTimeStamp = tripTimeStamp
        self.dropLongitude = dropLongitude
        self.dropLatitude = dropLatitude
        self.pickLongitude = pickLongitude
        self.pickLatitude = pickLatitude
        self.tripStatus = tripStatus
        self.tripCharge = tripCharge
        self.vehicleType = vehicleType
        self.driverTripCompleted = driverTripCompleted
        self.passengerTripCompleted = passengerTripCompleted
    }
    
    
    init?(id: String, dict: [String: Any]) {
        guard let driverId = dict["driverId"] as? String,
              let passengerId = dict["passengerId"] as? String,
              let pickDescription = dict["pickDescription"] as? String,
              let dropDescription = dict["dropDescription"] as? String,
              let pickLocation = dict["pickLocation"] as? String,
              let dropLocation = dict["dropLocation"] as? String,
              let tripTimeStamp = dict["tripTimeStamp"] as? TimeInterval,
              let dropLongitude = dict["dropLongitude"] as? Double,
              let dropLatitude = dict["dropLatitude"] as? Double,
              let pickLongitude = dict["pickLongitude"] as? Double,
              let pickLatitude = dict["pickLatitude"] as? Double,
              let tripStatus = dict["tripStatus"] as? Int,
              let driverTripCompleted = dict["driverTripCompleted"] as? Int,
              let passengerTripCompleted = dict["passengerTripCompleted"] as? Int,
              let tripCharge = dict["tripCharge"] as? Double else {
            return nil
        }
        self.id = id
        self.driverId = driverId
        self.passengerId = passengerId
        self.pickDescription = pickDescription
        self.dropDescription = dropDescription
        self.pickLocation = pickLocation
        self.dropLocation = dropLocation
        self.tripTimeStamp = tripTimeStamp
        self.dropLongitude = dropLongitude
        self.dropLatitude = dropLatitude
        self.pickLongitude = pickLongitude
        self.pickLatitude = pickLatitude
        self.tripStatus = tripStatus
        self.tripCharge = tripCharge
        self.driverTripCompleted = driverTripCompleted
        self.passengerTripCompleted = passengerTripCompleted
        self.vehicleType = dict["vehicleType"] as? String ?? ""
    }
    
    func toDict() -> [String: Any] {
        return [
            "driverId": driverId,
            "passengerId": passengerId,
            "pickDescription": pickDescription,
            "dropDescription": dropDescription,
            "pickLocation": pickLocation,
            "dropLocation": dropLocation,
            "tripTimeStamp": tripTimeStamp,
            "dropLongitude": dropLongitude,
            "dropLatitude": dropLatitude,
            "pickLongitude": pickLongitude,
            "pickLatitude": pickLatitude,
            "tripStatus": tripStatus,
            "tripCharge": tripCharge,
            "vehicleType": vehicleType,
            "driverTripCompleted": driverTripCompleted,
            "passengerTripCompleted": passengerTripCompleted
        ]
    }
}
