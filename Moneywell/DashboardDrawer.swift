//
//  DashboardDrawer.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

class DashboardDrawer {
    let accountNumber: String
    var familyAccounts: [Account]
    var recentFamilyTransactions: [Transaction]
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        
        familyAccounts = [
            Account(
                number: "--",
                name: "--",
                activeBalance: 0,
                totalBalance: 0,
                weekDelta: 0
            )
        ]
        
        recentFamilyTransactions = [
            Transaction(
                date: Date(timeIntervalSince1970: 0),
                title: "--",
                accountName: "--",
                amount: 0,
                category: "--"
            )
        ]
    }
    
    func updateData() {
        let updateFamilyAccountsRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/families?accountNumber=\(2558408)",
            completionHandler: updateFamilyAccounts
        )
        updateFamilyAccountsRequest.resume()
        
        let updateRecentFamilyTransactionsRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/allTransactions?accountNumber=\(2558408)",
            completionHandler: updateRecentFamilyTransactions
        )
        updateRecentFamilyTransactionsRequest.resume()
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
                totalBalance: account["totalBalance"] as! Int64
            ))
        }

        for case let account as Dictionary<String, Any> in childs {
            familyAccounts.append(Account(
                number: account["number"] as! String,
                name: account["name"] as! String,
                activeBalance: account["activeBalance"] as! Int64,
                totalBalance: account["totalBalance"] as! Int64,
                isChild: true
            ))
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DashboardDrawerFamilyAccountsUpdated"), object: self)
    }
    
    func updateRecentFamilyTransactions(response: [String: Any]) {
        let transactions = response["data"] as! Array<Any>
        
        self.recentFamilyTransactions = []
        for case let transaction as Dictionary<String, Any> in transactions {
            self.recentFamilyTransactions.append(Transaction(
                date: Date(timeIntervalSince1970: transaction["timestamp"] as! TimeInterval),
                title: transaction["title"] as! String,
                accountName: transaction["accountName"] as! String,
                amount: transaction["amount"] as! Int64,
                category: transaction["category"] as! String
            ))
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DashboardDrawerRecentFamilyTransactionsUpdated"), object: self)
    }
}
