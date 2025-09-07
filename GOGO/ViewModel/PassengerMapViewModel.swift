//
//  PassengerMapViewModel.swift
//  GOGO
//
//  Created by Snippets on 11/9/24.
//

import CoreLocation
import MapKit
import SwiftUI
import FirebaseDatabase
import UIKit

class PassengerMapViewModel: NSObject, ObservableObject {
    @Published var tripId: String = ""
    @Published var tripModel: TripModel?

    private var refHandle: DatabaseHandle?
    private var ref: DatabaseReference?

    init(tripId: String) {
        super.init()
        self.tripId = tripId
        self.observeTripFromFirebase(tripId: tripId)
    }

    deinit {
        if let handle = refHandle, let ref = ref {
            ref.removeObserver(withHandle: handle)
        }
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
        if let url = URL(string: "comgooglemaps://?daddr=\(self.tripModel!.dropLatitude),\(self.tripModel!.dropLongitude)&directionsmode=driving&navigate=yes"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(self.tripModel!.dropLatitude),\(self.tripModel!.dropLongitude)&travelmode=driving") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func getTripUpdate() -> [String: Any] {
        if (self.tripModel?.tripStatus == 4) {
            return ["tripStatus": 5]
        } else if (self.tripModel?.tripStatus == 6) {
            return ["passengerTripCompleted": 1]
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
