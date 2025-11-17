//
//  PersistenceManager.swift
//  VentureVoyage
//
//  Type-safe persistence manager for UserDefaults
//  Provides centralized, safe access to persistent data
//

import Foundation

/// Type-safe persistence manager wrapping UserDefaults
@MainActor
final class PersistenceManager {
    static let shared = PersistenceManager()

    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        print("💾 PersistenceManager: Initialized")
    }

    // MARK: - Generic Storage

    /// Saves a codable object
    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
            print("💾 Persistence: Saved '\(key)'")
        } catch {
            print("❌ Persistence: Failed to save '\(key)' - \(error.localizedDescription)")
        }
    }

    /// Retrieves a codable object
    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("❌ Persistence: Failed to decode '\(key)' - \(error.localizedDescription)")
            return nil
        }
    }

    /// Removes value for key
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        print("💾 Persistence: Removed '\(key)'")
    }

    /// Checks if key exists
    func exists(forKey key: String) -> Bool {
        userDefaults.object(forKey: key) != nil
    }

    // MARK: - Primitive Types

    /// Saves a string
    func saveString(_ value: String, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    /// Gets a string
    func getString(forKey key: String) -> String? {
        userDefaults.string(forKey: key)
    }

    /// Saves a bool
    func saveBool(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    /// Gets a bool
    func getBool(forKey key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    /// Saves an int
    func saveInt(_ value: Int, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    /// Gets an int
    func getInt(forKey key: String) -> Int {
        userDefaults.integer(forKey: key)
    }

    /// Saves a double
    func saveDouble(_ value: Double, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    /// Gets a double
    func getDouble(forKey key: String) -> Double {
        userDefaults.double(forKey: key)
    }

    // MARK: - App-Specific Methods

    /// Onboarding completion status
    var hasCompletedOnboarding: Bool {
        get { getBool(forKey: UserDefaultsKeys.hasCompletedOnboarding) }
        set { saveBool(newValue, forKey: UserDefaultsKeys.hasCompletedOnboarding) }
    }

    /// Business ideas
    var businessIdeas: [BusinessIdea] {
        get { get(forKey: UserDefaultsKeys.businessIdeasData) ?? [] }
        set { save(newValue, forKey: UserDefaultsKeys.businessIdeasData) }
    }

    /// Selected business idea ID
    var selectedBusinessIdeaID: String? {
        get { getString(forKey: UserDefaultsKeys.selectedBusinessIdeaID) }
        set {
            if let newValue = newValue {
                saveString(newValue, forKey: UserDefaultsKeys.selectedBusinessIdeaID)
            } else {
                remove(forKey: UserDefaultsKeys.selectedBusinessIdeaID)
            }
        }
    }

    /// User profile
    var userProfile: UserProfile? {
        get { get(forKey: UserDefaultsKeys.userProfileData) }
        set {
            if let newValue = newValue {
                save(newValue, forKey: UserDefaultsKeys.userProfileData)
            } else {
                remove(forKey: UserDefaultsKeys.userProfileData)
            }
        }
    }

    /// Google AI API Key (runtime override)
    var googleAIAPIKey: String? {
        get { getString(forKey: UserDefaultsKeys.googleAIAPIKey) }
        set {
            if let newValue = newValue {
                saveString(newValue, forKey: UserDefaultsKeys.googleAIAPIKey)
            } else {
                remove(forKey: UserDefaultsKeys.googleAIAPIKey)
            }
        }
    }

    /// Google AI Model (runtime override)
    var googleAIModel: String? {
        get { getString(forKey: UserDefaultsKeys.googleAIModel) }
        set {
            if let newValue = newValue {
                saveString(newValue, forKey: UserDefaultsKeys.googleAIModel)
            } else {
                remove(forKey: UserDefaultsKeys.googleAIModel)
            }
        }
    }

    // MARK: - Utility Methods

    /// Clears all app data (for logout or reset)
    func clearAll() {
        let keys = [
            UserDefaultsKeys.hasCompletedOnboarding,
            UserDefaultsKeys.businessIdeasData,
            UserDefaultsKeys.userProfileData,
            UserDefaultsKeys.selectedBusinessIdeaID,
            UserDefaultsKeys.savedIslands,
            UserDefaultsKeys.journeyProgress,
            UserDefaultsKeys.progressNotes,
            UserDefaultsKeys.appReminders
        ]

        for key in keys {
            remove(forKey: key)
        }

        print("💾 Persistence: Cleared all app data")
    }

    /// Synchronizes UserDefaults
    func synchronize() {
        userDefaults.synchronize()
        print("💾 Persistence: Synchronized UserDefaults")
    }

    /// Exports all data for debugging
    func exportAllData() -> [String: Any] {
        userDefaults.dictionaryRepresentation()
    }
}

// MARK: - Property Wrapper

/// Property wrapper for UserDefaults storage
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/// Property wrapper for Codable UserDefaults storage
@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let value = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
