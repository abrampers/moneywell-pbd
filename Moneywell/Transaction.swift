//
//  Transaction.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

struct Transaction {
    var date: Date
    var title: String
    var accountName: String
    var amount: Int64
    var category: String
}

extension Date {
    var ddyymmFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
