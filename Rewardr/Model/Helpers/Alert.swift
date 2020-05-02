//
//  Alert.swift
//  Rewardr
//
//  Created by Kenny on 4/30/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import UIKit

enum Alert {
    static func show(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
