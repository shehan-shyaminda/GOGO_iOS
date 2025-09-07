//
//  GOGOApp.swift
//  GOGO
//
//  Created by Snippets on 10/29/24.
//

import SwiftUI
import FirebaseCore
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      IQKeyboardManager.shared.isEnabled = true
      IQKeyboardManager.shared.resignOnTouchOutside = true
    return true
  }
}

@main
struct GOGOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_LOGGEDIN)) {
                    if (UserDefaultsManager.shared.getBool(forKey: UserDefaultsManager.IS_FACEID_CHECK)) {
                        LockGateView()
                    } else {
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
                } else {
                    LoginView()
                }
            }
            .onOpenURL { url in
                if url.absoluteString == "gogoapp://open" {
                    print("Widget tapped")
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}
