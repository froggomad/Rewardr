//
//  CustomButton.swift
//  Rewardr
//
//  Created by Kenny on 4/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: -2,
                                         height: -2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1

        setTitleColor(.white, for: .normal)
        setTitleShadowColor(.tertiary, for: .normal)
        titleLabel?.shadowOffset = CGSize(width: -3,
                                          height: -3)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: -2,
                                         height: -2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1

        setTitleColor(.white, for: .normal)
        setTitleShadowColor(.tertiary, for: .normal)
        titleLabel?.shadowOffset = CGSize(width: -2,
                                          height: -2)
    }

}

class LoginButton: CustomButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondary
        self.frame.size.height = frame.size.height * 1.5
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .secondary
        frame.size.height = frame.size.height * 1.5
    }
}

class LogoutButton: CustomButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .action
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .action
    }
}
