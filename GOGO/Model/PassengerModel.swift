//
//  PassengerModel.swift
//  GOGO
//
//  Created by Snippets on 9/2/25.
//  

import Foundation

struct PassengerModel {
    let passengerId: String
    let passengerBanks: [PassengerBank]
    
    init(passengerId: String,
        passengerBanks: [PassengerBank]) {
        self.passengerId = passengerId
        self.passengerBanks = passengerBanks
    }
    
    init?(id: String, dict: [String: Any]) {
        var banks: [PassengerBank] = []
        
        if let bankDict = dict["passengerBanks"] as? [String: Any] {
            for (key, value) in bankDict {
                if let bankData = value as? [String: Any],
                   let bank = PassengerBank(id: key, dict: bankData) {
                    banks.append(bank)
                }
            }
        }
        
        self.passengerId = id
        self.passengerBanks = banks
    }
}

struct PassengerBank {
    let id: String
    let accountName: String
    let accountNumber: String
    let bankName: String
    let branchName: String
    
    init(accountName: String,
         accountNumber: String,
         bankName: String,
         branchName: String) {
        self.id = UUID().uuidString
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.branchName = branchName
    }
    
    init?(id: String, dict: [String: Any]) {
        guard let accountName  = dict["accountName"] as? String,
              let accountNumber = dict["accountNumber"] as? String,
              let bankName = dict["bankName"] as? String,
              let branchName = dict["branchName"] as? String else {
            return nil
        }
        
        self.id = id
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.branchName = branchName
    }
    
    
    func toDict() -> [String: Any] {
        return [
            "accountName": accountName,
            "accountNumber": accountNumber,
            "bankName": bankName,
            "branchName": branchName
        ]
    }
}
