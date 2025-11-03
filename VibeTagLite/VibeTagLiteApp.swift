//
//  VibeTagLiteApp.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import SwiftUI

@main
struct VibeTagLiteApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let userManager = UserManager()
    let vibeManager = VibeManager()
    let featuredPhotoManager = FeaturedPhotoManager()
    let photoLocationManager = PhotoLocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environment(vibeManager)
                .environment(userManager)
                .environmentObject(featuredPhotoManager)
                .environmentObject(photoLocationManager)
           
        }
    }
}
