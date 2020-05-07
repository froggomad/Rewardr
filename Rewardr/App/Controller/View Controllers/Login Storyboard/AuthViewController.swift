//
//  AuthViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AuthViewController: UIViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    @IBOutlet weak private var loginButton: LoginButton!

    //MARK: - Login -
    @IBAction private func login() {
        var fields: [String] = []
        if emailField.text == "" {
            fields.append("Email")
        }
        if passwordField.text == "" {
            fields.append("Password")
        }
        if !fields.isEmpty {
            let fields = fields.joined(separator: ",\n")
            Alert.show(title: "Please Enter Your:", message: fields, vc: self)
        }
        guard let username = emailField.text,
            !username.isEmpty,
            let password = passwordField.text,
            !password.isEmpty
            else { return }
        AuthService().loginUser(withEmail: username,
                                andPassword: password) { (status, error, isChild) in
                                    if let error = error {
                                        print("Error logging in: \(error)")
                                        AuthService().registerUser(with: username,
                                                                   and: password) { (status, error, _) in
                                                                    if let error = error {
                                                                        print(error)
                                                                        return
                                                                    } else {
                                                                        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: Bundle(identifier: "main"))
                                                                        guard let addChildVC = onboardingStoryboard.instantiateViewController(identifier: "WelcomeParent") as? WelcomeViewController else { return }
                                                                        let navC = UINavigationController(rootViewController: addChildVC)
                                                                        navC.modalPresentationStyle = .fullScreen
                                                                        self.present(navC, animated: true)
                                                                    }
                                                                    return
                                        }
                                        if status != false {
                                            self.dismiss(animated: true,
                                                         completion: nil)
                                        }
                                    }
                                    if status != false {
                                        self.dismiss(animated: true,
                                                     completion: nil)
                                    }
        }
    }
    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        guard isViewLoaded else { return }
        emailField.setCornerRadius()
        passwordField.setCornerRadius()
    }

}
