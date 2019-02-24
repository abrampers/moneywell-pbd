//
//  SavingsPage.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

class SavingsPage {
    let accountNumber: String
    var personalSavings: [Saving]
    var familySavings: [FamilySaving]
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        
        personalSavings = [
            Saving(
                name: "PS4",
                balance: 539000
            ),
            Saving(
                name: "Hanamasa",
                balance: 92000
            )
        ]
        
        familySavings = [
            FamilySaving(
                name: "Honeymoon to Maldives",
                balance: 10540000,
                members: []
            )
        ]
    }
}
