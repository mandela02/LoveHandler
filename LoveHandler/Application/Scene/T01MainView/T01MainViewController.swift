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
    
    @IBOutlet weak var imageBackgroundView: UIImageView!
    
    @IBOutlet weak var firstLoverView: PersonView!
    @IBOutlet weak var secondLoverView: PersonView!
    @IBOutlet weak var loveButton: UIButton!
    
    @IBOutlet weak var floaterHeartView: Floater!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: T01MainViewViewModel?
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        setupBackground(data: Settings.background.value)
        setUpLover()
        setupHeartFloatView()
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func dismissView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupLocalizedString() {
        titleLabel.text = LocalizedString.t01MainScreenTitle
    }
    
    override func setupTheme() {
        settingButton.tintColor = UIColor.white
        diaryButton.tintColor = UIColor.white
        loveButton.tintColor = UIColor.red
        
        titleLabel.textColor = UIColor.white
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
                
        let input = T01MainViewViewModel.Input(onButtonTap: onButtonTap,
                                               onHeartButtonTap: loveButton.tapPublisher)
        let output = viewModel.transform(input)
        
        output.noResponser
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {}).store(in: &cancellables)
                
        var isAnimating = false
        
        output
            .heartButtonTapped
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                if !isAnimating {
                    isAnimating = true
                    
                    self?.floaterHeartView.startAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.floaterHeartView.stopAnimation()
                        isAnimating = false
                    })
                }
            })
            .store(in: &cancellables)
        
        SettingsHelper.backgroundImage
            .sink { [weak self] data in
                self?.setupBackground(data: data)
            }
            .store(in: &cancellables)
    }
}

extension T01MainViewController {
    private func setUpLover() {
        firstLoverView.person = Person.get(fromKey: .you)
        firstLoverView.target = .you
        secondLoverView.person = Person.get(fromKey: .soulmate)
        secondLoverView.target = .soulmate
    }
    
    private func setupBackground(data: Data?) {
        guard let data = data else {
            imageBackgroundView.image = ImageNames.love1.image
            return
        }
        imageBackgroundView.image = UIImage(data: data)
    }
    
    private func setupHeartFloatView() {
        floaterHeartView.floaterImage1 = SystemImage.roundHeart.image.tintColor(with: Colors.deepPink)
        floaterHeartView.floaterImage2 = SystemImage.roundHeart.image.tintColor(with: Colors.lightPink)
        floaterHeartView.floaterImage3 = SystemImage.roundHeart.image.tintColor(with: Colors.pink)
        floaterHeartView.floaterImage4 = SystemImage.roundHeart.image.tintColor(with: Colors.hotPink)
    }
}
