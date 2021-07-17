//
//  PasscodeViewController.swift
//  Passcode
//
//  Created by hb on 08/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import AudioToolbox

class PasscodeViewController: UIViewController {
    
    enum ButtonType {
        case number(value: Int)
        case biometric
        case backspace
    }

    public enum Mode {
        case CREATE
        case VERIFY
    }
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var msgLabel: UILabel!
    @IBOutlet private weak var pinView: UIStackView!
    @IBOutlet private weak var numberPadCollectionView: UICollectionView!
    
    static var config: PasscodeConfig = PasscodeConfig() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.init("pass_config_changed"), object: nil)
        }
    }
        
    private var keyValues: [ButtonType] = [
        .number(value: 1),
        .number(value: 2),
        .number(value: 3),
        .number(value: 4),
        .number(value: 5),
        .number(value: 6),
        .number(value: 7),
        .number(value: 8),
        .number(value: 9),
        .biometric,
        .number(value: 0),
        .backspace
    ]
    
    private var mode: Mode = .CREATE
    private var currentPincode: String? = ""
    private var pincode: String? = ""
    private var oldPincode: String? = ""
    private var changePinStep = 1
    private var completion: ((_ code: String, _ new_code: String, _ mode: Mode) -> Void)?
    
    class func instance(with mode: Mode) -> PasscodeViewController? {
        let vc = UIStoryboard.init(name: "Passcode", bundle: Bundle.main).instantiateViewController(withIdentifier: "kPasscodeViewController") as? PasscodeViewController
        vc?.mode = mode
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(setupTheme), name: NSNotification.Name.init("pass_config_changed"), object: nil)
    }
    
    private func initialSetup() {
        self.navigationItem.title = mode == .CREATE ? PasscodeViewController.config.confirmMessage : nil
        setTransparentNavigationBar(.white)
        setupTheme()
        setupMsgLabel()
    }
    
    @objc private func dismissVc() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setTransparentNavigationBar(_ color: UIColor = .white) {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = .clear
            if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 {
                navigationBar.tintColor = .clear
            } else {
                navigationBar.tintColor = .clear
                navigationBar.barTintColor = .clear
            }
            navigationBar.barTintColor = .clear
            navigationBar.isTranslucent = true
            
            navigationBar.tintColor = color
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
            ]
        }
    }
    
    @objc private func setupTheme() {
        msgLabel.textColor = PasscodeViewController.config.msgColor
        setUpDigitsDots()
        configureCollectionView()
    }
    
    private func setUpDigitsDots() {
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.removeAllArrangedSubviews()
        for _ in 1...PasscodeViewController.config.noOfDigits {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
            view.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
            view.backgroundColor = PasscodeViewController.config.digitColor
            view.layer.cornerRadius = 12.0
            view.alpha = 0.2
            pinView.addArrangedSubview(view)
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        numberPadCollectionView.collectionViewLayout = layout
        numberPadCollectionView.register(KeyPadCell.cellNib, forCellWithReuseIdentifier: KeyPadCell.cellIdentifier)
        numberPadCollectionView.delegate = self
        numberPadCollectionView.dataSource = self
        numberPadCollectionView.reloadData()
    }
    
    @objc private func setupMsgLabel() {
        msgLabel.text = mode == .VERIFY ? PasscodeViewController.config.confirmMessage : PasscodeViewController.config.viewDesctiption
    }
        
    private func updateDots(isBackspace: Bool) {
        func resetDots(index: Int) {
            let transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.2) {
                self.pinView.arrangedSubviews[index].transform = transform
            }
        }
        let index = isBackspace ? ((pincode ?? "").count) : ((pincode ?? "").count - 1)
        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        let alpha: CGFloat = isBackspace ? 0.2 : 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.pinView.arrangedSubviews[index].transform = transform
            self.pinView.arrangedSubviews[index].alpha = alpha
        }, completion: { (_) in
            resetDots(index: index)
        })
    }
    
    @objc private func resetAllDots() {
        pinView.arrangedSubviews.forEach { (dot) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                dot.alpha = 0.2
            }, completion: nil)
        }
    }
    
    @objc private func animateDots() {
        var index = 0
        pinView.arrangedSubviews.forEach { (dot) in
            UIView.animate(withDuration: 0.1, delay: 0.07 * Double(index), options: .autoreverse, animations: {
                dot.alpha = 0.2
                dot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (_) in
                dot.alpha = 1.0
                dot.transform = CGAffineTransform.identity
            })
            index += 1
        }
        if self.view.isUserInteractionEnabled == false {
            self.perform(#selector(animateDots), with: nil, afterDelay: (0.1 * Double(PasscodeViewController.config.noOfDigits)))
        } else {
            self.perform(#selector(resetAllDots), with: nil, afterDelay: (0.1 * Double(PasscodeViewController.config.noOfDigits)))
            self.perform(#selector(setupMsgLabel), with: nil, afterDelay: (0.1 * Double(PasscodeViewController.config.noOfDigits)))
            pincode = ""
            oldPincode = ""
            currentPincode = ""
            changePinStep = 1
        }
    }
    
    private func submitPinCode() {
        if mode == .CREATE {
            if oldPincode?.count == 0 {
                oldPincode = pincode
                pincode = ""
                resetAllDots()
                msgLabel.text = PasscodeViewController.config.confirmMessage
                numberPadCollectionView.isUserInteractionEnabled = true
                return
            } else if pincode != oldPincode {
                numberPadCollectionView.isUserInteractionEnabled = false
                pinView.shake()
                msgLabel.text = PasscodeViewController.config.notMatchMessage
                resetAllDots()
                pincode = ""
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                    self.numberPadCollectionView.isUserInteractionEnabled = true
                    self.oldPincode = ""
                    self.msgLabel.text = PasscodeViewController.config.viewDesctiption
                })
                return
            } else {
                guard let code = pincode else { return }
                PasscodeHelper.savePasscode(passcode: code)
                completion?(pincode ?? "", oldPincode ?? "", self.mode)
            }
        } else {
            guard let passCode = PasscodeHelper.getPasscode(),
                  let code = pincode else { return }
            if code == passCode {
                completion?(pincode ?? "", oldPincode ?? "", self.mode)
            } else {
                numberPadCollectionView.isUserInteractionEnabled = false
                pinView.shake()
                msgLabel.text = PasscodeViewController.config.notMatchMessage
                resetAllDots()
                pincode = ""
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                    self.numberPadCollectionView.isUserInteractionEnabled = true
                    self.oldPincode = ""
                    self.msgLabel.text = PasscodeViewController.config.confirmMessage
                })
                return
            }
            
        }
    }
    
    private func showBioMetric() {
        let response = self.canEvaluateAuthenticationWithBiometrics()
        if response.0 == true {
            self.authenticationWithTouchID({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    self.completion?("BioMetric", "", self.mode)
                })
            }, onFail: { (error) in
                print(error ?? "error")
            })
        } else {
            print(response.1)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func show(in viewController: UIViewController? = nil, animated: Bool = true, onCallback: @escaping ((_ code: String, _ new_code: String, _ mode: Mode) -> Void)) {
        if PasscodeViewController.config.noOfDigits > 8 {
            assertionFailure("PasscodeViewController : no of digit must be between 4 to 8 digits")
        }
        self.completion = onCallback
        if let vc = viewController ?? appDelegate?.window?.rootViewController {
            let navigationVC = UINavigationController(rootViewController: self)
            navigationVC.modalPresentationStyle = .fullScreen
            vc.present(navigationVC, animated: animated, completion: nil)
        }
    }
    
    func startProgressing() {
        self.view.isUserInteractionEnabled = false
        animateDots()
    }
    
    func stopProgress() {
        self.view.isUserInteractionEnabled = true
    }
    
}

extension PasscodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyPadCell.cellIdentifier, for: indexPath) as? KeyPadCell else {
            return UICollectionViewCell()
        }
        cell.isUserInteractionEnabled = true
        
        guard let buttonType = keyValues[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        switch buttonType {
        case .number(value: let value):
            cell.setContent(title: "\(value)", image: nil)
        case .backspace:
            cell.setContent(title: nil, image: PasscodeViewController.config.backspaceImg)
        case .biometric:
            if mode == .VERIFY {
                cell.setContent(title: nil, image: (biometricType == .none ? nil : (biometricType == .faceID ? PasscodeViewController.config.faceIdImg : PasscodeViewController.config.touchIdImg)))
            } else {
                cell.setContent(title: nil, image: nil)
                cell.isUserInteractionEnabled = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40) / 3
        let height = (collectionView.frame.size.height - 60) / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let buttonType = keyValues[safe: indexPath.row] else {
            return
        }
        
        switch buttonType {
        case .number(value: let value):
            guard let code = pincode else {
                return
            }
            
            if code.count < PasscodeViewController.config.noOfDigits {
                pincode = "\(pincode ?? "")\(value)"
            }
            
            updateDots(isBackspace: false)

            if pincode?.count == PasscodeViewController.config.noOfDigits {
                collectionView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                    self.submitPinCode()
                })
            }

        case .backspace:
            pincode?.removeLast()
            updateDots(isBackspace: true)
        case .biometric:
            showBioMetric()
        }
    }
}

extension UIStackView {
    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}

extension UIView {
    func shake(ratio: CGFloat?=10) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - ratio!, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + ratio!, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
