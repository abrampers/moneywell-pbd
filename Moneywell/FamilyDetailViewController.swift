//
//  FamilyDetailViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 24/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Charts

let dummySavings = [
    Saving(name: "PC", balance: 0),
    Saving(name: "College", balance: 100000)
]

let dummyAccount = Account(
    number: "3249100234",
    name: "Faza Fahleraz",
    activeBalance: 160000,
    totalBalance: -830000,
    weekDelta: 2828
)

class FamilyDetailViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberFullNameLabel: UILabel!
    @IBOutlet weak var memberAccountNumberLabel: UILabel!
    @IBOutlet weak var memberBalanceLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet var deltaContainers: [UIView]!
    @IBOutlet weak var todayDeltaLabel: UILabel!
    @IBOutlet weak var thisWeekDeltaLabel: UILabel!
    @IBOutlet weak var thisMonthDeltaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for container in deltaContainers {
            container.layer.cornerRadius = DeltaContainerCornerRadius
        }
        
        updateViewFromModel()
        
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        super.updateViewConstraints()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    func updateViewFromModel() {
        memberFullNameLabel.text = dummyAccount.name
        memberAccountNumberLabel.text = dummyAccount.number
        memberBalanceLabel.text = dummyAccount.activeBalance.currencyFormat
        updateDeltaLabel(label: todayDeltaLabel, withDelta: dummyAccount.dayDelta)
        updateDeltaLabel(label: todayDeltaLabel, withDelta: dummyAccount.weekDelta)
        updateDeltaLabel(label: todayDeltaLabel, withDelta: dummyAccount.monthDelta)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FamilyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dummySavings.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyDetailSavingCell", for: indexPath)
            
            cell.layer.cornerRadius = CellCornerRadius
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeAccessCell", for: indexPath)
            
            cell.layer.cornerRadius = CellCornerRadius
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension FamilyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont(name: "Avenir-Heavy", size: SectionHeaderFontSize)
        label.textColor = #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
        switch section {
        case 0:
            label.text = "Savings"
        case 1:
            label.text = "Access Management"
        default:
            label.text = ""
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderHeight
    }
}

class FamilyDetailSavingCell: UITableViewCell {
    @IBOutlet weak var savingNameLabel: UILabel!
    @IBOutlet weak var savingBalanceLabel: UILabel!
    
    
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

class ChangeAccessCell: UITableViewCell {
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
