//
//  LockGateViewModel.swift
//  GOGO
//
//  Created by Snippets on 9/5/25.
//  

import Foundation

class LockViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var message: String?

    func unlock() {
        BiometricAuth.shared.authenticate(reason: "Unlock GoGo") { [weak self] result in
            switch result {
            case .success:
                self?.isUnlocked = true
            case .fallback:
                self?.message = "Used passcode."
                self?.isUnlocked = true
            case .cancel:
                self?.message = "Authentication cancelled."
            case .unavailable(let why):
                self?.message = why
            case .failed(let why):
                self?.message = why
            }
        }
    }
}
