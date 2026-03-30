//
//  NotificationService.swift
//  NotificationService
//
//  Created by Karthik Iyer on 16/12/22.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK

class NotificationService: CTNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        
        let defaults = UserDefaults.init(suiteName: "group.clevertapTest")
        let userId = defaults?.value(forKey: "userIdentity")
        print("NSE userId: \(userId)")
        let profile: Dictionary<String, Any> = [
            "Identity": userId
        ]
        CleverTap.sharedInstance()?.onUserLogin(profile, withCleverTapID: userId as! String)
        
        // call to record the Notification viewed
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData:request.content.userInfo)
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("I am from NSE")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
