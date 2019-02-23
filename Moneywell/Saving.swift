//
//  Saving.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

struct Saving {
    var name: String
    var balance: Int64
    var dayDelta: Int64
    var weekDelta: Int64
    var monthDelta: Int64
    
    init(name: String, balance: Int64, dayDelta: Int64 = 0, weekDelta: Int64 = 0, monthDelta: Int64 = 0) {
        self.name = name
        self.balance = balance
        self.dayDelta = dayDelta
        self.weekDelta = weekDelta
        self.monthDelta = monthDelta
    }
}
