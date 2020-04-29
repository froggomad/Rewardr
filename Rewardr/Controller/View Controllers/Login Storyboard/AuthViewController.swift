//
//  AuthViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    @IBOutlet weak private var loginButton: UIButton!

    @IBAction private func login() {
        guard let username = emailField.text,
            !username.isEmpty,
            let password = passwordField.text,
            !password.isEmpty
            else { return }
        AuthService().loginUser(withEmail: username,
                                andPassword: password) { (status, error) in
                                    if let error = error {
                                        print("Error logging in: \(error)")
                                        AuthService().registerUser(with: username,
                                                                   and: password) { (status, error) in
                                                                    if let error = error {
                                                                        print(error)
                                                                        return
                                                                    } else {
                                                                        self.dismiss(animated: true)
                                                                    }
                                                                    return
                                        }
                                        if status != false {
                                            self.dismiss(animated: true,
                                                         completion: nil)
                                        }
                                    }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    func setupViews() {
        emailField.layer.cornerRadius = 8
        passwordField.layer.cornerRadius = 8
        loginButton.layer.cornerRadius = 8
        loginButton.layer.shadowColor = UIColor.tertiary.cgColor
        loginButton.layer.shadowOffset = CGSize(width: -2,
                                                height: 2)
    }
}
