//
//  DriverMapViewModel.swift
//  GOGO
//
//  Created by Snippets on 9/1/25.
//  

import Foundation

import CoreLocation
import MapKit
import SwiftUI
import FirebaseDatabase
import UIKit

class DriverMapViewModel: NSObject, ObservableObject {
    @Published var tripId: String = ""
    @Published var tripModel: TripModel?
    
    private var refHandle: DatabaseHandle?
    private var ref: DatabaseReference?

    init(tripId: String) {
        super.init()
        self.tripId = tripId
        self.observeTripFromFirebase(tripId: tripId)
    }
    
    func observeTripFromFirebase(tripId: String) {
        ref = Database.database(
            url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app"
        ).reference().child("ongoing_trips").child(tripId)

        refHandle = ref?.observe(.value, with: { snapshot in
            guard let dict = snapshot.value as? [String: Any],
                  let trip = TripModel(id: tripId, dict: dict) else {
                print("❌ Trip not found or parsing failed")
                return
            }

            DispatchQueue.main.async {
                print("✅ Trip updated:", trip)
                withAnimation{
                    self.tripModel = trip
                }
            }
        })
    }
    

    func openGoogleMapsNavigation() {
//        UserDefaultsManager.shared.setBool(false, forKey: UserDefaultsManager.IS_LOGGEDIN)
        guard let trip = tripModel else {
            print("❌ tripModel is nil")
            return
        }
        var latitude: Double
        var longitude: Double

        switch trip.tripStatus {
        case 1:
            latitude = trip.pickLatitude
            longitude = trip.pickLongitude
        case 2:
            latitude = trip.dropLatitude
            longitude = trip.dropLongitude
        default:
            print("❌ Unsupported trip status: \(trip.tripStatus)")
            return
        }

        if let url = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving&navigate=yes"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&travelmode=driving") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
        
    func getTripUpdate() -> [String: Any] {
        if (self.tripModel?.tripStatus == 1) {
            return ["tripStatus": 2]
        } else if (self.tripModel?.tripStatus == 2) {
            return ["tripStatus": 3]
        } else if (self.tripModel?.tripStatus == 3) {
            return ["tripStatus": 4]
        } else if (self.tripModel?.tripStatus == 5) {
            return ["tripStatus": 6]
        } else if (self.tripModel?.tripStatus == 6) {
            return ["driverTripCompleted": 1]
        } else {
            return [:]
        }
    }
    
    func updateTrip() {
        let ref = Database.database(
            url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app"
        ).reference().child("ongoing_trips").child(self.tripId)
        ref.updateChildValues(self.getTripUpdate()) { error, _ in
            if let error = error {
                print("❌ Error updating field: \(error.localizedDescription)")
            } else {
                print("✅ Field updated successfully")
            }
        }
    }
}
