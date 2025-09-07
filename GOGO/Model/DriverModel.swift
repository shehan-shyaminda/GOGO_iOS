//
//  DriverModel.swift
//  GOGO
//
//  Created by Snippets on 9/2/25.
//

import Foundation

struct DriverModel {
    let id: String
    let driverLicense: String?
    let vehicleInfo: VehicleInfo?
    let bankInfo: DriverBankInfo?
    
    init(id: String,
         driverLicense: String? = nil,
         vehicleInfo: VehicleInfo? = nil,
         bankInfo: DriverBankInfo? = nil) {
        self.id = id
        self.driverLicense = driverLicense
        self.vehicleInfo = vehicleInfo
        self.bankInfo = bankInfo
    }
    
    init?(id: String, dict: [String: Any]) {
        self.id = id
        self.driverLicense = dict["driverLicense"] as? String
        
        if let vehicleDict = dict["vehicle_info"] as? [String: Any] {
            self.vehicleInfo = VehicleInfo(dict: vehicleDict)
        } else {
            self.vehicleInfo = nil
        }
        
        if let bankDict = dict["bank_info"] as? [String: Any] {
            self.bankInfo = DriverBankInfo(dict: bankDict)
        } else {
            self.bankInfo = nil
        }
    }
}

struct VehicleInfo {
    let vehicleType: String?
    let vehicleBrand: String?
    let vehicleModel: String?
    let vehicleRegNum: String?
    let vehicleYear: String?
    let vehicleSeats: String?
    let revenueLicense: String?
    let vehicleImage: String?
    let vehicleEngine: String?
    
    init(vehicleType: String? = nil,
          vehicleBrand: String? = nil,
          vehicleModel: String? = nil,
          vehicleRegNum: String? = nil,
          vehicleYear: String? = nil,
          vehicleSeats: String? = nil,
          revenueLicense: String? = nil,
          vehicleImage: String? = nil,
          vehicleEngine: String? = nil) {
        self.vehicleType = vehicleType
        self.vehicleBrand = vehicleBrand
        self.vehicleModel = vehicleModel
        self.vehicleRegNum = vehicleRegNum
        self.vehicleYear = vehicleYear
        self.vehicleSeats = vehicleSeats
        self.revenueLicense = revenueLicense
        self.vehicleImage = vehicleImage
        self.vehicleEngine = vehicleEngine
    }
    
    init?(dict: [String: Any]) {
        self.vehicleType = dict["vehicleType"] as? String
        self.vehicleBrand = dict["vehicleBrand"] as? String
        self.vehicleModel = dict["vehicleModel"] as? String
        self.vehicleRegNum = dict["vehicleRegNum"] as? String
        self.vehicleYear = dict["vehicleYear"] as? String
        self.vehicleSeats = dict["vehicleSeats"] as? String
        self.revenueLicense = dict["revenueLicense"] as? String
        self.vehicleImage = dict["vehicleImage"] as? String
        self.vehicleEngine = dict["vehicleEngine"] as? String
    }
    
    func toDict() -> [String: Any] {
        return [
            "vehicleType": vehicleType!,
            "vehicleBrand": vehicleBrand!,
            "vehicleModel": vehicleModel!,
            "vehicleRegNum": vehicleRegNum!,
            "vehicleYear": vehicleYear!,
            "vehicleSeats": vehicleSeats!,
            "vehicleEngine": vehicleEngine!,
        ]
    }
}

struct DriverBankInfo {
    let driverName: String?
    let driverBankName: String?
    let driverBankBranch: String?
    let driverBankAccount: String?
    
    init(driverName: String? = nil,
         driverBankName: String? = nil,
         driverBankBranch: String? = nil,
         driverBankAccount: String? = nil) {
        self.driverName = driverName
        self.driverBankName = driverBankName
        self.driverBankBranch = driverBankBranch
        self.driverBankAccount = driverBankAccount
    }
    
    init?(dict: [String: Any]) {
        self.driverName = dict["driverName"] as? String
        self.driverBankName = dict["driverBankName"] as? String
        self.driverBankBranch = dict["driverBankBranch"] as? String
        self.driverBankAccount = dict["driverBankAccount"] as? String
    }
    
    func toDict() -> [String: Any] {
        return [
            "driverName": driverName!,
            "driverBankAccount": driverBankAccount!,
            "driverBankName": driverBankName!,
            "driverBankBranch": driverBankBranch!
        ]
    }
}
