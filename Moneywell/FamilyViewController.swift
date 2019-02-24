//
//  FamilyViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 21/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit

let dummyFamilyAccounts = [
    Account(
        number: "2558408",
        name: "Nicholas Rianto Putra",
        activeBalance: 160000,
        totalBalance: -830000,
        weekDelta: 2828
    ),
    Account(
        number: "3875229",
        name: "Jennie Kim",
        activeBalance: 838383,
        totalBalance: 838383,
        weekDelta: -2828
    ),
    Account(
        number: "5554042",
        name: "Ella Gross",
        activeBalance: 838383,
        totalBalance: 838383,
        weekDelta: -2828,
        isChild: true
    ),
]

class FamilyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var familyView = FamilyView(accountNumber: "84848484")
    
    @IBAction func createAccountTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "What type of account would you like to add?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Invite Existing Account", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Create New Child Account", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(familyAccountsDidUpdated), name: Notification.Name(rawValue: "FamilyViewFamilyAccountsUpdated"), object: nil)
    }
    
    @objc func familyAccountsDidUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FamilyMemberDetail" {
            if let cell = (sender as? FamilyMemberCell) {
                cell.isSelected = false
                if let memberName = cell.memberNameLabel.text, let familyMemberDetailVC = segue.destination as? FamilyDetailViewController {
                    familyMemberDetailVC.navigationItem.title = memberName
                }
            }
        }
    }
}

extension FamilyViewController: UIActionSheetDelegate {
    
}

extension FamilyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyFamilyAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMemberCell", for: indexPath) as! FamilyMemberCell
        
        cell.layer.cornerRadius = CellCornerRadius
        cell.childLabelContainer.layer.cornerRadius = DeltaContainerCornerRadius
        
        let member = dummyFamilyAccounts[indexPath.row]
        cell.memberImage = nil
        cell.memberNameLabel.text = member.name
        cell.memberAccountNumberLabel.text = member.number
        
        if !member.isChild {
            cell.childLabelContainer.isHidden = true
        }
        
        return cell
    }
    
    
}

class FamilyMemberCell: UITableViewCell {
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberAccountNumberLabel: UILabel!
    @IBOutlet weak var childLabelContainer: UIView!
    
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
