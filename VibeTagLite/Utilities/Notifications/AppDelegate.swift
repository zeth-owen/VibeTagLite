//
//  AppDelegate.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 8/12/25.
//

import UIKit
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        NotificationCenter.default.post(name: .cloudKitSubscriptionReceived, object: nil, userInfo: userInfo)
        completionHandler(.newData)
    }
}
