//
//  AccessControlViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 24/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit

let dummyDataAccessControl = [
    Account(
        number: "3249100234",
        name: "Jennie Kim",
        activeBalance: 160000,
        totalBalance: -830000,
        dayDelta: 152,
        weekDelta: 2828,
        monthDelta: 8045
    ),
    Account(
        number: "3249100234",
        name: "Ella Gross",
        activeBalance: 160000,
        totalBalance: -830000,
        dayDelta: 152,
        weekDelta: 2828,
        monthDelta: 8045,
        isChild: true
    )
]

class AccessControlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension AccessControlViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDataAccessControl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessControlCell", for: indexPath) as! AccessControlCell
        
        cell.layer.cornerRadius = CellCornerRadius
        
        let member = dummyDataAccessControl[indexPath.row]
        cell.nameLabel.text = member.name
        
        return cell
    }
}

extension AccessControlViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

class AccessControlCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame =  newFrame
            frame.origin.y += RowSpacing
            frame.size.height -= 2 * RowSpacing
            frame.origin.x += InsetSpacing
            frame.size.width -= 2 * InsetSpacing
            super.frame = frame
        }
    }
}
