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
    FamilyMember(name: "Josh", balance: 1703000, delta: -830000),
    FamilyMember(name: "Abram", balance: 160000, delta: -830000),
    FamilyMember(name: "Faza", balance: 200000, delta: -830000),
    FamilyMember(name: "Deryan", balance: 4000000, delta: -830000),
    FamilyMember(name: "Nicho", balance: 30100000, delta: -830000)
]

let dummyTransactionData: [Transaction] = [
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Allbirds, Inc.", amount: 1403000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "NVIDIA, LLC.", amount: 6159000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Apple, Inc.", amount: 12485000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Allbirds, Inc.", amount: 1403000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "NVIDIA, LLC.", amount: 6159000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Apple, Inc.", amount: 12485000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Allbirds, Inc.", amount: 1403000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "NVIDIA, LLC.", amount: 6159000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Apple, Inc.", amount: 12485000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Allbirds, Inc.", amount: 1403000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "NVIDIA, LLC.", amount: 6159000),
    Transaction(date: Date(timeIntervalSince1970: 0), company: "Apple, Inc.", amount: 12485000)
]

// Drawer constants
let DrawerCornerRadius = CGFloat(8.0)

// TableView constants
// Section constants
let SectionHeaderHeight = CGFloat(50.0)
let SectionHeaderFontSize = CGFloat(24)
// Row constants
let RowHeight = CGFloat(190.0)
let CollapsedDrawerHeight = CGFloat(360.00)
let PartialRevealDrawerDistanceToTopSafeArea = CGFloat(40)
// Cell constants
let CellCornerRadius = CGFloat(16)
let DeltaContainerCornerRadius = CGFloat(12)
let RowSpacing = CGFloat(2)
let InsetSpacing = CGFloat(14)
// Shadow constants
let ShadowRadius = CGFloat(10)
let ShadowOpacity = CGFloat(0.23)
let ShadowOffset = CGSize(width: 0, height: 0)

class HomeDrawerContentViewController: UIViewController {
    @IBOutlet weak var gripperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
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
        let window = UIApplication.shared.windows[0]
        return window.safeAreaLayoutGuide.layoutFrame.size.height - PartialRevealDrawerDistanceToTopSafeArea
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return CollapsedDrawerHeight + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        // Handle tableview scrolling / searchbar editing
        tableView.isScrollEnabled = drawer.drawerPosition == .partiallyRevealed
        
        if drawer.drawerPosition == .collapsed {
            tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    // TODO: Upper section animation
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
        
        if prototype == "FamilyMemberCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FamilyMemberCell

            // TODO: Shadow
            // cell.layer.masksToBounds = false
            // cell.layer.shadowRadius = ShadowRadius
            // cell.layer.shadowOffset = ShadowOffset
            // cell.layer.shadowColor = UIColor.black.cgColor
            // cell.layer.shadowRadius = ShadowRadius
            // cell.layer.masksToBounds = true

            // Rounded Corners
            cell.layer.cornerRadius = CellCornerRadius
            cell.clipsToBounds = true

            // Cell content
            let famMember = dummyFamilyData[indexPath.row]
            cell.nameLabel?.text = famMember.name
            let balance = famMember.balance as NSNumber
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            cell.balanceLabel?.text = formatter.string(from: balance)
            cell.deltaContainer?.layer.cornerRadius = DeltaContainerCornerRadius

            if famMember.delta > 0 {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
                let deltaString = "+" + famMember.delta.kmFormatted
                cell.deltaLabel?.text = deltaString
            } else if famMember.delta == 0 {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
                let deltaString = String(famMember.delta)
                cell.deltaLabel?.text = deltaString
            } else {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
                let deltaString = "-" + abs(famMember.delta).kmFormatted
                cell.deltaLabel?.text = deltaString
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! TransactionCell
            
            // Rounded Corners
            cell.layer.cornerRadius = CellCornerRadius
            cell.clipsToBounds = true
            
            // Cell content
            let transaction = dummyTransactionData[indexPath.row]
            cell.companyLabel?.text = transaction.company
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyy"
            cell.dateLabel?.text = formatter.string(from: transaction.date)
            let amount = transaction.amount as NSNumber
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "id_ID")
            numberFormatter.numberStyle = .currency
            cell.amountLabel?.text = numberFormatter.string(from: amount)
            

            return cell
        }
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
}

class FamilyMemberCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var deltaContainer: UIView!
    @IBOutlet weak var deltaLabel: UILabel!
    
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

class TransactionCell: UITableViewCell {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
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
