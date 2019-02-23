//
//  HomeDrawerContentViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 18/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Pulley

// Drawer constants
let DrawerCornerRadius = CGFloat(8.0)

// TableView constants
// Section constants
let SectionHeaderHeight = CGFloat(50.0)
let SectionHeaderFontSize = CGFloat(24)
// Row constants
let RowHeight = CGFloat(190.0)
let CollapsedDrawerHeight = CGFloat(360.00)
let PartialRevealDrawerDistanceToTopSafeArea = CGFloat(100)
// Cell constants
let CellCornerRadius = CGFloat(16)
let DeltaContainerCornerRadius = CGFloat(12)
let RowSpacing = CGFloat(2)
let InsetSpacing = CGFloat(14)
// Shadow constants
let ShadowRadius = CGFloat(10)
let ShadowOpacity = CGFloat(0.23)
let ShadowOffset = CGSize(width: 0, height: 0)

class DashboardDrawerContentViewController: UIViewController {
    @IBOutlet weak var gripperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dashboardDrawer = DashboardDrawer(accountNumber: "84848484")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gripperView.layer.cornerRadius = 2.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(familyAccountsDidUpdated), name: Notification.Name(rawValue: "DashboardDrawerFamilyAccountsUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recentFamilyTransactionsDidUpdated), name: Notification.Name(rawValue: "DashboardDrawerRecentFamilyTransactionsUpdated"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(bounceDrawer), userInfo: nil, repeats: false)
        
        self.dashboardDrawer.updateData()
    }
    
    @objc fileprivate func bounceDrawer() {
        self.pulleyViewController?.bounceDrawer()
    }
    
    @objc func familyAccountsDidUpdated() {
        print(self.dashboardDrawer.familyAccounts)
        print("kon")
    }
    
    @objc func recentFamilyTransactionsDidUpdated() {
        print(self.dashboardDrawer.recentFamilyTransactions)
        print("tol")
    }
}

extension DashboardDrawerContentViewController: PulleyDrawerViewControllerDelegate {
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

extension DashboardDrawerContentViewController: UITableViewDataSource {
    enum TableSection: Int, CaseIterable {
        case FamilyMember = 0, Transaction
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableSection.FamilyMember.rawValue:
            return self.dashboardDrawer.familyAccounts.count
        case TableSection.Transaction.rawValue:
            return self.dashboardDrawer.recentFamilyTransactions.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = (indexPath.section == TableSection.FamilyMember.rawValue) ? "FamilyMemberDashboardCell" : "TransactionDashboardCell"
        
        if prototype == "FamilyMemberDashboardCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FamilyMemberDashboardCell

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
            let account = self.dashboardDrawer.familyAccounts[indexPath.row]
            cell.nameLabel?.text = account.name
            cell.balanceLabel?.text = account.totalBalance.currencyFormat
            cell.deltaContainer?.layer.cornerRadius = DeltaContainerCornerRadius

            if account.weekDelta > 0 {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
                let deltaString = "+" + account.weekDelta.kmFormatted
                cell.deltaLabel?.text = deltaString
            } else if account.weekDelta == 0 {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
                let deltaString = String(account.weekDelta)
                cell.deltaLabel?.text = deltaString
            } else {
                cell.deltaLabel?.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
                let deltaString = "-" + abs(account.weekDelta).kmFormatted
                cell.deltaLabel?.text = deltaString
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! TransactionDashboardCell
            
            // Rounded Corners
            cell.layer.cornerRadius = CellCornerRadius
            cell.clipsToBounds = true
            
            // Cell content
            let transaction = self.dashboardDrawer.recentFamilyTransactions[indexPath.row]
            cell.companyLabel?.text = transaction.title
            cell.detailsLabel?.text = transaction.date.ddyymmFormat + " - " + transaction.category
            cell.amountLabel?.text = transaction.amount.currencyFormat
            
            return cell
        }
    }
}

extension DashboardDrawerContentViewController: UITableViewDelegate {
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

class FamilyMemberDashboardCell: UITableViewCell {
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

class TransactionDashboardCell: UITableViewCell {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
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
