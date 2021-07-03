//
//  T08MemoryDateViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 03/07/2021.
//

import UIKit
import Combine

class T08MemoryDateViewController: BaseViewController {
    @IBOutlet weak var youView: SmallPersonView!
    @IBOutlet weak var soulMateView: SmallPersonView!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var weddingDateTItleLabel: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var weddingDateTextField: UITextField!
    @IBOutlet weak var weddingDatePicker: UIDatePicker!
    
    let index = 3
    private var cancellables = Set<AnyCancellable>()

    override func setupView() {
        super.setupView()
        
        youView.setupView(with: Person.get(fromKey: .you))
        soulMateView.setupView(with: Person.get(fromKey: .soulmate))
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
}
