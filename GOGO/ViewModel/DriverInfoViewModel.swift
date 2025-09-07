//
//  DriverInfoViewModel.swift
//  GOGO
//
//  Created by Snippets on 9/2/25.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import SwiftUI

class DriverInfoViewModel: NSObject, ObservableObject {
    @Published var driverInfo: DriverModel?
    
    @Published var bankName: String = ""
    @Published var branchName: String = ""
    @Published var accountNumber: String = ""
    @Published var accountName: String = ""
    
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var yom: String = ""
    @Published var regNum: String = ""
    @Published var seatCount: String = ""
    @Published var enginePower: String = ""
    @Published var selectedOption: String = "tuk"
    @Published var typeOptions = ["tuk", "car", "van"]
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var uploadedUrl: String? = nil
    
    override init() {
        super.init()
        self.fetchDriverDetails()
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
    
    func updateFirebaseImages(from item: PhotosPickerItem, isRevenueLicense: Bool, isVehicleImage: Bool) {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.selectedImage = uiImage
                            self.uploadImageToFirebase(uiImage, isRevenueLicense: isRevenueLicense, isVehicleImage: isVehicleImage)
                        }
                    }
                case .failure(let error):
                    print("❌ Failed to load image: \(error.localizedDescription)")
                }
            }
        }
        
    func uploadImageToFirebase(_ image: UIImage, isRevenueLicense: Bool, isVehicleImage: Bool) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let fileName = UUID().uuidString + ".jpg"
        var ref = Storage.storage().reference()
        if isVehicleImage {
            ref = ref.child("vehicle_image/\(fileName)")
        } else if isRevenueLicense {
            ref = ref.child("vehicle_revenue_licenses/\(fileName)")
        } else {
            ref = ref.child("driver_licenses/\(fileName)")
        }
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("❌ Could not get URL: \(error.localizedDescription)")
                    return
                }
                
                if let url = url?.absoluteString {
                    print("✅ Uploaded URL: \(url)")
                    if isRevenueLicense {
                        self.notifyRevenueLicense(imageUrl: url)
                    } else if isVehicleImage {
                        self.notifyVehicleImage(imageUrl: url)
                    } else {
                        self.notifyDriverLicense(imageUrl: url)
                    }
                }
            }
        }
    }
    
    func notifyRevenueLicense(imageUrl: String) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("driver_info").child(userId).child("vehicle_info").updateChildValues(["revenueLicense": imageUrl]) { error, _ in
            if let error = error {
                print("❌ Failed to add update: \(error.localizedDescription)")
            } else {
                print("✅ Updated successfully")
                self.fetchDriverDetails()
            }
        }
    }
    
    func notifyDriverLicense(imageUrl: String) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("driver_info").child(userId).updateChildValues(["driverLicense": imageUrl]) { error, _ in
            if let error = error {
                print("❌ Failed to add update: \(error.localizedDescription)")
            } else {
                print("✅ Updated successfully")
                self.fetchDriverDetails()
            }
        }
    }
    
    func notifyVehicleImage(imageUrl: String) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        ref.child("driver_info").child(userId).child("vehicle_info").updateChildValues(["vehicleImage": imageUrl]) { error, _ in
            if let error = error {
                print("❌ Failed to add update: \(error.localizedDescription)")
            } else {
                print("✅ Updated successfully")
                self.fetchDriverDetails()
            }
        }
    }
    
    func validateBank() -> Bool {
        if (!bankName.isEmpty && !branchName.isEmpty && !accountName.isEmpty && !accountNumber.isEmpty) {
            return true
        }
        return false
    }
    
    func validateVehicle() -> Bool {
        if (!brand.isEmpty && !model.isEmpty && !yom.isEmpty && !regNum.isEmpty && !seatCount.isEmpty && !enginePower.isEmpty) {
            return true
        }
        return false
    }
    
    func addNewDriverBank(bank: [String: Any], completion: @escaping (Bool) -> Void) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("driver_info").child(userId).child("bank_info")
        ref.updateChildValues(bank) { error, _ in
            if let error = error {
                print("❌ Failed to add bank: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Bank added successfully")
                self.fetchDriverDetails()
                self.clearBankInputFields()
                completion(true)
            }
        }
    }
    
    func updateVehicle(vehicle: [String: Any], completion: @escaping (Bool) -> Void) {
        let userId = UserDefaultsManager.shared.getString(forKey: UserDefaultsManager.USER_ID)
        let ref = Database.database(url: "https://codelabs-service-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("driver_info").child(userId).child("vehicle_info")
        ref.updateChildValues(vehicle) { error, _ in
            if let error = error {
                print("❌ Failed to update: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Update successfully")
                self.fetchDriverDetails()
                self.clearVehicleInputFields()
                completion(true)
            }
        }
    }
    
    func clearBankInputFields() {
        self.bankName = ""
        self.branchName = ""
        self.accountName = ""
        self.accountNumber = ""
    }
    
    func clearVehicleInputFields() {
        self.brand = ""
        self.model = ""
        self.yom = ""
        self.regNum = ""
        self.seatCount = ""
        self.enginePower = ""
        self.selectedOption = "tuk"
    }
}
