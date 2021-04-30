//
//  T01MainViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import Foundation
import UIKit
import WaveAnimationView
import Combine
import CombineCocoa

class T01MainViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var heartView: LoveProgressView!
    
    @IBOutlet weak var imageBackgroundView: UIImageView!
    @IBOutlet weak var defaultBackgroundView: UIView!
    
    @IBOutlet weak var firstLoverView: PersonView!
    @IBOutlet weak var secondLoverView: PersonView!
    @IBOutlet weak var loveButton: UIButton!
    
    private var wave: WaveAnimationView?
    private var cancellables = Set<AnyCancellable>()
    private var viewDidAppearSignal = PassthroughSubject<Void, Never>()
    var viewModel: T01MainViewViewModel?
    
    deinit {
        viewDidAppearSignal.send(completion: .finished)
        cancellables.forEach { $0.cancel() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSignal.send(Void())
    }
    
    override func setupView() {
        super.setupView()
        setupBackground()
        setUpLover()
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func dismissView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        wave?.stopAnimation()
    }
    
    override func setupLocalizedString() {
        titleLabel.text = LocalizedString.t01MainScreenTitle
    }
    
    override func setupTheme() {
        titleLabel.textColor = UIColor.black
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let settingButtonTap = settingButton.tapPublisher
            .map { _ in return T01MainButtonType.setting }
            .eraseToAnyPublisher()
        let diaryButtonTap = diaryButton.tapPublisher
            .map { _ in return T01MainButtonType.diary }
            .eraseToAnyPublisher()
        
        let onButtonTap = Publishers.Merge(settingButtonTap, diaryButtonTap)
            .eraseToAnyPublisher()
        
        let onSettingChange = Publishers.Merge3(SettingsHelper.marryDate.map { _ in }.eraseToAnyPublisher(),
                                                SettingsHelper.relationshipStartDate.map { _ in }.eraseToAnyPublisher(),
                                                SettingsHelper.isShowingBackgroundWave.map { _ in }.eraseToAnyPublisher())
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .map { _ in }
            .eraseToAnyPublisher()
        
        let input = T01MainViewViewModel.Input(onButtonTap: onButtonTap,
                                               viewDidAppear: viewDidAppearSignal.eraseToAnyPublisher(),
                                               onSettingChange: onSettingChange)
        let output = viewModel.transform(input)
        
        output.noResponser
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {}).store(in: &cancellables)
        
        output.progress
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:  { [weak self] in
                self?.wave?.setProgress($0)
                self?.heartView.progress = $0
            })
            .store(in: &cancellables)
        
        output.numberOfDay
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:  { [weak self] in
                self?.heartView.numberOfDay = $0
            })
            .store(in: &cancellables)
        
        output
            .isShowingWaveBackground
            .receive(on: DispatchQueue.main)
            .map { !$0 }
            .sink(receiveValue: { [weak self] isHidden in
                self?.defaultBackgroundView.isHidden = isHidden
            })
            .store(in: &cancellables)    }
}

extension T01MainViewController {
    private func setUpLover() {
        firstLoverView.person = Person(name: "Test person 1", gender: .male, dateOfBirth: Date())
        secondLoverView.person = Person(name: "Test person 1", gender: .female, dateOfBirth: Date())
    }
    
    private func setupBackground() {
        imageBackgroundView.image = ImageNames.defaultBackground.image
        animationInitial()
    }
    
    private func animationInitial() {
        wave = WaveAnimationView(frame: defaultBackgroundView.bounds, color: UIColor.red.withAlphaComponent(0.75))
        wave?.backgroundColor = UIColor.clear
        wave?.startAnimation()
        wave?.frontColor = UIColor.red.withAlphaComponent(0.25)
        wave?.backColor = UIColor.red.withAlphaComponent(0.15)
        
        if let wave = wave {
            self.defaultBackgroundView.addSubview(wave)
        }
    }
}
