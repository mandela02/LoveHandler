//
//  PersonView.swift
//  LoveHandler
//
//  Created by LanNTH on 17/04/2021.
//

import UIKit

class PersonView: UIView {
    var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PersonView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
