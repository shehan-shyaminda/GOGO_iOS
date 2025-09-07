//
//  PassengerInfoViewModel.swift
//  GOGO
//
//  Created by Snippets on 9/2/25.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class PassengerInfoViewModel: NSObject, ObservableObject {
    @Published var passengerInfo: PassengerModel?
    @Published var bankName: String = ""
    @Published var branchName: String = ""
    @Published var accountNumber: String = ""
    @Published var accountName: String = ""
    
    override init() {
        super.init()
        self.fetchPassengerDetails()
    }
    
    func fetchPassengerDetails() {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        ref.child("passenger_info").child(userId).observeSingleEvent(of: .value) { snapshot, err in
            if let dict = snapshot.value as? [String: Any],
               let passenger = PassengerModel(id: userId, dict: dict) {
                withAnimation {
                    print("✅ Fetched passenger details for id \(userId):", passenger)
                    self.passengerInfo = passenger
                }
            } else {
                print("❌ Failed to fetch or parse passenger details for id \(userId)")
            }
        }
    }
    
    func removePassengerBank(bankId: String) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        ref.child("passenger_info").child(userId).child("passengerBanks").child(bankId)
            .removeValue { error, _ in
                if let error = error {
                    print("❌ Failed to remove bank: \(error.localizedDescription)")
                } else {
                    self.fetchPassengerDetails()
                    print("✅ Bank removed successfully")
                }
            }
    }
    
    func validateValue() -> Bool {
        if (!bankName.isEmpty && !branchName.isEmpty && !accountName.isEmpty && !accountNumber.isEmpty) {
            return true
        }
        return false
    }
    
    func addNewPassengerBank(bank: [String: Any], completion: @escaping (Bool) -> Void) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("passenger_info").child(userId).child("passengerBanks").childByAutoId()
        ref.setValue(bank) { error, _ in
            if let error = error {
                print("❌ Failed to add bank: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Bank added successfully")
                self.fetchPassengerDetails()
                self.clearBankInputFields()
                completion(true)
            }
        }
    }
    
    func clearBankInputFields() {
        self.bankName = ""
        self.branchName = ""
        self.accountNumber = ""
        self.accountName = ""
    }
}
