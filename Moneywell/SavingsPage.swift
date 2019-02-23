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
                name: "Food",
                balance: 539000
            ),
            Saving(
                name: "Movie",
                balance: 92000
            )
        ]
        
        familySavings = [
            FamilySaving(
                name: "Holiday to Ibiza",
                balance: 10540000,
                members: []
            ),
            FamilySaving(
                name: "Healthcare",
                balance: 21550000,
                members: []
            )
        ]
    }
}
