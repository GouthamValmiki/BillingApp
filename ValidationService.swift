//
//  ValidationService.swift
//  BillingApp
//
//  MVC — Model Layer: Validation Business Logic
//

import Foundation

struct ValidationService {
    
    // MARK: - Name Validation
    
    /// Filters a name string — removes numbers and special characters, keeps only letters and spaces
    static func filterName(_ value: String) -> String {
        let filtered = value.unicodeScalars.filter {
            CharacterSet.letters.contains($0) || CharacterSet.whitespaces.contains($0)
        }
        return String(filtered)
    }
    
    /// Validates a name — returns nil if valid, or an error message string
    static func validateName(_ value: String) -> String? {
        if value.isEmpty { return nil }
        
        // Check for numbers
        let regex = try! NSRegularExpression(pattern: "[0-9]", options: [])
        let matches = regex.matches(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count))
        if matches.count > 0 {
            return "⚠️ Name should not contain numbers"
        }
        
        // Check for special characters (allow only letters & spaces)
        let hasSpecialChars = value.unicodeScalars.filter {
            !CharacterSet.letters.contains($0) && !CharacterSet.whitespaces.contains($0)
        }.count > 0
        if hasSpecialChars {
            return "⚠️ Name should only contain letters"
        }
        
        return nil
    }
    
    // MARK: - Phone Validation
    
    /// Filters a phone string — removes non-digits, limits to 10 characters
    static func filterPhone(_ value: String) -> String {
        let filtered = value.unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        let result = String(filtered)
        return String(result.prefix(10))
    }
    
    /// Validates a phone number — returns nil if valid, or an error message string
    static func validatePhone(_ value: String) -> String? {
        if value.isEmpty { return nil }
        
        // Check for non-digits
        let hasNonDigits = value.unicodeScalars.filter { !CharacterSet.decimalDigits.contains($0) }.count > 0
        if hasNonDigits {
            return "⚠️ Phone number should only contain digits"
        } else if value.count < 10 {
            return "⚠️ Phone number must be exactly 10 digits (\(value.count)/10)"
        } else if value.count > 10 {
            return "⚠️ Phone number must be exactly 10 digits (too many)"
        }
        
        return nil
    }
    
    // MARK: - Form Validation
    
    /// Checks if the add-customer form is valid
    static func isCustomerFormValid(name: String, phone: String, nameError: String?, phoneError: String?) -> Bool {
        nameError == nil && phoneError == nil && !name.isEmpty && phone.count == 10
    }
}
