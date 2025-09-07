//
//  DriverHomeViewModel.swift
//  GOGO
//
//  Created by Snippets on 8/31/25.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class DriverHomeViewModel: NSObject, ObservableObject {
    @Published var avialableTrips: [TripModel]?
    @Published var driverInfo: DriverModel?
    @Published var navigateToDiverMap: Bool = false
    
    private var refHandle: DatabaseHandle?
    private var ref: DatabaseReference?
    
    override init() {
        super.init()
        fetchDriverDetails()
        fetchAvailableTrips()
    }
    
    func fetchAvailableTrips() {
        ref = Database.database(
            url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app"
        ).reference().child("ongoing_trips")
        
        refHandle = ref?.observe(.value, with: { snapshot in
            var trips: [TripModel] = []
            
            if let dict = snapshot.value as? [String: Any] {
                for (key, value) in dict {
                    if let tripDict = value as? [String: Any],
                       let trip = TripModel(id: key, dict: tripDict) {
                        if ((trip.passengerId != UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID))
                            && (trip.tripStatus == 0)
                            && (trip.vehicleType == self.driverInfo?.vehicleInfo?.vehicleType)) {
                            trips.append(trip)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                print("✅ Trips updated:", trips)
                self.avialableTrips = trips
            }
        })
    }
    
    func updateTrip(tripId: String, status: Int) {
        let ref = Database.database(
            url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app"
        ).reference().child("ongoing_trips").child(tripId)
        ref.updateChildValues([
            "tripStatus": status,
            "driverId": UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        ]) { error, _ in
            if let error = error {
                print("❌ Error updating field: \(error.localizedDescription)")
            } else {
                if status == 1 {
                    UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.DRIVER_TRIP_STARTED)
                    UserDefaultsManager.shared.setString(tripId, forKey: UserDefaultsManager.DRIVER_TRIP_ID)
                    DispatchQueue.main.async {
                        self.navigateToDiverMap = true
                    }
                }
                print("✅ Field updated successfully")
            }
        }
    }
    
    func fetchDriverDetails() {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("driver_info").child(userId).observeSingleEvent(of: .value) { snapshot, err in
            if let dict = snapshot.value as? [String: Any],
               let driver = DriverModel(id: userId, dict: dict) {
                withAnimation {
                    print("✅ Fetched driver details for id \(userId):", driver)
                    self.driverInfo = driver
                }
            } else {
                print("❌ Failed to fetch or parse driver details for id \(userId)")
            }
        }
    }
}
