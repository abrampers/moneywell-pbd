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
    var spinner: UIActivityIndicatorView!
    @IBOutlet weak var gripperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dashboardDrawer = DashboardDrawer(accountNumber: "84848484")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gripperView.layer.cornerRadius = 2.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(recentTransactionsDidUpdated), name: Notification.Name(rawValue: "DashboardDrawerRecentTransactionsUpdated"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dashboardDrawer.updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(bounceDrawer), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func bounceDrawer() {
        self.pulleyViewController?.bounceDrawer()
    }
    
    @objc func recentTransactionsDidUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: UITableView.RowAnimation.automatic)
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboardDrawer.recentFamilyTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = "TransactionDashboardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! TransactionDashboardCell
        
        // Rounded Corners
        cell.layer.cornerRadius = CellCornerRadius
        cell.clipsToBounds = true
        
        // Cell content
        let transaction = self.dashboardDrawer.recentFamilyTransactions[indexPath.row]
        cell.companyLabel?.text = transaction.title
        cell.detailsLabel?.text = transaction.date.ddyymmFormat + " - " + transaction.category
        
        if transaction.amount > 0 {
            cell.amountLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let amountString = transaction.amount.currencyFormat
            cell.amountLabel?.text = amountString
        } else if transaction.amount == 0 {
            cell.amountLabel?.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let amountString = String(transaction.amount)
            cell.amountLabel?.text = amountString
        } else {
            cell.amountLabel?.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
            let amountString = abs(transaction.amount).currencyFormat
            cell.amountLabel?.text = amountString
        }
        
        //            cell.amountLabel?.text = transaction.amount.currencyFormat
        
        return cell
    }
}

extension DashboardDrawerContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont(name: "Avenir-Heavy", size: SectionHeaderFontSize)
        label.textColor = UIColor.black
        label.text = "Recent Transactions"
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
