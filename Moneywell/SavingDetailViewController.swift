//
//  SavingDetailViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 20/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Charts

struct SavingDetail {
    var balance: Int64
    var todayDelta: Int64
    var thisWeekDelta: Int64
    var thisMonthDelta: Int64
}

struct RecentTransaction {
    enum TransactionType: Int {
        case withdraw = 0, deposit
    }
    
    var name: String
    var date: Date
    var amount: Int64
    var type: TransactionType
}

let ButtonCornerRadius = CGFloat(28)

let dummySavingDetailData: SavingDetail = SavingDetail(balance: 10540000, todayDelta: -500000, thisWeekDelta: 1000500, thisMonthDelta: 2560000)
let dummySavingChartData: [(Int, Int64)] = [(0, 1000000), (1, 2000000), (2, 1500000), (3, 1700000), (4, 1000000), (5, 2000000), (6, 1200000)]

let dummySavingMembers: [Account] = [
    Account(
        number: "3249100234",
        name: "Nicholas Rianto Putra",
        activeBalance: 160000,
        totalBalance: -830000,
        weekDelta: 2828
    ),
    Account(
        number: "3249100234",
        name: "Jennie Kim",
        activeBalance: 160000,
        totalBalance: -830000,
        weekDelta: 2828
    )
]

let dummyRecentInOut: [RecentTransaction] = [
    RecentTransaction(name: "Jennie Kim", date: Date(timeIntervalSince1970: 1550958944), amount: 100000, type: .withdraw),
    RecentTransaction(name: "Nicholas Rianto Putra", date: Date(timeIntervalSince1970: 1550948844), amount: 100000, type: .deposit),
    RecentTransaction(name: "Nicholas Rianto Putra", date: Date(timeIntervalSince1970: 1550938744), amount: 100000, type: .deposit),
    RecentTransaction(name: "Jennie Kim", date: Date(timeIntervalSince1970: 1550928644), amount: 100000, type: .withdraw)
]


class SavingDetailViewController: UIViewController, ChartViewDelegate {
    
    var savingName: String?
    lazy var isFamily: Bool = false
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet var deltaContainers: [UIView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayDeltaLabel: UILabel!
    @IBOutlet weak var thisWeekDeltaLabel: UILabel!
    @IBOutlet weak var thisMonthDeltaLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
//    @IBAction func startTap(_ sender: UIButton) {
//        sender.layer.backgroundColor = UIColor.lightGray.cgColor
//    }
//    @IBAction func finishedTap(_ sender: UIButton) {
//        sender.layer.backgroundColor = UIColor.white.cgColor
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        depositButton.layer.cornerRadius = ButtonCornerRadius
        withdrawButton.layer.cornerRadius = ButtonCornerRadius
        
        for container in deltaContainers {
            container.layer.cornerRadius = DeltaContainerCornerRadius
        }
        
        updateViewFromModel()
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        print("SavingDetail: ", tableView.frame.size)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        super.updateViewConstraints()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    func updateViewFromModel() {
        // Update balanceLabel
        balanceLabel.text = dummySavingDetailData.balance.currencyFormat
        
        // Update all deltaLabel
        updateDeltaLabel(label: todayDeltaLabel, withDelta: dummySavingDetailData.todayDelta)
        updateDeltaLabel(label: thisWeekDeltaLabel, withDelta: dummySavingDetailData.thisWeekDelta)
        updateDeltaLabel(label: thisMonthDeltaLabel, withDelta: dummySavingDetailData.thisMonthDelta)
        
        // Update chart
        updateChart(withData: dummySavingChartData)
    }
    
    func updateDeltaLabel(label deltaLabel: UILabel, withDelta delta: Int64) {
        if delta > 0 {
            deltaLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let deltaString = "+" + delta.kmFormatted
            deltaLabel.text = deltaString
        } else if delta == 0 {
            deltaLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let deltaString = String(delta)
            deltaLabel.text = deltaString
        } else {
            deltaLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
            let deltaString = "-" + abs(delta).kmFormatted
            deltaLabel.text = deltaString
        }
    }
    
    func updateChart(withData data: [(Int, Int64)]) {
        lineChart.delegate = self
        lineChart.dragEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.legend.enabled = false
        
        // Y Axis configuration
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        yAxis.setLabelCount(3, force: false)
        yAxis.labelTextColor = #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .clear
        yAxis.valueFormatter = YAxisValueFormatter()
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        
        // Y Axis configuration
        let xAxis = lineChart.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = .clear
        xAxis.valueFormatter = XAxisValueFormatter()
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        
        lineChart.data = chartData(withData: data)
        
        lineChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    func chartData(withData data: [(Int, Int64)]) -> LineChartData {
        var yValues = [ChartDataEntry]()
        for tuple in data {
            yValues.append(ChartDataEntry(x: Double(tuple.0), y: Double(tuple.1)))
        }
        
        let set = LineChartDataSet(values: yValues, label: "")
        set.mode = .cubicBezier
        set.lineWidth = ChartLineWidth
        set.fillColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.5333333333, alpha: 1)
        set.fillAlpha = 1
        set.highlightColor = .white
        
        set.drawCirclesEnabled = false
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 12, weight: .semibold))
        data.setDrawValues(false)
        
        return data
    }
}

extension SavingDetailViewController: UITableViewDataSource {
    enum TableSection: Int, CaseIterable {
        case members = 0, recentInOut
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFamily ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isFamily {
            return dummyRecentInOut.count
        }
        
        switch section {
        case TableSection.members.rawValue:
            return dummySavingMembers.count
        case TableSection.recentInOut.rawValue:
            return dummyRecentInOut.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var prototype = (indexPath.section == TableSection.members.rawValue) ? "SavingMembersCell" : "RecentTransactionCell"
        
        if !isFamily {
            prototype = "RecentTransactionCell"
        }
        
        if prototype == "SavingMembersCell" && isFamily {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! SavingMembersCell
            
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
            let member = dummySavingMembers[indexPath.row]
            cell.memberImage = nil
            cell.memberNameLabel.text = member.name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! RecentTransactionCell
            
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
            let transaction = dummyRecentInOut[indexPath.row]
            cell.transactionNameLabel.text = transaction.name
            cell.transactionDateLabel.text = transaction.date.ddyymmFormat
            if transaction.type == .deposit {
                cell.transactionAmountLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
                cell.transactionAmountLabel.text = "+" + transaction.amount.currencyFormat
            } else {
                cell.transactionAmountLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
                cell.transactionAmountLabel.text = "-" + transaction.amount.currencyFormat
            }
            
            return cell
        }
    }
}

extension SavingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont(name: "Avenir-Heavy", size: SectionHeaderFontSize)
        label.textColor = #colorLiteral(red: 0.5450422168, green: 0.5451371074, blue: 0.5450297594, alpha: 1)
        if let tableSection = TableSection(rawValue: section) {
            if !isFamily {
                label.text = "Recent In/Out"
            } else {
                switch tableSection {
                case .members:
                    label.text = "Members"
                case .recentInOut:
                    label.text = "Recent In/Out"
                }
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
}

class SavingMembersCell: UITableViewCell {
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    
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

class RecentTransactionCell: UITableViewCell {
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    
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
