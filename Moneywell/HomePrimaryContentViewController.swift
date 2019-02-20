//
//  HomePrimaryContentViewController.swift
//  Moneywell
//
//  Created by Abram Situmorang on 18/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import Charts

let dummyYouChartData: [(Int, Int64)] = [(0, 1000000), (1, 2000000), (2, 1500000), (3, 1700000), (4, 1000000), (5, 5000000), (6, 1200000)]
let dummyFamilyChartData: [(Int, Int64)] = [(0, 1000000), (1, 2000000), (2, 1500000), (3, 1700000), (4, 1000000), (5, 2200000), (6, 1200000)]

let dummyYourData: FamilyMember = FamilyMember(name: "Deryan", balance: 10000000, delta: -100000000000)

// Chart constants
let ChartLineWidth = CGFloat(1.8)
let ChartCircleRadius = CGFloat(10)

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

private class YAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.kmFormatted
    }
}

private class XAxisValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 0.0: return "Sun"
        case 1.0: return "Mon"
        case 2.0: return "Tue"
        case 3.0: return "Wed"
        case 4.0: return "Thu"
        case 5.0: return "Fri"
        case 6.0: return "Sat"
        default:
            return ""
        }
    }
}

class HomePrimaryContentViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var balanceTitle: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var deltaContainer: UIView!
    @IBOutlet weak var lineChart: LineChartView!
    
    var slides: [Slide] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup delegates
//        chartScrollView.delegate = self

        // Do any additional setup after loading the view.
        deltaContainer.layer.cornerRadius = DeltaContainerCornerRadius
        
        // TODO: ScrollView pagination
        
        // Initialize chart
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        // Update balanceLabel
        balanceLabel.text = dummyYourData.balance.currencyFormat
        
        // Update deltaLabel
        if dummyYourData.delta > 0 {
            deltaLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let deltaString = "+" + dummyYourData.delta.kmFormatted
            deltaLabel.text = deltaString
        } else if dummyYourData.delta == 0 {
            deltaLabel.textColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.5647058824, alpha: 1)
            let deltaString = String(dummyYourData.delta)
            deltaLabel.text = deltaString
        } else {
            deltaLabel.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0, alpha: 1)
            let deltaString = "-" + abs(dummyYourData.delta).kmFormatted
            deltaLabel.text = deltaString
        }
        
        // update lineChart
        setupChart(withData: dummyYouChartData)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        chartPageControl.currentPage = Int(pageIndex)
//    }
//    
//    func setupSlideScrollView(slides: [Slide]) {
//        chartScrollView.frame = CGRect(x: 0, y: 178, width: view.frame.width, height: 120)
//        chartScrollView.contentSize = CGSize(width: 274 * CGFloat(slides.count), height: 120)
//        chartScrollView.isPagingEnabled = true
//        
//        for i in 0 ..< slides.count {
//            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 178, width: view.frame.width, height: 120)
//            chartScrollView.addSubview(slides[i])
//        }
//    }
//    
//    func createSlides() -> [Slide] {
//        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide1.lineChart = setupChart(withData: dummyYouChartData)
//        
//        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide2.lineChart = setupChart(withData: dummyFamilyChartData)
//        
//        return [slide1, slide2]
//    }
    
    func setupChart(withData data: [(Int, Int64)]) {
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
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .clear
        yAxis.valueFormatter = YAxisValueFormatter()
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        
        // Y Axis configuration
        let xAxis = lineChart.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
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

extension Double {
    var kmFormatted: String {
        let locale = Locale(identifier: "id_ID")
        
        if self >= 10000 && self <= 999999 {
            return String(format: "%.1fK", locale: locale, self/1000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999 && self <= 999999999 {
            return String(format: "%.1fM", locale: locale, self/1000000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999999 && self <= 999999999999 {
            return String(format: "%.1fB", locale: locale, self/1000000000).replacingOccurrences(of: ",0", with: "")
        }
        
        if self > 999999999999 {
            return String(format: "%.1fT", locale: locale, self/1000000000000).replacingOccurrences(of: ",0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current, self)
    }
}

extension Int64 {
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)!
    }
}

