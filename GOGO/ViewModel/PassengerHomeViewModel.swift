//
//  PassengerHomeViewModel.swift
//  GOGO
//
//  Created by Snippets on 8/21/25.
//

import SwiftUI
import MapKit
import Combine
import CoreLocation
import MapKit
import FirebaseDatabase
import EventKit
import EventKitUI

class PassengerHomeViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []
    @Published var dropLocation: (name: String, description: String, coordinate: CLLocationCoordinate2D)?
    @Published var pickUpLocation: (name: String, description: String, coordinate: CLLocationCoordinate2D)?
    @Published var selectedVehichleType: String = "tuk"
    @Published var selectedDate = Date()
    @Published var tripDistance: Double = 0.0
    @Published var tripDuration: String? = ""
    @Published var tukKmPrice: Double? = 0.0
    @Published var carKmPrice: Double? = 0.0
    @Published var vanKmPrice: Double? = 0.0
    @Published var vehicles: [VehicleTypes] = []
    @Published var navigateToMapView: Bool = false
    
    func checkProceedWithBook() -> Bool {
        return dropLocation != nil && pickUpLocation != nil
    }
    
    private let completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func updateQuery(_ query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search error: \(error)")
        results = []
    }
    
    func mapItem(for completion: MKLocalSearchCompletion, completionHandler: @escaping (MKMapItem?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { response, error in
            completionHandler(response?.mapItems.first)
        }
    }
    
    func fetchGoogleDistance() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String else {
            return
        }
        
        let urlStr = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(pickUpLocation!.coordinate.latitude),\(pickUpLocation!.coordinate.longitude)&destinations=\(dropLocation!.coordinate.latitude),\(dropLocation!.coordinate.longitude)&mode=driving&key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.tripDistance = 0.0
                    self.tripDuration = nil
                }
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let rows = json["rows"] as? [[String: Any]],
               let elements = rows.first?["elements"] as? [[String: Any]],
               let distance = elements.first?["distance"] as? [String: Any],
               let duration = elements.first?["duration"] as? [String: Any],
               let durationVal = duration["text"] as? String,
               let distanceVal = distance["value"] as? Double {
                
                let km = distanceVal / 1000.0
                
                DispatchQueue.main.async {
                    self.tripDistance = km
                    self.tripDuration = durationVal
                    self.fetchPriceFromFirebase(tripDistance: km)
                }
            } else {
                DispatchQueue.main.async {
                    self.tripDistance = 0.0
                    self.tripDuration = nil
                }
            }
        }.resume()
    }
    
    func fetchPriceFromFirebase(tripDistance: Double) {
        print("Fetching prices for tripDistance:", tripDistance)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("vehicle_types").observeSingleEvent(of: .value) { snapshot, err in
            var fetchedVehicles: [VehicleTypes] = []
            
            if let dict = snapshot.value as? [String: Any] {
                for (key, value) in dict {
                    if let vehicleDict = value as? [String: Any],
                       var vehicle = VehicleTypes(id: key, dict: vehicleDict) {
                        vehicle.tripCharge = (tripDistance * vehicle.perKm) / 300
                        fetchedVehicles.append(vehicle)
                    }
                }
            }
            withAnimation {
                self.vehicles = fetchedVehicles
            }
        }
    }
    
    func makeTripBooking() {
        let trip = TripModel(
            id: UUID().uuidString,
            driverId: "",
            passengerId: UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID),
            pickDescription: pickUpLocation!.description,
            dropDescription: dropLocation!.description,
            pickLocation: pickUpLocation!.name,
            dropLocation: dropLocation!.name,
            tripTimeStamp: selectedDate.timeIntervalSince1970,
            dropLongitude: dropLocation!.coordinate.longitude,
            dropLatitude: dropLocation!.coordinate.latitude,
            pickLongitude: pickUpLocation!.coordinate.longitude,
            pickLatitude: pickUpLocation!.coordinate.latitude,
            tripStatus: 0,
            tripCharge: vehicles.first(where: { $0.id == selectedVehichleType })?.tripCharge ?? 0.0,
            vehicleType: selectedVehichleType,
            passengerTripCompleted: 0,
            driverTripCompleted: 0
        )
        
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("ongoing_trips").child(trip.id).setValue(trip.toDict()) { error, _ in
            if let error = error {
                print("❌ Error writing to Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Vehicle saved successfully")
                self.createCalendarEvent(
                    title: "Trip To \(self.dropLocation?.name ?? "Destination")",
                    startDate: self.selectedDate,
                    notes: "Pickup at \(self.pickUpLocation?.description ?? "Origin"), drop at \(self.dropLocation?.description ?? "Destination").",
                    location: self.pickUpLocation?.name ?? "Origin"
                )
                UserDefaultsManager.shared.setString(trip.id, forKey: UserDefaultsManager.PASSENGER_TRIP_ID)
                UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.PASSENGER_TRIP_STARTED)
                DispatchQueue.main.async {
                    self.navigateToMapView = true
                }
            }
        }
    }
    
    func createCalendarEvent(title: String,
                             startDate: Date,
                             notes: String? = nil,
                             location: String? = nil) {
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.notes = notes
                event.location = location
                
                var comps = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
                comps.hour = 23
                comps.minute = 59
                
                guard let endDate = Calendar.current.date(from: comps) else {
                    fatalError("Failed to create end date")
                }
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event saved ✅ with id: \(event.eventIdentifier ?? "none")")
                } catch {
                    print("Failed to save event: \(error.localizedDescription)")
                }
            } else {
                print("Calendar access denied ❌")
            }
        }
    }

}

extension MKLocalSearchCompletion: @retroactive Identifiable {
    public var id: String { title + subtitle }
}
