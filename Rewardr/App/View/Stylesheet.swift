//
//  Stylesheet.swift
//  Rewardr
//
//  Created by Kenny on 5/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

//MARK: - Colors -
extension UIColor {
    static let primary: UIColor = UIColor(named: "Primary")!
    static let secondary: UIColor = UIColor(named: "Secondary")!
    static let action: UIColor = UIColor(named: "Action")!
    static let tertiary: UIColor = UIColor(named: "Tertiary")!
    static let accent: UIColor = UIColor(named: "Accent")!
}

//MARK: - Layer -
let cornerRadius: CGFloat = 8
extension UIView {
    func setCornerRadius(_ customCornerRadius: CGFloat? = nil) {
        if let customRadius = customCornerRadius {
            self.layer.cornerRadius = customRadius
        }
        self.layer.cornerRadius = cornerRadius
    }
}

