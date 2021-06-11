//
//  T03MemoryListViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import UIKit
import Combine

class T03MemoryListViewController: BaseViewController {
    
    @IBOutlet weak var addButton: RoundButton!
    
    var viewModel: T03MemoryListViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var onViewWillAppearSignal = PassthroughSubject<Void, Never>()

    deinit {
        onViewWillAppearSignal.send(completion: .finished)
        
        cancellables.forEach { $0.cancel() }
    }

    override func setupView() {
        super.setupView()
        isBackButtonVisible = true
        isTitleVisible = true
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = "Memory"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel else { return }
        
        let input = T03MemoryListViewModel.Input(viewWillAppear: onViewWillAppearSignal.eraseToAnyPublisher(),
                                                 dismissTrigger: closeButton.tapPublisher)
        
        let output = viewModel.transform(input)
        
        output.noRespone.sink(receiveValue: {}).store(in: &cancellables)
    }
    
    override func setupTheme() {
        super.setupTheme()
        addButton.backgroundColor = Colors.hotPink
    }
}
