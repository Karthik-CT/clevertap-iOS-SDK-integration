//
//  NSE.swift
//  push
//
//  Created by Karthik Iyer on 13/12/24.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK

class NSE: CTNotificationServiceExtension {
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        
        super.didReceive(request, withContentHandler: contentHandler)
    }
}
