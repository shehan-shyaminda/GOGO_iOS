//
//  LoginViewModel.swift
//  GOGO
//
//  Created by Snippets on 11/16/24.
//  

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @State var verificationID: String?
    var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var jumpToMain: Bool = false
    @Published var isRegCompleted: Bool = false
    
    @Published var logEmail: String = "User2@user.com"
    @Published var logPassword: String = "user"
    
    func validateSign() -> Bool {
        if self.logEmail.isEmpty {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return false
        }
        
        if self.logPassword.isEmpty {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return false
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: self.logEmail) {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return false
        }
        
        return true
    }
    
    func userLogin() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        if validateSign() {
            let bodyParams = [
                "username": logEmail,
                "userPassword": logPassword
            ]
            NetworkManager.shared.request("owner/login", method: .POST, body: bodyParams, response: UserModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    if response.status {
                        print("✅ Login Successful")
                        UserDefaultsManager.shared.setBool(true, forKey: UserDefaultsManager.IS_LOGGEDIN)
                        UserDefaultsManager.shared.setString(response.data?.user.userID ?? "", forKey: UserDefaultsManager.USER_ID)
                        UserDefaultsManager.shared.setString(response.data?.user.username ?? "", forKey: UserDefaultsManager.USER_EMAIL)
                        UserDefaultsManager.shared.setString("Bearer \(response.data?.accessToken ?? "")", forKey: UserDefaultsManager.ACCESS_TOKEN)
                        
                        DispatchQueue.main.async {
                            self.jumpToMain = true
                        }
                    } else {
                        self.isError = true
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                })
                .store(in: &cancellables)
        } else {
            self.isError = true
        }
    }
    
    func userRegister() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        if validateSign() {
            let bodyParams = [
                "username": logEmail,
                "userPassword": logPassword
            ]
            NetworkManager.shared.request("owner/register", method: .POST, body: bodyParams, response: UserRegisterModel.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                        print("Error: \(error)")
                    }
                }, receiveValue: { response in
                    if response.status {
                        print("✅ Register Successful")
                        
                        DispatchQueue.main.async {
                            self.isRegCompleted = true
                        }
                    } else {
                        self.isError = true
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                })
                .store(in: &cancellables)
        } else {
            self.isError = true
        }
    }
}
