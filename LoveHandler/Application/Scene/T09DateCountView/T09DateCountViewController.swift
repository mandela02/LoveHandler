//
//  DateCountViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 04/07/2021.
//

import UIKit
import Combine

class T09DateCountViewController: BasePageViewChildController {
    
    @IBOutlet weak var yearView: NumberDisplayView!
    @IBOutlet weak var monthView: NumberDisplayView!
    @IBOutlet weak var weekView: NumberDisplayView!
    @IBOutlet weak var dayView: NumberDisplayView!
    
    @IBOutlet weak var hourView: NumberDisplayView!
    @IBOutlet weak var minuteView: NumberDisplayView!
    @IBOutlet weak var secondView: NumberDisplayView!
    
    @IBOutlet weak var todayLabel: BaseLabel!
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    override func setupView() {
        super.setupView()
        todayLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        SettingsHelper.relationshipStartDate
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] date in
                self?.todayLabel.text = date.dayMonthYearString

                self?.timer?.invalidate()
                self?.timer = nil
                self?.calculate()
            }
            .store(in: &cancellables)
    }
    
    override func setupTheme() {
        super.setupTheme()
        todayLabel.textColor = UIColor.white
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        createDisplayValue()
        todayLabel.text = SettingsHelper.relationshipStartDate.value.dayMonthYearString
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
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
        
        yearView.setupLabel(with: "\(year)", title: LocalizedString.year)
        monthView.setupLabel(with: "\(month)", title: LocalizedString.month)
        weekView.setupLabel(with: "\(week)", title: LocalizedString.week)
        dayView.setupLabel(with: "\(day)", title: LocalizedString.day)
    }
}
