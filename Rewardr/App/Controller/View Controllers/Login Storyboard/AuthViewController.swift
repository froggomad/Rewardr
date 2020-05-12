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

    //MARK: - Properties -
    weak var delegate: ChildrenCollectionViewController?

    //MARK: - Login -
    @IBAction private func login() {
        //Check for empty fields and alert user
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
        // MARK: Attempt login
        guard let username = emailField.text,
            !username.isEmpty,
            let password = passwordField.text,
            !password.isEmpty
            else { return }
        AuthService()
            .loginUser(
                withEmail: username,
                andPassword: password
            ) { (loginStatus, error, isChild, dictionary) in
                //No errors - login
                if loginStatus != false {
                    guard let dictionary = dictionary else { return }
                    switch isChild {
                    case .child:
                        guard let child = Child(childDict: dictionary) else {
                            print("failed to create Child from dictionary")
                            return
                        }
                        AuthService.activeChild = child
                    case .parent:
                        guard let parent = Parent(parentDict: dictionary) else {
                            print("failed to create Parent from dictionary")
                            return
                        }
                        AuthService.activeParent = parent
                    case .none:
                        print("userType is nil")
                    }
//                    if let navC = self.presentingViewController as? UINavigationController {
//                        print("navigation controller")
//                        if let presentingVC = navC.viewControllers[0] as? ChildrenCollectionViewController {
//                            print("children controller")
//                            presentingVC.updateViews()
//                        }
//                    }
                    self.dismiss(
                        animated: true,
                        completion: {
                            self.delegate?.updateViews()
                        }
                    )
                    return
                }
                // MARK: Handle errors
                if let error = error as NSError? {
                    if error.code == 17011 {
                        Alert.withYesNoPrompt(
                            // MARK: Alert new user
                            title: "User not found",
                            message: "Register new Parent?",
                            vc: self
                        ) { alertStatus in
                            // MARK: Yes, register new user
                            if alertStatus {
                                AuthService()
                                    .registerUser(
                                        with: username,
                                        and: password
                                    ) { (registrationStatus, error, _) in
                                        if let error = error {
                                            Alert.show(
                                                title: "Error registering new user",
                                                message: error.localizedDescription, vc: self
                                            )
                                            return
                                        } else {
                                            // MARK: Present onboarding flow
                                            if registrationStatus {
                                                let onboardingStoryboard = UIStoryboard(
                                                    name: "Onboarding",
                                                    bundle: Bundle(identifier: "main")
                                                )
                                                guard let addChildVC = onboardingStoryboard.instantiateViewController(
                                                    identifier: "WelcomeParent"
                                                    )
                                                    as? WelcomeViewController else { return }
                                                let navC = UINavigationController(
                                                    rootViewController: addChildVC
                                                )
                                                navC.modalPresentationStyle = .fullScreen
                                                self.present(
                                                    navC,
                                                    animated: true
                                                )
                                            }
                                        }
                                        return
                                }
                            }
                        }
                    }
                    if loginStatus != false {
                        self.dismiss(
                            animated: true,
                            completion: nil
                        )
                    }
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
