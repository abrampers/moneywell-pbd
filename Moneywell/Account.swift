//
//  Account.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

struct Account {
    var number: String
    var name: String
    var activeBalance: Int64
    var totalBalance: Int64
    var dayDelta: Int64
    var weekDelta: Int64
    var monthDelta: Int64
    var isChild: Bool
    
    init(number: String, name: String, activeBalance: Int64, totalBalance: Int64, dayDelta: Int64 = 0, weekDelta: Int64 = 0, monthDelta: Int64 = 0, isChild: Bool = false) {
        self.number = number
        self.name = name
        self.activeBalance = activeBalance
        self.totalBalance = totalBalance
        self.dayDelta = dayDelta
        self.weekDelta = weekDelta
        self.monthDelta = monthDelta
        self.isChild = isChild
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
