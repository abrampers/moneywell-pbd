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
                totalBalance: -830000,
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
    }
}

extension Int64 {
    var kmFormatted: String {
        let locale = Locale(identifier: "id_ID")
        
        if self >= 10000 && self <= 999999 {
            return String(format: "%.1fK", locale: locale, Double(self)/1000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999 && self <= 999999999 {
            return String(format: "%.1fM", locale: locale, Double(self)/1000000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999999 && self <= 999999999999 {
            return String(format: "%.1fB", locale: locale, Double(self)/1000000000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999999999 {
            return String(format: "%.1fT", locale: locale, Double(self)/1000000000000).replacingOccurrences(of: ",0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current, Double(self))
    }
}

extension Date {
    var ddyymmFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
