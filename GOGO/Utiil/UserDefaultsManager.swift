//
//  UserDefaultsManager.swift
//  GOGO
//
//  Created by Snippets on 11/14/24.
//  

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    static let IS_LOGGEDIN = "IS_LOGGEDIN"
    static let IS_DRIVER = "IS_DRIVER"
    static let IS_FACEID_CHECK = "IS_FACEID_CHECK"
    static let USER_ID = "USER_ID"
    static let USER_EMAIL = "USER_EMAIL"
    static let ACCESS_TOKEN = "ACCESS_TOKEN"
    static let PASSENGER_TRIP_STARTED = "PASSENGER_TRIP_STARTED"
    static let PASSENGER_TRIP_ID = "PASSENGER_TRIP_ID"
    static let DRIVER_TRIP_STARTED = "DRIVER_TRIP_STARTED"
    static let DRIVER_TRIP_ID = "DRIVER_TRIP_ID"

    func setString(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getString(forKey key: String) -> String {
        return UserDefaults.standard.value(forKey: key) as! String
    }
    
    func setBool(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getBool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    func setInt(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getInt(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    func removeValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func clearAllUserDefaults() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
