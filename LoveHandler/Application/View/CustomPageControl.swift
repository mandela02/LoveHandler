//
//  CustomPageView.swift
//  SimpleCalendar
//
//  Created by Bui Quang Tri on 10/2/20.
//  Copyright © 2020 komorebi. All rights reserved.
//

import UIKit

enum MoveDirection {
    case left
    case right
}

class CustomPageControl: UIView {
    
    var currentPage: Int = 0 {
        didSet {
            setCurrentDotColor()
        }
    }
    var numberOfPages: Int = 0 {
        didSet {
            setupDot()
        }
    }
    
    private var stackView: UIStackView?
    
    private var normalDotColor: UIColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
    private var selectedDotColor: UIColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        
    private let dotSize: CGFloat = 7
    private let spacing: CGFloat = UIDevice.current.isSmallIphone ? 5 : 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    func initView(numberOfPages: Int, currentPage: Int) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        setupPageView()
    }
    
    private func setupDot() {
        stackView?.removeAllArrangedSubviews()
        (0..<numberOfPages).forEach { index in
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            view.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            view.backgroundColor = index == currentPage ? selectedDotColor : normalDotColor
            view.viewCornerRadius = dotSize / 2
            stackView?.addArrangedSubview(view)
        }
    }
    
    private func setCurrentDotColor() {
        let dots = stackView?.arrangedSubviews
        dots?.forEach { $0.backgroundColor = normalDotColor }
        if let dot = dots?[safe: currentPage] {
            dot.backgroundColor = selectedDotColor
        }
    }

    private func setupPageView() {
        stackView = UIStackView(frame: self.frame)
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.alignment = .center
        stackView?.spacing = spacing
        stackView?.axis = .horizontal
        stackView?.distribution = .fill
        if let stackView = stackView {
            self.addSubview(stackView)
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
    
    func move(to direction: MoveDirection) {
        let currentDot = currentPage
        let numberOfDots = numberOfPages
        var incomingDot = direction == .right ? currentDot - 1 : currentDot + 1
        if incomingDot > numberOfDots - 1 {
            incomingDot = 0
        }
        if incomingDot < 0 {
            incomingDot = numberOfDots - 1
        }
        currentPage = incomingDot
    }
}
