//
//  AlertItem.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id: UUID = UUID()
    var title: Text
    var message: Text
    let dismissButton: Alert.Button
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
    
}

struct AlertContext {
    
    //MARK: -MapViewErrors
    static let unableToGetLocations = AlertItem (
        title: Text("Location Error"),
        message: Text("Unable to get locations at this time. Please try again later."),
        dismissButton: .default(Text("Ok")))
    static let locationRestricted = AlertItem (
        title: Text("Location Restricted"),
        message: Text("Your location is restricted. This may be due to parental controls"),
        dismissButton: .default(Text("Ok")))
    static let locationDenied = AlertItem (
        title: Text("Location Denied"),
        message: Text("VibeTag does not have permission to access your location. To change that go to your phone's Settings > VibeTag > Location"),
        dismissButton: .default(Text("Ok")))
    static let locationDisabled = AlertItem (
        title: Text("Location Disabled"),
        message: Text("Your phone's location services are disabled. To change that go to your phone's Settings > Privacy > Location Services"),
        dismissButton: .default(Text("Ok")))
    static let didFailWithError = AlertItem (
        title: Text("Location Failed"),
        message: Text("Error finding location. Please Contact support."),
        dismissButton: .default(Text("Ok")))
    
    //MARK: -ProfileViewErrors
    static let noUserRecord = AlertItem (
        title: Text("No User Record"),
        message: Text("You must log into iCloud on your phone to utilize VibeTag. Please log in on your phone's settings screen. "),
        dismissButton: .default(Text("Ok")))
    static let loginRequired = AlertItem (
        title: Text("No Profile Record"),
    message: Text("Please log in to VibeTag to be notified when your QR code is scanned. "),
        dismissButton: .default(Text("Ok")))
    static let createProfileSuccess = AlertItem (
        title: Text("Profile Created Successfully!"),
        message: Text("Your profile has been successfully created."),
        dismissButton: .default(Text("Ok")))
    static let createProfileFailure = AlertItem (
        title: Text("Failed to create Profile"),
        message: Text("We were unable to create your profile at this time. Please try again or contact customer support if this persists"),
        dismissButton: .default(Text("Ok")))
    static let unableToGetProfile = AlertItem (
        title: Text("Unable to Retrieve Profile"),
        message: Text("We were unable to retrieve your profile at this time. Please check or internet connection and try again later or contact customer support if this persists"),
        dismissButton: .default(Text("Ok")))
    static let unableToGetCompletedVibes = AlertItem (
        title: Text("Unable to get completed Vibes"),
        message: Text("We were unable to retrieve your completed Vibes at this time. Please check or internet connection and try again later or contact customer support if this persists"),
        dismissButton: .default(Text("Ok")))
    static let updateProfileSuccess = AlertItem (
        title: Text("Profile Update Success!"),
        message: Text("Your VibeTag profile was updated successfully."),
        dismissButton: .default(Text("Ok")))
    static let retrieveProfileFailure = AlertItem (
        title: Text("Profile retrival Failed."),
        message: Text("We were unable to retrieve your profile at this time. Please try again or contact customer support if this persists"),
        dismissButton: .default(Text("Ok")))
    static let biometricsUnavailable = AlertItem (
        title: Text("Biometrics Unavailable"),
        message: Text("Biometrics are either disabled or unavailable on your device. Please use Continue with Apple to sign in."),
        dismissButton: .default(Text("Ok")))
    static let signInWithAppleFailed = AlertItem (
        title: Text("Unable to Sign In with Apple"),
        message: Text("Please close the app and try again. If the issue persists, contact support."),
        dismissButton: .default(Text("Ok")))
    
    //MARK: -VibeDetailErrors
    static let invalidPhoneNumber = AlertItem (
        title: Text("Invalid Phone Number."),
        message: Text("The phone number you provided is invalid."),
        dismissButton: .default(Text("Ok")))
    
    //MARK: -SubmitPhotoViewErrors
    static let unableToGetPhotoSpots = AlertItem (
        title: Text("Unable to get photo spots"),
        message: Text("Please try again later or contact support."),
        dismissButton: .default(Text("Ok")))
    static let logInRequired = AlertItem (
        title: Text("Login Required"),
        message: Text("Please sign in with your Apple ID to continue"),
        dismissButton: .default(Text("Ok")))
    static let missingBarName = AlertItem (
        title: Text("Missing Information"),
        message: Text("The bar name is required. Please try again."),
        dismissButton: .default(Text("Ok")))
    static let missingHashTag = AlertItem (
        title: Text("Missing Information"),
        message: Text("A tag is required. Please try again."),
        dismissButton: .default(Text("Ok")))
    static let success = AlertItem (
        title: Text("Success!"),
        message: Text("Submission complete. Please present the QR code to a staff member."),
        dismissButton: .default(Text("Ok")))
    static let scanComplete = AlertItem (
        title: Text("Scan Complete"),
        message: Text("Your vibe was scanned successfully. Thank you for being apart of VibeTag."),
        dismissButton: .default(Text("Ok")))
    
}
