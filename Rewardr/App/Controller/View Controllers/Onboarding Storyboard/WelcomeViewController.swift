//
//  WelcomeViewController.swift
//  Rewardr
//
//  Created by Kenny on 5/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var nickNameTextField: UITextField!
    @IBOutlet weak private var addParentButton: LoginButton!

    //MARK: - IBAction -
    @IBAction private func addParentTapped(_ sender: LoginButton) {
        var fields: [String] = []
        if firstNameTextField.text == nil || firstNameTextField.text == "" {
            fields.append("First Name")
        }
        if lastNameTextField.text == nil || lastNameTextField.text == "" {
            fields.append("Last Name")
        }
        if !fields.isEmpty {
            let str = fields.joined(separator: "\n")
            Alert.show(title: "Please Enter Your:",
                       message: str,
                       vc: self)
        } else {
            guard let firstName = firstNameTextField.text,
                firstName != "",
                let lastName = lastNameTextField.text,
                lastName != ""
                else { return }
            let knownName = nickNameTextField.text ?? firstName
            let parent = Parent(id: AuthService.currentUserId ?? "",
                                  nickName: knownName, firstName: firstName, lastName: lastName, children: [], rewards: [])
            DatabaseService().updateParent(parent: parent)
            activeParent = parent
            performSegue(withIdentifier: addChildSegueID, sender: self)
        }

    }

    //MARK: - Properties -
    private var activeParent: Parent?
    private let addChildSegueID = "addChildSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addChildSegueID {
            
            guard let destination = segue.destination as? OnboardingAddChildViewController else { return }
            destination.activeParent = activeParent
        }
    }
}
