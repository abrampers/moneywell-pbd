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
                number: "3249100234",
                name: "Faza Fahleraz",
                activeBalance: 160000,
                totalBalance: 830000,
                weekDelta: 2828
            ),
            Account(
                number: "3243330234",
                name: "Abram Perdanaputra",
                activeBalance: 838383,
                totalBalance: 838383,
                weekDelta: -2828
            ),
        ]
        
        recentFamilyTransactions = [
            Transaction(
                date: Date(timeIntervalSince1970: 0),
                title: "Allbirds, Inc.",
                accountName: "Faza Fahleraz",
                amount: 1403000,
                category: "Clothing"
            ),
            Transaction(
                date: Date(timeIntervalSince1970: 0),
                title: "Apple, Inc.",
                accountName: "Faza",
                amount: 1403000,
                category: "Faza Fahleraz"
            )
        ]
        
        let updateFamilyAccountsRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/families?accountNumber=\(2558408)",
            completionHandler: updateFamilyAccounts
        )
        updateFamilyAccountsRequest.resume()
        
        let updateRecentFamilyTransactionsRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/families?accountNumber=\(2558408)",
            completionHandler: updateRecentFamilyTransactions
        )
        updateRecentFamilyTransactionsRequest.resume()
    }
    
    func updateFamilyAccounts(response: Dictionary<String, Any>) {
        let childs = response["childs"] as! Array<Any>
        let adults = response["adults"] as! Array<Any>
        
        for case let account as Account in adults {
            print(account.number)
        }
    }
    
    func updateRecentFamilyTransactions(response: Dictionary<String, Any>) {
        
    }
}
