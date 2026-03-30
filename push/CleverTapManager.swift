import Foundation
import CleverTapSDK

final class CleverTapManager {
    
    static let shared = CleverTapManager()
    private init() {}
    var ctId: String?
    
    func initialize() {
        ctId = CleverTapIdManager.shared.getOrCreateId()
        CleverTap.sharedInstance(withCleverTapID: ctId!)
    }

    func getInstance() -> CleverTap? {
        return CleverTap.sharedInstance()
    }

    func onUserLogin(_ profile: [String: Any], clevertapID: String) {
        ctId = clevertapID
        CleverTapIdManager.shared.saveId(clevertapID)
        CleverTap.sharedInstance()?.onUserLogin(profile, withCleverTapID: clevertapID)
    }

    func onFirstSignup(_ profile: [String: Any], clevertapID: String) {
        ctId = clevertapID
        CleverTapIdManager.shared.saveId(clevertapID)
        CleverTap.sharedInstance()?.onUserLogin(profile)
    }
    
    func pushEvent(_ eventName: String, props: [String: Any]? = nil) {
        var finalProps = [String: Any]()
        if let props = props {
            finalProps.merge(props) { _, new in new }
        }
        if let id = ctId {
            finalProps["userID"] = id
        }
        if finalProps.isEmpty {
            CleverTap.sharedInstance()?.recordEvent(eventName)
        } else {
            CleverTap.sharedInstance()?.recordEvent(eventName, withProps: finalProps)
        }
    }
}
