//
//  T12AnimationSettingViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 20/07/2021.
//

import UIKit
import Combine

enum AnimatedAttributes: CaseIterable {
    case density
    case rotationSpeed
    case speed

    static var models: [AnimatedAttributesModel] {
        return self.allCases.map { animatedAttributes in
            switch animatedAttributes {
            case .density:
                return AnimatedAttributesModel(attribute: .density,
                                               title: "density",
                                               value: 50,
                                               maxValue: 100,
                                               minValue: 10)
            case .rotationSpeed:
                return AnimatedAttributesModel(attribute: .rotationSpeed,
                                               title: "rotationSpeed",
                                               value: 10,
                                               maxValue: 20,
                                               minValue: 1)
            case .speed:
                return AnimatedAttributesModel(attribute: .speed,
                                               title: "speed",
                                               value: 10,
                                               maxValue: 10,
                                               minValue: 1)
                
            }
        }
    }
}

struct AnimatedAttributesModel {
    let attribute: AnimatedAttributes
    let title: String
    var value: Float
    let maxValue: Float
    let minValue: Float
}

class T12AnimationSettingViewController: BaseViewController {
    @IBOutlet weak var firstIconImage: UIImageView!
    @IBOutlet weak var secondIconImageView: UIImageView!
    @IBOutlet weak var thirdIconImage: UIView!
    @IBOutlet weak var fourthIconImageView: UIImageView!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var animationView: HeartFloaterView!
    
    var dataSource = AnimatedAttributes.models
    
    private var cancellables = Set<AnyCancellable>()
    
    var animationDuration: Double = 0
    
    override func setupView() {
        super.setupView()
        settingTableView.dataSource = self
        settingTableView.delegate = self
        animationView.isHidden = true
        isBackButtonVisible = true
        isTitleVisible = true
        setUpFloater()
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        navigationTitle = "handsome"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        var isAnimating = false
        
        heartButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if !isAnimating {
                    isAnimating = true
                    self.animationView.isHidden = false
                    self.animationView.startAnimation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                        if isAnimating {
                            self.animationView.stopAnimation()
                        }
                    })

                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration + 1, execute: {
                        if isAnimating {
                            isAnimating = false
                            self.animationView.isHidden = true
                        }
                    })
                } else {
                    isAnimating = false
                    self.animationView.stopAnimation()
                    self.animationView.isHidden = true
                }
            })
            .store(in: &cancellables)
    }
    
    private func setUpFloater() {
        refreshAnimationDuration()
        animationView.floaterImage1 = SystemImage.roundHeart.image.tintColor(with: Colors.deepPink)
        animationView.floaterImage2 = SystemImage.roundHeart.image.tintColor(with: Colors.lightPink)
        animationView.floaterImage3 = SystemImage.roundHeart.image.tintColor(with: Colors.pink)
        animationView.floaterImage4 = SystemImage.roundHeart.image.tintColor(with: Colors.hotPink)
        
        dataSource.forEach { model in
            let value = Double(model.value)
            switch model.attribute {
            case .density:
                animationView.density = value
            case .rotationSpeed:
                animationView.rotationSpeed = value
            case .speed:
                animationView.speedY = CGFloat(value)
            }
        }
    }
    
    private func refreshAnimationDuration() {
        let duration = dataSource.first(where: { $0.attribute == .speed })?.value
        animationDuration = Double(duration!)
    }
}

extension T12AnimationSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimatedSettingTableViewCell.className, for: indexPath) as? AnimatedSettingTableViewCell else { return UITableViewCell()}
        cell.setUpCell(with: dataSource[indexPath.row])
        cell.didValueChange = { [weak self] value in
            self?.dataSource[indexPath.row].value = value
            self?.setUpFloater()
            tableView.reloadData()
        }
        return cell
    }
}

extension T12AnimationSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
