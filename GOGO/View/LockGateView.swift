//
//  LockGateView.swift
//  GOGO
//
//  Created by Snippets on 9/5/25.
//

import Foundation
import SwiftUI

struct LockGateView: View {
    @StateObject private var vm = LockViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    Image(systemName: "faceid")
                        .font(.system(size: 48))
                    Text("Face ID required")
                        .font(.headline)
                    if let msg = vm.message {
                        Text(msg)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Button("Authenticate") { vm.unlock() }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                .onAppear { vm.unlock() }
            }
            .navigationDestination(isPresented: $vm.isUnlocked) {
                if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_DRIVER)) {
                    if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.DRIVER_TRIP_STARTED)) {
                        DriverMapView(tripId: UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.DRIVER_TRIP_ID))
                    } else {
                        DriverHomeView()
                    }
                } else {
                    if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.PASSENGER_TRIP_STARTED)) {
                        PassengerMapView(tripId: UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.PASSENGER_TRIP_ID))
                    } else {
                        PassengerHomeView()
                    }
                }
            }
        }
    }
}
