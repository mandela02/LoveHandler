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
    }
    
    private func calculate() {
        let startDate = Settings.relationshipStartDate.value
        let today = Date()
        var year = Date.countBetweenDate(component: .year, start: startDate, end: today)
        var month = Date.countBetweenDate(component: .month, start: startDate, end: today)
        var week = Date.countBetweenDate(component: .weekOfYear, start: startDate, end: today)
        var day = Date.countBetweenDate(component: .day, start: startDate, end: today)

        var hour = Date.countBetweenDate(component: .hour, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 24).remainder
        var minute = Date.countBetweenDate(component: .minute, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 60).remainder
        var second = Date.countBetweenDate(component: .second, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 60).remainder
        
        yearView.setupLabel(with: "\(year)")
        monthView.setupLabel(with: "\(month)")
        weekView.setupLabel(with: "\(week)")
        dayView.setupLabel(with: "\(day)")
        hourView.setupLabel(with: "\(hour)")
        minuteView.setupLabel(with: "\(minute)")
        secondView.setupLabel(with: "\(second)")
        
        var remainMonth = Date.countBetweenDate(component: .month, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 12).remainder
        var remainWeek = Date.countBetweenDate(component: .weekOfYear, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 4).remainder
        var remainDay = Date.countBetweenDate(component: .day, start: startDate, end: today)
            .quotientAndRemainder(dividingBy: 7).remainder

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
                remainDay += 1
                day += 1
            }
            
            if remainDay == 7 {
                remainDay = 0
                remainWeek += 1
                week += 1
            }
            
            if remainWeek == 4 {
                remainWeek = 0
                remainMonth += 1
                month += 1
            }
            
            if remainMonth == 12 {
                remainMonth = 0
                year += 1
            }
            
            self.yearView.setupLabel(with: "\(year)")
            self.monthView.setupLabel(with: "\(month)")
            self.weekView.setupLabel(with: "\(week)")
            self.dayView.setupLabel(with: "\(day)")
            self.hourView.setupLabel(with: "\(hour)")
            self.minuteView.setupLabel(with: "\(minute)")
            self.secondView.setupLabel(with: "\(second)")
        }
    }
}
