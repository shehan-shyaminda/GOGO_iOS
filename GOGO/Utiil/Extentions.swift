//
//  Extentions.swift
//  GOGO
//
//  Created by Snippets on 8/21/25.
//  

import SwiftUI
import Foundation

extension Date {
    var fullDateString: String {
        return Date.fullFormatter.string(from: self)
    }
    
    private static let fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    var dayWithSuffixAndMonth: String {
        let day = Calendar.current.component(.day, from: self)
        
        // Determine suffix
        let suffix: String
        switch day {
        case 11...13: suffix = "th"
        case let d where d % 10 == 1: suffix = "st"
        case let d where d % 10 == 2: suffix = "nd"
        case let d where d % 10 == 3: suffix = "rd"
        default: suffix = "th"
        }
        
        // Month
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM" // e.g., "Sep"
        monthFormatter.locale = Locale(identifier: "en_US_POSIX")
        let month = monthFormatter.string(from: self)
        
        return "\(day)\(suffix) \(month)"
    }
}

extension String {
    func maskedAccountNumber() -> String {
        guard self.count > 4 else { return self }
        
        let last4 = self.suffix(4)
        return "***** " + last4
    }
}
