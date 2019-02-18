//
//  HomeDrawerContentViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 18/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Pulley

struct FamilyMember {
    var name: String
    var balance: Int64
    var delta: Int64
}

struct Transaction {
    var date: Date
    var company: String
    var amount: Int64
}

let dummyFamilyData: [FamilyMember] = [
    FamilyMember(name: "Joanna", balance: 3472000, delta: 2400000),
    FamilyMember(name: "Josh", balance: 1703000, delta: -830000)
]

let dummyTransactionData: [Transaction] = [
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Allbirds, Inc.", amount: 1403000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "NVIDIA, LLC.", amount: 6159000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Apple, Inc.", amount: 12485000)
]

let SectionHeaderHeight = CGFloat(50.0)
let RowHeight = CGFloat(190.0)
let CornerRadius = CGFloat(16)
let RowSpacing = CGFloat(5)
let InsetSpacing = CGFloat(14)
let CollapsedDrawerHeight = CGFloat(200.00)
let PartialRevealDrawerHeight = CGFloat(600.00)
let SectionHeaderFontSize = CGFloat(24)
let ShadowRadius = CGFloat(10)
let ShadowOpacity = CGFloat(0.23)
let ShadowOffset = CGSize(width: 0, height: 0)

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
        return [PulleyPosition.collapsed, .partiallyRevealed]
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return PartialRevealDrawerHeight
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return CollapsedDrawerHeight + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
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
        switch section {
        case TableSection.FamilyMember.rawValue:
            return dummyFamilyData.count
        case TableSection.Transaction.rawValue:
            return dummyTransactionData.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = (indexPath.section == TableSection.FamilyMember.rawValue) ? "FamilyMemberCell" : "TransactionCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
        
        
        // TODO: Shadow
        // cell.layer.masksToBounds = false
        // cell.layer.shadowRadius = ShadowRadius
        // cell.layer.shadowOffset = ShadowOffset
        // cell.layer.shadowColor = UIColor.black.cgColor
        // cell.layer.shadowRadius = ShadowRadius
        // cell.layer.masksToBounds = true
        
        // Rounded Corners
        cell.layer.cornerRadius = CornerRadius
        cell.clipsToBounds = true
        
        // Cell content
//        cell.nameLabel?.text = dummyFamilyData[indexPath.row].name
//        let balance = dummyFamilyData[indexPath.row].balance as NSNumber
//        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: "id")
//        formatter.numberStyle = .currency
//        cell.balanceLabel?.text = formatter.string(from: balance)
        
        return cell
        
//        if prototype == "FamilyMemberCell" {
//            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FamilyMemberCell
//
//            // TODO: Shadow
//            // cell.layer.masksToBounds = false
//            // cell.layer.shadowRadius = ShadowRadius
//            // cell.layer.shadowOffset = ShadowOffset
//            // cell.layer.shadowColor = UIColor.black.cgColor
//            // cell.layer.shadowRadius = ShadowRadius
//            // cell.layer.masksToBounds = true
//
//            // Rounded Corners
//            cell.layer.cornerRadius = CornerRadius
//            cell.clipsToBounds = true
//
//            // Cell content
//            cell.nameLabel?.text = dummyFamilyData[indexPath.row].name
//            let balance = dummyFamilyData[indexPath.row].balance as NSNumber
//            let formatter = NumberFormatter()
//            formatter.locale = Locale(identifier: "id")
//            formatter.numberStyle = .currency
//            cell.balanceLabel?.text = formatter.string(from: balance)
//
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as? TransactionCell
//
//            return cell
//        }
    }
}

extension HomeDrawerContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont(name: "Avenir-Heavy", size: SectionHeaderFontSize)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .FamilyMember:
                label.text = "Your Family"
            case .Transaction:
                label.text = "Recent Transactions"
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return RowHeight
//    }
}

class FamilyMemberCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        nameLabel.configure()
//        balanceLabel.configure()
//    }
}

class TransactionCell: UITableViewCell {
    
}

extension UILabel {
    func configure() {
        self.frame.size = CGSize.zero
        self.sizeToFit()
    }
}
