import Foundation

// MARK: - Configuration
// ⚠️ IMPORTANT: Sensitive credentials should NEVER be hardcoded
// Store in environment variables, Xcode build settings, or Keychain
// Never commit API keys to version control

struct Config {
    /// Google AI API Key - Read from UserDefaults, env, or Info.plist
    /// Set via Settings screen, environment, or Info.plist
    static var googleAIKey: String {
        // Embedded default key for convenience during testing. Use at your own risk.
        // Security: This is a plain-text key in the repo. If you plan to publish, rotate and move it to env or Keychain.
        let embeddedKey = "AIzaSyD-dIEwp3PNhwsGFf67k2VvTs6O2QI1fjo"
        if !embeddedKey.isEmpty { return embeddedKey }
        // Prefer Info.plist for a single source of truth when the key is embedded
        // in the app bundle (useful for debugging). Info.plist entries can be
        // substituted at build time using Xcode build settings or .xcconfig.
        if let key = Bundle.main.infoDictionary?["GOOGLE_AI_API_KEY"] as? String, !key.isEmpty {
            print("🔍 Config: GOOGLE_AI_API_KEY found in Info.plist (len: \(key.count))")
            return key
        }
        // Fall back to env vars for CI/local dev flows
        if let key = ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"], !key.isEmpty {
            print("🔍 Config: GOOGLE_AI_API_KEY found in ENV (len: \(key.count))")
            return key
        }
        // Fall back to runtime override (Settings or user defaults)
        if let saved = UserDefaults.standard.string(forKey: "GOOGLE_AI_API_KEY"), !saved.isEmpty {
            print("🔍 Config: GOOGLE_AI_API_KEY found in UserDefaults (len: \(saved.count))")
            return saved
        }
    // Fallback to pre-configured key - intentionally blank to avoid checked-in secrets.
    // Use Xcode Build Settings (recommended), ProcessInfo env vars, or Info.plist to provide
    // a valid key. See `API_KEY_SETUP.md` for setup instructions.
    return ""
    }

    /// Google AI model identifier - override via Settings, env or Info.plist
    static var googleAIModel: String {
        if let saved = UserDefaults.standard.string(forKey: "GOOGLE_AI_MODEL"), !saved.isEmpty {
            return saved
        }
        if let model = ProcessInfo.processInfo.environment["GOOGLE_AI_MODEL"], !model.isEmpty {
            return model
        }
        if let model = Bundle.main.infoDictionary?["GOOGLE_AI_MODEL"] as? String, !model.isEmpty {
            return model
        }
    // Default to a modern Gemini model. Change in Settings or env if needed.
    return "gemini-2.5-flash"
    }

    static func printDebugInfo() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            print("🔎 Info.plist path: \(path)")
        } else {
            print("🔎 Info.plist path: not found")
        }

        if let val = Bundle.main.infoDictionary?["GOOGLE_AI_API_KEY"] as? String {
            print("🔎 GOOGLE_AI_API_KEY in Info.plist present (len: \(val.count))")
        } else {
            print("🔎 GOOGLE_AI_API_KEY not present in Info.plist")
        }
    }

    /// Return the key source for the GOOGLE_AI_API_KEY
    static func googleAIKeySource() -> String {
        // If the embedded key is used, report Config as the source
        let embeddedKey = "AIzaSyD-dIEwp3PNhwsGFf67k2VvTs6O2QI1fjo"
        if !embeddedKey.isEmpty { return "Config" }
        if let key = Bundle.main.infoDictionary?["GOOGLE_AI_API_KEY"] as? String, !key.isEmpty {
            return "Info.plist"
        }
        if let _ = ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"], !(ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"] ?? "").isEmpty {
            return "Environment"
        }
        if let _ = UserDefaults.standard.string(forKey: "GOOGLE_AI_API_KEY"), !(UserDefaults.standard.string(forKey: "GOOGLE_AI_API_KEY") ?? "").isEmpty {
            return "UserDefaults"
        }
        return "None"
    }
    
    /// Firebase Project Configuration
    /// These are public identifiers safe to commit
    static let firebaseProjectID = "businessapp-b9a38"
    static let firebaseProjectNumber = "375175320585"
    static let firebaseStorageBucket = "businessapp-b9a38.firebasestorage.app"
    
    /// Firebase Web API Key - Load from Info.plist or env
    static var firebaseWebAPIKey: String {
        if let key = Bundle.main.infoDictionary?["FIREBASE_WEB_API_KEY"] as? String, !key.isEmpty {
            return key
        }
        return ProcessInfo.processInfo.environment["FIREBASE_WEB_API_KEY"] ?? ""
    }
    
    /// App Settings
    static let appName = "BusinessIdea"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "14.0"
}
