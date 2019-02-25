//
//  User.swift
//  Moneywell
//
//  Created by Abram Situmorang on 25/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

struct User {
    var userId: String
    var email: String
    var name: String
    var givenName: String
    var familyName: String
    var hasImage: Bool
    var imageURL: URL? = nil
}
