import Foundation

final class CleverTapIdManager {
    
    private static let prefSuiteName   = "ct_prefs"
    private static let keyCTId         = "clevertap_id"
    private static let keyHasIdentity  = "has_real_identity"
    static let shared = CleverTapIdManager()
    private init() {}
    private var prefs: UserDefaults {
        return UserDefaults(suiteName: Self.prefSuiteName) ?? .standard
    }
    
    func getOrCreateId() -> String {
        if let ctId = prefs.string(forKey: Self.keyCTId) {
            return ctId
        }
        let ctId = generateId()
        prefs.set(ctId, forKey: Self.keyCTId)
        prefs.synchronize()  // mirrors .apply()
        return ctId
    }
    
    func saveId(_ id: String) {
        prefs.set(id, forKey: Self.keyCTId)
        prefs.set(true, forKey: Self.keyHasIdentity)
        prefs.synchronize()
    }
    
    func isFirstTimeSignup() -> Bool {
        return !prefs.bool(forKey: Self.keyHasIdentity)
    }
    func generateId() -> String {
        let raw     = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let trimmed = String(raw.prefix(20))
        return "\(trimmed)-sp"
    }
}
