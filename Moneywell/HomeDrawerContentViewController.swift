//
//  HomeDrawerContentViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 18/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Pulley

let dummyFamilyData = [
    [
        "name": "Joanna",
        "balance": 3472000,
        "delta": 2400000
    ],
    [
        "name": "Josh",
        "balance": 1703000,
        "delta": -830000
    ]
]

let dummyTransactionData = [
    [
        "date": Date(timeIntervalSince1970: 0),
        "company": "Allbirds, Inc.",
        "amount": 1403000
    ],
    [
        "date": Date(timeIntervalSince1970: 0),
        "company": "NVIDIA, LLC.",
        "amount": 6159000
    ],
    [
        "date": Date(timeIntervalSince1970: 0),
        "company": "Apple, Inc.",
        "amount": 12485000
    ],
]

class HomeDrawerContentViewController: UIViewController {
    @IBOutlet weak var gripperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gripperView.layer.cornerRadius = 2.5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeDrawerContentViewController: PulleyDrawerViewControllerDelegate {
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.collapsed, .open]
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 400.00 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
}

extension HomeDrawerContentViewController: UITableViewDataSource {
    enum TableSection: Int, CaseIterable {
        case FamilyMember = 0, Transaction
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = ? "FamilyMemberCell" : "TransactionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
        
        return cell
    }
}

extension HomeDrawerContentViewController: UITableViewDelegate {
    
}
