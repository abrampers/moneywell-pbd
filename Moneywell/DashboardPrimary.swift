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
    var isYourAccountInitialized: Bool
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
        self.isYourAccountInitialized = false
        
        self.yourAccount = Account(
            number: "--",
            name: "--",
            activeBalance: 0,
            totalBalance: 0,
            weekDelta: 0
        )
    }
    
    func updateData() {
        let updateYourAccountRequest = HTTPRequest(
            url: "https://moneywell-backend.herokuapp.com/api/userDetail?accountNumber=\(2558408)",
            completionHandler: updateYourAccount
        )
        updateYourAccountRequest.resume()
    }
    
    func updateYourAccount(response: [String: Any]) {
        var graphData: [(Int, Int64)] = []
        let datas = response["graph"] as! [[Any]]
        for data in datas {
            graphData.append((data[0] as! Int, data[1] as! Int64))
        }
        
        self.yourAccount = Account(
            number: response["accountNumber"] as! String,
            name: response["name"] as! String,
            activeBalance: response["activeBalance"] as! Int64,
            totalBalance: response["totalBalance"] as! Int64,
            weekDelta: response["weekDelta"] as! Int64,
            weekGraphData: graphData
        )
        
        self.isYourAccountInitialized = true
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DashboardPrimaryYourAccountUpdated"), object: self)
    }
}
