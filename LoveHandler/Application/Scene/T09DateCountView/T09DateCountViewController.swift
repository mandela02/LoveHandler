//
//  DateCountViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit

class T09DateCountViewController: BasePageViewChildController {
    
    @IBOutlet weak var yearView: NumberDisplayView!
    @IBOutlet weak var monthView: NumberDisplayView!
    @IBOutlet weak var weekView: NumberDisplayView!
    @IBOutlet weak var dayView: NumberDisplayView!
    
    @IBOutlet weak var hourView: NumberDisplayView!
    @IBOutlet weak var minuteView: NumberDisplayView!
    @IBOutlet weak var secondView: NumberDisplayView!
    
    @IBOutlet weak var todayLabel: BaseLabel!
    
    override func setupView() {
        super.setupView()
        calculate()
        todayLabel.text = SettingsHelper.relationshipStartDate.value.dayMonthYearString
        todayLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setupTheme() {
        super.setupTheme()
        todayLabel.textColor = UIColor.white
    }
    
    private func calculate() {
        let startDate = Settings.relationshipStartDate.value
        
        createDisplayValue()
        
        var hour = Date.countBetweenDate(component: .hour, start: startDate, end: Date())
            .quotientAndRemainder(dividingBy: 24).remainder
        var minute = Date.countBetweenDate(component: .minute, start: startDate, end: Date())
            .quotientAndRemainder(dividingBy: 60).remainder
        var second = Date.countBetweenDate(component: .second, start: startDate, end: Date())
            .quotientAndRemainder(dividingBy: 60).remainder
        
        hourView.setupLabel(with: "\(hour)", size: 15)
        minuteView.setupLabel(with: "\(minute)", size: 15)
        secondView.setupLabel(with: "\(second)", size: 15)

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            second += 1
            if second == 60 {
                second = 0
                minute += 1
            }
            
            if minute == 60 {
                minute = 0
                hour += 1
            }
            
            if hour == 24 {
                hour = 0
                self.createDisplayValue()
            }
            
            self.hourView.setupLabel(with: "\(hour)", size: 15)
            self.minuteView.setupLabel(with: "\(minute)", size: 15)
            self.secondView.setupLabel(with: "\(second)", size: 15)
        }
    }
    
    private func createDisplayValue() {
        let startDate = Settings.relationshipStartDate.value
        let year = Date.countBetweenDate(component: .year, start: startDate, end: Date())
        let month = Date.countBetweenDate(component: .month, start: startDate, end: Date())
        let week = Date.countBetweenDate(component: .weekOfYear, start: startDate, end: Date())
        let day = Date.countBetweenDate(component: .day, start: startDate, end: Date())

        
        yearView.setupLabel(with: "\(year)", title: "year")
        monthView.setupLabel(with: "\(month)", title: "month")
        weekView.setupLabel(with: "\(week)", title: "week")
        dayView.setupLabel(with: "\(day)", title: "day")
    }
}
