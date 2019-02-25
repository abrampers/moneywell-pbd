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
    var isFamilyAccountsInitialized: Bool
    var isRecentFamilyTransactionsInitialized: Bool
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        self.isFamilyAccountsInitialized = false
        self.isRecentFamilyTransactionsInitialized = false
        
        familyAccounts = [
            Account(
                balance: 0,
                weekDelta: 0
            )
        ]
        
        recentFamilyTransactions = [
            Transaction(
                date: Date(timeIntervalSince1970: 0),
                title: "--",
                amount: 0,
                category: "--"
            )
        ]
    }
    
    func updateData() {
        let updateRecentFamilyTransactionsRequest = HTTPRequest(
            url: "\(Constants.url)/transactions?email=\(UserDefaults.user!.email)",
            completionHandler: updateRecentTransactions
        )
        updateRecentFamilyTransactionsRequest.resume()
    }
    
    func updateRecentTransactions(response: [String: Any]) {
        let transactions = response["data"] as! Array<Any>
        
        self.recentFamilyTransactions = []
        for case let transaction as Dictionary<String, Any> in transactions {
            self.recentFamilyTransactions.append(Transaction(
                date: Date(timeIntervalSince1970: (transaction["timestamp"] as! Double) / 1000),
                title: transaction["title"] as! String,
                amount: transaction["amount"] as! Int64,
                category: transaction["category"] as! String
            ))
        }
        self.isRecentFamilyTransactionsInitialized = true
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DashboardDrawerRecentTransactionsUpdated"), object: self)
    }
}
