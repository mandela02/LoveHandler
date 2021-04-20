//
//  T01MainViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
import WaveAnimationView
import RxSwift
import RxCocoa

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
    
    private let disposeBag = DisposeBag()
    
    var viewModel: T01MainViewViewModel?
    
    override func setupView() {
        super.setupView()
        setupBackground()
        setUpLover()
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculate()
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
        let settingButtonTap = settingButton.rx.tap
            .map { _ in return T01MainButtonType.setting }
            .asObservable()
        let diaryButtonTap = diaryButton.rx.tap
            .map { _ in return T01MainButtonType.diary }
            .asObservable()
        
        let onButtonTap = Observable.merge(settingButtonTap, diaryButtonTap)
        
        let input = T01MainViewViewModel.Input(onButtonTap: onButtonTap)
        let output = viewModel.transform(input)
        
        output.noResponser.drive().disposed(by: disposeBag)
    }
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
    
    private func calculate() {
        let dayStartDating = Settings.relationshipStartDate.value
        let dayGettingMarry = Settings.marryDate.value
        let today = Date()
        
        let totalDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: dayGettingMarry)
        let currentDateDay = Date.countBetweenDate(component: .day, start: dayStartDating, end: today)
                 
        let progressive = Float(currentDateDay)/Float(totalDateDay)
        wave?.setProgress(progressive)
        heartView.progress = progressive
        heartView.numberOfDay = currentDateDay
    }
}
