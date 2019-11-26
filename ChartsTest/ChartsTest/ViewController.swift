//
//  ViewController.swift
//  ChartsTest
//
//  Created by User on 11/25/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Charts

enum DataSource: String, CaseIterable {
    case price = "Price"
    case yield = "Yield"
}

class ViewController: UIViewController {

    @IBOutlet var chartView: LineChartView!
    @IBOutlet var changeSourceButton: UIButton!
    var dataSource: DataSource = .yield {
        didSet {
            self.changeSourceButton.setTitle(dataSource.rawValue, for: .normal)
            self.addData(dataSet: getData(dataSource: dataSource), clearPrevious: true)
        }
    }
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chart"
        self.changeSourceButton.setTitle(dataSource.rawValue, for: .normal)
        
        configureCalendar()
        addData(dataSet: getData(dataSource: self.dataSource), clearPrevious: true)
    }
    
    //MARK: - Actions
    @IBAction func changeSourceData(_ sender: Any) {
        let actions = DataSource.allCases.map { (source) -> UIAlertAction in
            let action = UIAlertAction(
                title: source.rawValue,
                style: .default) {[weak self] (action) in
                    guard self?.dataSource != source else {
                        return
                    }
                    self?.dataSource = source
            }
            return action
        }
        self.showAlert(
            title: "Choose source",
            actions: actions,
            style: .actionSheet)
    }
    
    //MARK: - Custom methods
    private func addData(dataSet: LineChartDataSet, clearPrevious: Bool) {
        if clearPrevious {
            let data = LineChartData(dataSet: dataSet)
            chartView.data = data
        } else {
            chartView.data?.addDataSet(dataSet)
        }
        
        chartView.animate(xAxisDuration: 0.6, easingOption: .linear)
    }
    
    private func configureCalendar() {
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        chartView.pinchZoomEnabled = true
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.centerAxisLabelsEnabled = false
    }
    
    private func getData(
        dataSource: DataSource,
        _ count: Int = 15,
        startDay: Date = Date(),
        colorLine: UIColor = .red
        ) -> LineChartDataSet {
        let repository = EventRepository(countDays: count, startDate: startDay)
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (repository.events.map { $0.date.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }

        let xValuesNumberFormatter = ChartXAxisFormatter(
            referenceTimeInterval: referenceTimeInterval,
            dateFormatter: DateFormatter.chartDateFormatter)
        chartView.xAxis.valueFormatter = xValuesNumberFormatter

        var entries = [ChartDataEntry]()
        for event in repository.events {
            let timeInterval = event.date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)

            let yValue = event.data
            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
        }
        
        let set1 = LineChartDataSet(entries: entries, label: "Some data")
        set1.drawIconsEnabled = false
        
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(colorLine)
        set1.setCircleColor(colorLine)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 11)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        set1.drawFilledEnabled = false
        
        return set1
    }
}



extension ViewController: ChartViewDelegate {
    
    
    
}
