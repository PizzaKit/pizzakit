import Foundation

public extension UserDefaults {

    /// Method for setting `Codable` entity to UserDefaults
    func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try? JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    /// Method for getting `Codable` entity from UserDefaults
    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }
        return try JSONDecoder().decode(objectType, from: result)
    }
}
