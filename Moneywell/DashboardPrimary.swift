//
//  DashboardPrimary.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

class DashboardPrimary {
    let accountNumber: String
    var yourAccount: Account
    var isYourAccountInitialized: Bool
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        self.isYourAccountInitialized = false
        
        self.yourAccount = Account(
            number: "--",
            name: "--",
            activeBalance: 0,
            totalBalance: 0,
            weekDelta: 0
        )
    }
    
    func updateData() {
        let updateYourAccountRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/families?accountNumber=\(2558408)",
            completionHandler: updateYourAccount
        )
        updateYourAccountRequest.resume()
    }
    
    func updateYourAccount(response: [String: Any]) {
        let user = response["user"] as! Dictionary<String, Any>
        
        self.yourAccount = Account(
            number: user["accountNumber"] as! String,
            name: user["name"] as! String,
            activeBalance: user["activeBalance"] as! Int64,
            totalBalance: user["totalBalance"] as! Int64
        )
        
        self.isYourAccountInitialized = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DashboardPrimaryYourAccountUpdated"), object: self)
    }
}
