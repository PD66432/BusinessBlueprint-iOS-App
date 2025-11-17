//
//  CacheManager.swift
//  VentureVoyage
//
//  Smart caching layer for app data
//  Provides memory and disk caching with expiration support
//

import Foundation

/// Thread-safe cache manager with memory and disk caching
actor CacheManager {
    static let shared = CacheManager()

    // MARK: - Properties

    private var memoryCache: [String: CachedItem] = [:]
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    /// Cache expiration policy
    enum ExpirationPolicy {
        case never
        case seconds(TimeInterval)
        case minutes(Int)
        case hours(Int)
        case days(Int)

        var timeInterval: TimeInterval? {
            switch self {
            case .never:
                return nil
            case .seconds(let seconds):
                return seconds
            case .minutes(let minutes):
                return TimeInterval(minutes * 60)
            case .hours(let hours):
                return TimeInterval(hours * 3600)
            case .days(let days):
                return TimeInterval(days * 86400)
            }
        }
    }

    // MARK: - Initialization

    private init() {
        // Setup cache directory
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("VentureVoyageCache", isDirectory: true)

        // Create cache directory if needed
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)

        print("💾 CacheManager: Initialized with directory: \(cacheDirectory.path)")
    }

    // MARK: - Memory Cache

    /// Stores an item in memory cache
    func setMemory<T: Codable>(
        _ value: T,
        forKey key: String,
        expiration: ExpirationPolicy = .hours(1)
    ) {
        let item = CachedItem(
            value: value,
            expirationDate: calculateExpirationDate(from: expiration)
        )

        memoryCache[key] = item
        print("💾 Cache: Stored '\(key)' in memory")
    }

    /// Retrieves an item from memory cache
    func getMemory<T: Codable>(forKey key: String) -> T? {
        guard let item = memoryCache[key] else {
            return nil
        }

        // Check if expired
        if let expirationDate = item.expirationDate,
           expirationDate < Date() {
            memoryCache.removeValue(forKey: key)
            print("💾 Cache: '\(key)' expired and removed from memory")
            return nil
        }

        return item.value as? T
    }

    /// Removes item from memory cache
    func removeMemory(forKey key: String) {
        memoryCache.removeValue(forKey: key)
        print("💾 Cache: Removed '\(key)' from memory")
    }

    /// Clears all memory cache
    func clearMemory() {
        memoryCache.removeAll()
        print("💾 Cache: Cleared all memory cache")
    }

    // MARK: - Disk Cache

    /// Stores an item on disk
    func setDisk<T: Codable>(
        _ value: T,
        forKey key: String,
        expiration: ExpirationPolicy = .days(7)
    ) async throws {
        let item = CachedItem(
            value: value,
            expirationDate: calculateExpirationDate(from: expiration)
        )

        let fileURL = cacheFileURL(for: key)
        let data = try JSONEncoder().encode(item)

        try data.write(to: fileURL)
        print("💾 Cache: Stored '\(key)' on disk")
    }

    /// Retrieves an item from disk
    func getDisk<T: Codable>(forKey key: String) async -> T? {
        let fileURL = cacheFileURL(for: key)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let item = try JSONDecoder().decode(CachedItem.self, from: data)

            // Check if expired
            if let expirationDate = item.expirationDate,
               expirationDate < Date() {
                try? fileManager.removeItem(at: fileURL)
                print("💾 Cache: '\(key)' expired and removed from disk")
                return nil
            }

            return item.value as? T
        } catch {
            print("❌ Cache: Failed to read '\(key)' from disk - \(error.localizedDescription)")
            return nil
        }
    }

    /// Removes item from disk
    func removeDisk(forKey key: String) async throws {
        let fileURL = cacheFileURL(for: key)
        try fileManager.removeItem(at: fileURL)
        print("💾 Cache: Removed '\(key)' from disk")
    }

    /// Clears all disk cache
    func clearDisk() async throws {
        let contents = try fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: nil
        )

        for fileURL in contents {
            try fileManager.removeItem(at: fileURL)
        }

        print("💾 Cache: Cleared all disk cache")
    }

    // MARK: - Combined Cache Operations

    /// Stores item in both memory and disk
    func set<T: Codable>(
        _ value: T,
        forKey key: String,
        memoryExpiration: ExpirationPolicy = .hours(1),
        diskExpiration: ExpirationPolicy = .days(7)
    ) async throws {
        // Memory cache
        setMemory(value, forKey: key, expiration: memoryExpiration)

        // Disk cache
        try await setDisk(value, forKey: key, expiration: diskExpiration)
    }

    /// Retrieves item from memory first, then disk
    func get<T: Codable>(forKey key: String) async -> T? {
        // Try memory first
        if let value: T = getMemory(forKey: key) {
            print("💾 Cache: Hit '\(key)' in memory")
            return value
        }

        // Try disk
        if let value: T = await getDisk(forKey: key) {
            print("💾 Cache: Hit '\(key)' on disk, promoting to memory")
            // Promote to memory
            setMemory(value, forKey: key)
            return value
        }

        print("💾 Cache: Miss '\(key)'")
        return nil
    }

    /// Removes item from both memory and disk
    func remove(forKey key: String) async throws {
        removeMemory(forKey: key)
        try await removeDisk(forKey: key)
    }

    /// Clears all cache (memory and disk)
    func clearAll() async throws {
        clearMemory()
        try await clearDisk()
    }

    // MARK: - Helper Methods

    private func calculateExpirationDate(from policy: ExpirationPolicy) -> Date? {
        guard let interval = policy.timeInterval else {
            return nil
        }
        return Date().addingTimeInterval(interval)
    }

    private func cacheFileURL(for key: String) -> URL {
        let filename = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return cacheDirectory.appendingPathComponent(filename)
    }

    // MARK: - Cache Statistics

    /// Returns cache statistics
    func statistics() async -> CacheStatistics {
        let memoryCacheSize = memoryCache.count
        let diskCacheSize = (try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil).count) ?? 0

        return CacheStatistics(
            memoryItems: memoryCacheSize,
            diskItems: diskCacheSize
        )
    }
}

// MARK: - Supporting Types

/// Cached item with expiration
private struct CachedItem: Codable {
    let value: Any
    let expirationDate: Date?

    enum CodingKeys: String, CodingKey {
        case value
        case expirationDate
    }

    init(value: Any, expirationDate: Date?) {
        self.value = value
        self.expirationDate = expirationDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)

        // Try to decode as different types
        if let stringValue = try? container.decode(String.self, forKey: .value) {
            self.value = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .value) {
            self.value = intValue
        } else if let boolValue = try? container.decode(Bool.self, forKey: .value) {
            self.value = boolValue
        } else if let dataValue = try? container.decode(Data.self, forKey: .value) {
            self.value = dataValue
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .value,
                in: container,
                debugDescription: "Unable to decode value"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(expirationDate, forKey: .expirationDate)

        if let stringValue = value as? String {
            try container.encode(stringValue, forKey: .value)
        } else if let intValue = value as? Int {
            try container.encode(intValue, forKey: .value)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue, forKey: .value)
        } else if let dataValue = value as? Data {
            try container.encode(dataValue, forKey: .value)
        } else if let codableValue = value as? Encodable {
            try container.encode(AnyCodable(codableValue), forKey: .value)
        }
    }
}

/// Type-erased codable wrapper
private struct AnyCodable: Codable {
    let value: Encodable

    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }

    init(from decoder: Decoder) throws {
        fatalError("AnyCodable decoding not supported")
    }
}

/// Cache statistics
struct CacheStatistics {
    let memoryItems: Int
    let diskItems: Int

    var totalItems: Int {
        memoryItems + diskItems
    }
}

// MARK: - Convenience Extensions

extension CacheManager {
    /// Cache keys for common data
    enum CacheKey {
        static let businessIdeas = "business_ideas"
        static let userProfile = "user_profile"
        static let dailyGoals = "daily_goals"
        static let milestones = "milestones"
        static let aiResponses = "ai_responses"

        static func aiResponse(for prompt: String) -> String {
            "ai_response_\(prompt.hash)"
        }

        static func businessIdea(id: String) -> String {
            "business_idea_\(id)"
        }
    }
}
