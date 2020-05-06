//
//  OnboardingAddChildViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingAddChildViewController: UIViewController {
    @IBOutlet weak private var firstNameTextfield: UITextField!
    @IBOutlet weak private var lastNameTextfield: UITextField!
    @IBOutlet weak private var nickNameTextfield: UITextField!
    @IBOutlet weak private var usernameTextfield: UITextField!
    @IBOutlet weak private var passwordTextfield: UITextField!
    @IBOutlet weak private var formView: UIView!
    @IBOutlet weak private var addChildButton: LoginButton!

    @IBAction func addChildTapped(_ sender: Any) {
        var fields: [String] = []
        if firstNameTextfield.text == nil || firstNameTextfield.text == "" {
            fields.append("First Name")
        }
        if let lastName = lastNameTextfield.text,
            lastName == ""  {
            fields.append("Last Name")
        }
        if let username = usernameTextfield.text,
            username == "" {
            fields.append("Username")
        }
        if let password = passwordTextfield.text,
            password == "" {
            fields.append("Password")
        }
        if !fields.isEmpty {
            let str = fields.joined(separator: ", ")
            Alert.show(title: "Please Enter Your Child's:",
                       message: str,
                       vc: self)
        } else {
            guard let firstName = firstNameTextfield?.text, firstName != "",
                let lastName = lastNameTextfield?.text, lastName != "",
                let username = usernameTextfield?.text, username != "",
                let password = passwordTextfield?.text, password != "",
                let activeParent = activeParent
                else { return }
            let displayName = nickNameTextfield?.text
            DatabaseService().createChild(for: activeParent,
                                          with: firstName,
                                          lastName: lastName,
                                          displayName: displayName,
                                          chores: [],
                                          username: username,
                                          password: password) { child in
                                            self.child = child
                                            self.performSegue(withIdentifier: self.segueID, sender: nil)
            }

        }
    }

    //MARK: - Propeties -
    private let segueID = "OnboardingChoreSegue"
    private var child: Child?
    var activeParent: Parent?

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextfield.setCornerRadius()
        lastNameTextfield.setCornerRadius()
        nickNameTextfield.setCornerRadius()
        usernameTextfield.setCornerRadius()
        passwordTextfield.setCornerRadius()
        formView.setCornerRadius()
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard let destination = segue.destination as? ContainerViewController else { return }
            destination.child = child
        }
    }

}
