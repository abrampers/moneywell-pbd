//
//  Family.swift
//  Moneywell
//
//  Created by Abram Situmorang on 24/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

class FamilyView {
    let accountNumber: String
    var familyAccounts: [Account]
    var isFamilyAccountsInitialized: Bool
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        self.isFamilyAccountsInitialized = false
        
        familyAccounts = [
            Account(
                number: "--",
                name: "--",
                activeBalance: 0,
                totalBalance: 0,
                weekDelta: 0
            )
        ]
    }
    
    func updateData() {
        let updateFamilyAccountsRequest = HTTPRequest(
            url: "\(Constants.url)/families?accountNumber=\(2558408)",
            completionHandler: updateFamilyAccounts
        )
        updateFamilyAccountsRequest.resume()
    }
    
    func updateFamilyAccounts(response: [String: Any]) {
        let adults = response["adults"] as! Array<Any>
        let childs = response["childs"] as! Array<Any>
        
        self.familyAccounts = []
        for case let account as Dictionary<String, Any> in adults {
            familyAccounts.append(Account(
                number: account["accountNumber"] as! String,
                name: account["name"] as! String,
                activeBalance: account["activeBalance"] as! Int64,
                totalBalance: account["totalBalance"] as! Int64,
                weekDelta: account["weekDelta"] as! Int64
            ))
        }
        
        for case let account as Dictionary<String, Any> in childs {
            familyAccounts.append(Account(
                number: account["number"] as! String,
                name: account["name"] as! String,
                activeBalance: account["activeBalance"] as! Int64,
                totalBalance: account["totalBalance"] as! Int64,
                weekDelta: account["weekDelta"] as! Int64,
                isChild: true
            ))
        }
        
        self.isFamilyAccountsInitialized = true
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "FamilyViewFamilyAccountsUpdated"), object: self)
    }
}
