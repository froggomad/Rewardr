//
//  ContainerViewController.swift
//  Rewardr
//
//  Created by Kenny on 5/3/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

protocol OnboardingChoreDelegate: class {
    func saveChore()
}

class ContainerViewController: UIViewController {
    //MARK: - Properties -
    private let choreEmbedSegueID = "ChoreEmbedSegue"
    private var choreDetailVC: OnboardingChoreDelegate?
    var child: Child?

    @IBAction func saveChoreTapped (_ sender: UIButton) {
        choreDetailVC?.saveChore()
    }

    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == choreEmbedSegueID {
            guard let destination = segue.destination as? ChoresDetailViewController else { return }
            choreDetailVC = destination
            destination.controller = ParentController(delegate: nil)
            destination.child = child
        }

    }


}
