//
//  UserDefaultsExtension.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 25/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation
import CoreLocation

enum UnwrapError: Error {
    case error
}

extension UserDefaults {
    var currentLocation: CLLocation {
        get { return CLLocation(latitude: latitude ?? 90, longitude: longitude ?? 0) } // default value is North Pole (lat: 90, long: 0)
        set { latitude = newValue.coordinate.latitude
            longitude = newValue.coordinate.longitude }
    }
    
    static var user: User? {
        get {
            do {
                guard let userId: String = standard.string(forKey: "userId") else { throw UnwrapError.error }
                guard let email: String = standard.string(forKey: "email") else { throw UnwrapError.error }
                guard let name: String = standard.string(forKey: "name") else { throw UnwrapError.error }
                guard let givenName: String = standard.string(forKey: "givenName") else { throw UnwrapError.error }
                guard let familyName: String = standard.string(forKey: "familyName") else { throw UnwrapError.error }
                guard let hasImage: Bool = standard.bool(forKey: "hasImage") else { throw UnwrapError.error }
                guard let imageURL: URL? = standard.url(forKey: "imageUrl") else { throw UnwrapError.error }
                if hasImage {
                    return User(userId: userId, email: email, name: name, givenName: givenName, familyName: familyName, hasImage: hasImage, imageURL: imageURL)
                } else {
                    return User(userId: userId, email: email, name: name, givenName: givenName, familyName: familyName, hasImage: hasImage, imageURL: nil)
                }
            } catch {
                return nil
            }
        }
        set {
            standard.set(newValue!.userId, forKey: "userId")
            standard.set(newValue!.email, forKey: "email")
            standard.set(newValue!.name, forKey: "name")
            standard.set(newValue!.givenName, forKey: "givenName")
            standard.set(newValue!.familyName, forKey: "familyName")
            standard.set(newValue!.hasImage, forKey: "hasImage")
            standard.set(newValue!.imageURL, forKey: "imageURL")
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return standard.bool(forKey: "isLoggedIn")
        }
        set {
            if newValue {
                standard.set(newValue, forKey: "isLoggedIn")
            } else {
                standard.set(newValue, forKey: "isLoggedIn")
                standard.removeObject(forKey: "userId")
                standard.removeObject(forKey: "email")
                standard.removeObject(forKey: "name")
                standard.removeObject(forKey: "givenName")
                standard.removeObject(forKey: "familyName")
                standard.removeObject(forKey: "hasImage")
                standard.removeObject(forKey: "imageUrl")
            }
        }
    }
    
    static var idToken: String {
        get {
            return standard.string(forKey: "idToken")!
        }
        set {
            standard.set(newValue, forKey: "idToken")
        }
    }
    
    private var latitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }
    
    private var longitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }
}
