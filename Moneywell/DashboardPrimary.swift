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
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        
        yourAccount = Account(
            number: "3249100234",
            name: "Faza Fahleraz",
            activeBalance: 160000,
            totalBalance: -830000,
            weekDelta: 2828
        )
    }
}
