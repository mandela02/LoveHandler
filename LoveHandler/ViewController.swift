//
//  ViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var heartView: HeartView!
    private var animationView: AnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        //animationInitial()
        //heartView.tintColor = UIColor.red
    }

    private func animationInitial() {
        animationView = .init(name: "wave")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()


    }
}

