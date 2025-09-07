//
//  BiometricAuth.swift
//  GOGO
//
//  Created by Snippets on 9/5/25.
//  

import Foundation
import LocalAuthentication

enum BiometricAuthResult {
    case success
    case cancel
    case fallback  // user chose passcode or fallback
    case unavailable(String) // device/biometry unavailable
    case failed(String)      // generic failure
}

final class BiometricAuth {
    static let shared = BiometricAuth()

    /// Checks if biometrics are available and returns the biometry type.
    func availability() -> (available: Bool, type: LABiometryType) {
        let ctx = LAContext()
        var error: NSError?
        let ok = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return (ok, ctx.biometryType)
    }

    /// Prompts Face ID/Touch ID. Set `allowPasscode` = true to let iOS show passcode fallback.
    func authenticate(reason: String = "Authenticate to continue",
                      allowPasscode: Bool = true,
                      completion: @escaping (BiometricAuthResult) -> Void) {
        let ctx = LAContext()
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        if allowPasscode {
            policy = .deviceOwnerAuthentication // biometrics + passcode fallback
        }

        var err: NSError?
        guard ctx.canEvaluatePolicy(policy, error: &err) else {
            completion(.unavailable(err?.localizedDescription ?? "Biometrics not available"))
            return
        }

        ctx.evaluatePolicy(policy, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success { completion(.success); return }
                guard let laError = error as? LAError else {
                    completion(.failed(error?.localizedDescription ?? "Unknown error"))
                    return
                }
                switch laError.code {
                case .userCancel, .systemCancel: completion(.cancel)
                case .userFallback:              completion(.fallback)
                case .biometryLockout:           completion(.failed("Biometrics locked. Use passcode in Settings."))
                case .biometryNotAvailable:      completion(.unavailable("Biometrics not available on this device."))
                case .biometryNotEnrolled:       completion(.unavailable("No Face ID enrolled."))
                default:                         completion(.failed(laError.localizedDescription))
                }
            }
        }
    }
}
