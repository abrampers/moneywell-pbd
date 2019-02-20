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
    var recentTransactions: [RecentTransaction]
}

struct RecentTransaction {
    var date: Date
    var amount: Int64
}

let ButtonCornerRadius = CGFloat(28)

let dummySavingDetailData: SavingDetail = SavingDetail(balance: 1000000, todayDelta: -500000, thisWeekDelta: 1000500, thisMonthDelta: 2560000, recentTransactions: [RecentTransaction(date: Date(timeIntervalSince1970: 0), amount: 1000000), RecentTransaction(date: Date(timeIntervalSince1970: 0), amount: 300000)])
let dummySavingChartData: [(Int, Int64)] = [(0, 1000000), (1, 2000000), (2, 1500000), (3, 1700000), (4, 1000000), (5, 2000000), (6, 1200000)]


class SavingDetailViewController: UIViewController, ChartViewDelegate {
    
    var savingName: String?
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet var deltaContainers: [UIView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayDeltaLabel: UILabel!
    @IBOutlet weak var thisWeekDeltaLabel: UILabel!
    @IBOutlet weak var thisMonthDeltaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        depositButton.layer.cornerRadius = ButtonCornerRadius
        withdrawButton.layer.cornerRadius = ButtonCornerRadius
        
        for container in deltaContainers {
            container.layer.cornerRadius = DeltaContainerCornerRadius
        }
        
        updateViewFromModel()
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
        if dummyYourData.delta > 0 {
            deltaLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let deltaString = "+" + delta.kmFormatted
            deltaLabel.text = deltaString
        } else if dummyYourData.delta == 0 {
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
