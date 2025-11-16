import Foundation

// MARK: - Configuration
// ⚠️ IMPORTANT: Sensitive credentials should NEVER be hardcoded
// Store in environment variables, Xcode build settings, or Keychain
// Never commit API keys to version control

struct Config {
    /// Google AI API Key - Read from UserDefaults, env, or Info.plist
    /// Set via Settings screen, environment, or Info.plist
    static var googleAIKey: String {
        // Prefer Info.plist for a single source of truth when the key is embedded
        // in the app bundle (useful for debugging). Info.plist entries can be
        // substituted at build time using Xcode build settings or .xcconfig.
        if let key = Bundle.main.infoDictionary?["GOOGLE_AI_API_KEY"] as? String, !key.isEmpty {
            return key
        }
        // Fall back to env vars for CI/local dev flows
        if let key = ProcessInfo.processInfo.environment["GOOGLE_AI_API_KEY"], !key.isEmpty {
            return key
        }
        // Fall back to runtime override (Settings or user defaults)
        if let saved = UserDefaults.standard.string(forKey: "GOOGLE_AI_API_KEY"), !saved.isEmpty {
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
