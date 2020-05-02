//
//  WelcomeViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var nickNameTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func addChildTapped(_ sender: Any) {
        var fields: [String] = []
        if let firstName = firstNameTextfield.text,
            firstName == "" {
            fields.append("First Name")
        }
        if let lastName = lastNameTextfield.text,
            lastName == ""  {
                fields.append("Last Name")
        }
        if let nickname = nickNameTextfield.text,
            nickname == "" {
                fields.append("Nickname")
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
                let displayName = nickNameTextfield?.text, displayName != "",
                let username = usernameTextfield?.text, username != "",
                let password = passwordTextfield?.text, password != ""
            else { return }
            DatabaseService().updateChild(for: KENNY,
                                          with: firstName,
                                          lastName: lastName,
                                          displayName: displayName,
                                          chores: [],
                                          username: username,
                                          password: password)
        }
    }

    private let segueID = "OnboardingChoreSegue"
    private var child: Child?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard let destination = segue.destination as? ChoresDetailViewController else { return }
            destination.child = child
            destination.controller = ParentController(delegate: nil)
        }
    }


}
