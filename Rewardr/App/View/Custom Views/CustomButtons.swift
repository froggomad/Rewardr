//
//  CustomButton.swift
//  Rewardr
//
//  Created by Kenny on 4/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
//MARK: - Parent Class -
class CustomButton: UIButton {
    //MARK: - inits -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    //MARK: - View Lifecycle -
    func setupViews() {
        setCornerRadius()
        layer.shadowOffset = CGSize(width: -2,
                                    height: -2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1

        setTitleColor(.white, for: .normal)
        setTitleShadowColor(.tertiary, for: .normal)
        titleLabel?.shadowOffset = CGSize(width: -3,
                                          height: -3)
    }
}

class LoginButton: CustomButton {
    //MARK: - View Lifecycle -
    func gradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.frame = bounds

        gradientLayer.colors = [UIColor.tertiary.cgColor, UIColor.primary.cgColor, UIColor.secondary.cgColor, UIColor.primary.cgColor, UIColor.tertiary.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient()
    }
}

class LogoutButton: CustomButton {
    //MARK: - inits -
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .action
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .action
    }
}
