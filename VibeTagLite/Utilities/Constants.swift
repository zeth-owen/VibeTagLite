//
//  Constants.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import UIKit

enum RecordType {
    static let location = "VibeLocation"
    static let profile = "VibeProfile"
    static let photo = "VibePhoto"
    static let featuredPhoto = "FeaturedPhoto"
    static let userVibeProgress = "UserVibeProgress"
}

enum PlaceHolderImage {
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
    static let igSuare = UIImage(named: "ig-square-asset")!
}

enum ImageDimension {
    case square, banner
    
    var placeHolderImage: UIImage {
        switch self {
        case .square:
            return PlaceHolderImage.square
        case .banner:
            return PlaceHolderImage.banner
        }
    }
}


extension Notification.Name {
    static let cloudKitSubscriptionReceived = Notification.Name("cloudKitSubscriptionReceived")
}
