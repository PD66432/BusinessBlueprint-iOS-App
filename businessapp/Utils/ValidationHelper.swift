//
//  ValidationHelper.swift
//  VentureVoyage
//
//  Input validation utilities for forms and user input
//  Provides consistent validation across the app
//

import Foundation

/// Validation result with error message
struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?

    static var valid: ValidationResult {
        ValidationResult(isValid: true, errorMessage: nil)
    }

    static func invalid(_ message: String) -> ValidationResult {
        ValidationResult(isValid: false, errorMessage: message)
    }
}

/// Centralized validation utilities
enum ValidationHelper {

    // MARK: - Email Validation

    /// Validates email format
    static func validateEmail(_ email: String) -> ValidationResult {
        // Trim whitespace
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if empty
        guard !trimmed.isEmpty else {
            return .invalid("Email is required")
        }

        // Check format using regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        guard emailPredicate.evaluate(with: trimmed) else {
            return .invalid("Please enter a valid email address")
        }

        // Check length
        guard trimmed.count <= 320 else {
            return .invalid("Email is too long")
        }

        return .valid
    }

    // MARK: - Password Validation

    /// Validates password strength
    static func validatePassword(_ password: String) -> ValidationResult {
        // Check if empty
        guard !password.isEmpty else {
            return .invalid("Password is required")
        }

        // Check minimum length
        guard password.count >= 6 else {
            return .invalid("Password must be at least 6 characters")
        }

        // Check maximum length
        guard password.count <= 128 else {
            return .invalid("Password is too long")
        }

        return .valid
    }

    /// Validates password strength with requirements
    static func validatePasswordStrength(_ password: String) -> ValidationResult {
        // Basic validation
        let basicValidation = validatePassword(password)
        guard basicValidation.isValid else {
            return basicValidation
        }

        // Check for at least one letter
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        guard hasLetter else {
            return .invalid("Password must contain at least one letter")
        }

        // Check for at least one number
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        guard hasNumber else {
            return .invalid("Password must contain at least one number")
        }

        return .valid
    }

    /// Validates password confirmation match
    static func validatePasswordMatch(_ password: String, confirmation: String) -> ValidationResult {
        guard password == confirmation else {
            return .invalid("Passwords do not match")
        }

        return .valid
    }

    // MARK: - Text Validation

    /// Validates text is not empty
    static func validateNotEmpty(_ text: String, fieldName: String = "Field") -> ValidationResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .invalid("\(fieldName) is required")
        }

        return .valid
    }

    /// Validates text length
    static func validateLength(
        _ text: String,
        min: Int? = nil,
        max: Int? = nil,
        fieldName: String = "Field"
    ) -> ValidationResult {
        let count = text.count

        if let min = min, count < min {
            return .invalid("\(fieldName) must be at least \(min) characters")
        }

        if let max = max, count > max {
            return .invalid("\(fieldName) must be at most \(max) characters")
        }

        return .valid
    }

    // MARK: - Name Validation

    /// Validates name (person, business, etc.)
    static func validateName(_ name: String, fieldName: String = "Name") -> ValidationResult {
        // Check if empty
        let emptyCheck = validateNotEmpty(name, fieldName: fieldName)
        guard emptyCheck.isValid else {
            return emptyCheck
        }

        // Check length (2-50 characters)
        let lengthCheck = validateLength(name, min: 2, max: 50, fieldName: fieldName)
        guard lengthCheck.isValid else {
            return lengthCheck
        }

        // Check for valid characters (letters, spaces, hyphens, apostrophes)
        let validCharacterSet = CharacterSet.letters
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "-'"))

        let nameCharacterSet = CharacterSet(charactersIn: name)

        guard validCharacterSet.isSuperset(of: nameCharacterSet) else {
            return .invalid("\(fieldName) contains invalid characters")
        }

        return .valid
    }

    // MARK: - URL Validation

    /// Validates URL format
    static func validateURL(_ urlString: String) -> ValidationResult {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .invalid("URL is required")
        }

        guard let url = URL(string: trimmed),
              url.scheme != nil,
              url.host != nil else {
            return .invalid("Please enter a valid URL")
        }

        return .valid
    }

    // MARK: - Phone Validation

    /// Validates phone number (basic)
    static func validatePhone(_ phone: String) -> ValidationResult {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .invalid("Phone number is required")
        }

        // Remove common formatting characters
        let digitsOnly = trimmed.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Check length (typically 10-15 digits)
        guard digitsOnly.count >= 10, digitsOnly.count <= 15 else {
            return .invalid("Please enter a valid phone number")
        }

        return .valid
    }

    // MARK: - Number Validation

    /// Validates number is within range
    static func validateNumber(
        _ value: Double,
        min: Double? = nil,
        max: Double? = nil,
        fieldName: String = "Value"
    ) -> ValidationResult {
        if let min = min, value < min {
            return .invalid("\(fieldName) must be at least \(min)")
        }

        if let max = max, value > max {
            return .invalid("\(fieldName) must be at most \(max)")
        }

        return .valid
    }

    /// Validates integer is within range
    static func validateInteger(
        _ value: Int,
        min: Int? = nil,
        max: Int? = nil,
        fieldName: String = "Value"
    ) -> ValidationResult {
        if let min = min, value < min {
            return .invalid("\(fieldName) must be at least \(min)")
        }

        if let max = max, value > max {
            return .invalid("\(fieldName) must be at most \(max)")
        }

        return .valid
    }

    // MARK: - Date Validation

    /// Validates date is in the future
    static func validateFutureDate(_ date: Date, fieldName: String = "Date") -> ValidationResult {
        guard date > Date() else {
            return .invalid("\(fieldName) must be in the future")
        }

        return .valid
    }

    /// Validates date is in the past
    static func validatePastDate(_ date: Date, fieldName: String = "Date") -> ValidationResult {
        guard date < Date() else {
            return .invalid("\(fieldName) must be in the past")
        }

        return .valid
    }

    // MARK: - Multiple Field Validation

    /// Validates multiple fields and returns first error
    static func validateAll(_ validations: [ValidationResult]) -> ValidationResult {
        for validation in validations {
            if !validation.isValid {
                return validation
            }
        }

        return .valid
    }
}

// MARK: - String Extensions

extension String {
    /// Validates email format
    var isValidEmail: Bool {
        ValidationHelper.validateEmail(self).isValid
    }

    /// Validates password format
    var isValidPassword: Bool {
        ValidationHelper.validatePassword(self).isValid
    }

    /// Validates URL format
    var isValidURL: Bool {
        ValidationHelper.validateURL(self).isValid
    }

    /// Checks if string is not empty (after trimming whitespace)
    var isNotEmpty: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
