//
//  SavingsViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 20/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController {
    
    lazy var savingsPage = SavingsPage(accountNumber: "84848484")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SavingDetail" {
            if let cell = (sender as? SavingsCell) {
                cell.isSelected = false
                if let savingName = cell.savingNameLabel.text, let savingDetailVC = segue.destination as? SavingDetailViewController {
                    savingDetailVC.savingName = savingName
                    savingDetailVC.navigationItem.title = savingName
                    savingDetailVC.isFamily = (sender as? SavingsCell)?.indexPath?.section == TableSection.family.rawValue
                }
            }
        } else if segue.identifier == "CreateSaving" {
            
        }
    }
}

extension SavingsViewController: UITableViewDataSource {
    enum TableSection: Int, CaseIterable {
        case personal = 0, family
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableSection.personal.rawValue:
            return self.savingsPage.personalSavings.count
        case TableSection.family.rawValue:
            return self.savingsPage.familySavings.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsCell", for: indexPath) as! SavingsCell
        cell.indexPath = indexPath
        
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
        if indexPath.section == TableSection.personal.rawValue {
            let saving = self.savingsPage.personalSavings[indexPath.row]
            cell.savingNameLabel?.text = saving.name
            cell.savingBalanceLabel?.text = saving.balance.currencyFormat
        } else {
            let saving = self.savingsPage.familySavings[indexPath.row]
            cell.savingNameLabel?.text = saving.name
            cell.savingBalanceLabel?.text = saving.balance.currencyFormat
        }
        
        // Arrow
        cell.tintColor = UIColor.white
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SavingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont(name: "Avenir-Heavy", size: SectionHeaderFontSize)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .personal:
                label.text = "Personal"
            case .family:
                label.text = "Family"
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
}

class SavingsCell: UITableViewCell {
    @IBOutlet weak var savingNameLabel: UILabel!
    @IBOutlet weak var savingBalanceLabel: UILabel!
    var indexPath: IndexPath?
    
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
