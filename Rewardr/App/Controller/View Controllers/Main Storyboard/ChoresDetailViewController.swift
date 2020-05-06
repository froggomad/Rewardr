//
//  ChoresDetailViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

protocol ChildReceiver: class {
    func receiveChild(_ child: Child)
}

class ChoresDetailViewController: UIViewController, UIPickerViewDelegate, OnboardingChoreDelegate {
    //MARK: - Properties -
    var chore: Chore?
    var child: Child?
    var controller: ParentController?
    weak var delegate: ChildReceiver?
    private var edited = false //one way switch

    //MARK: - Outlets -
    @IBOutlet private weak var choreNameTextField: UITextField!
    @IBOutlet private weak var pointsChooser: UIPickerView!
    @IBOutlet private weak var rewardsPicker: UIPickerView!
    @IBOutlet private weak var frequencyPicker: UIPickerView!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    @IBOutlet private weak var completeButton: UIButton!

    //MARK: - Actions -
    @IBAction private func addRewardButtonTapped(_ sender: UIButton) {

    }

    //MARK: - Save/Update -
    @objc func saveChore() {
        guard let name = choreNameTextField.text,
            name != ""
        else { return }
        self.chore = Chore(id: self.chore?.id ?? "",
                           name: name,
                           points: pointsChooser.selectedRow(inComponent: 0),
                           frequency: Chore.Frequency(rawValue: frequencyPicker.selectedRow(inComponent: 0)) ?? .daily,
                           dueDate: dueDatePicker.date,
                           complete: chore?.complete ?? false,
                           image: nil)
        //updates in willDisappear
        if controller?.childDelegate == nil {
            let onboardingStoryboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "main"))
            guard let addChildVC = onboardingStoryboard.instantiateViewController(identifier: "ChildrenList") as? ChildrenCollectionViewController else { return }
            let navC = UINavigationController(rootViewController: addChildVC)
            navC.modalPresentationStyle = .fullScreen
            navC.navigationBar.backItem?.backBarButtonItem = nil
            self.present(navC, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - Editing -
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.hidesBackButton = editing
        if editing {
            edited = true
        } else {
            saveChore()
        }
        choreNameTextField.isUserInteractionEnabled = editing
        choreNameTextField.becomeFirstResponder()
        pointsChooser.isUserInteractionEnabled = editing
        frequencyPicker.isUserInteractionEnabled = editing
        dueDatePicker.isUserInteractionEnabled = editing
    }

    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        if chore != nil {
            navigationItem.rightBarButtonItem = editButtonItem
        } else {
            edited = true
            choreNameTextField.becomeFirstResponder()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChore))
        }
        choreNameTextField.text = chore?.name
        choreNameTextField.isUserInteractionEnabled = edited

        // MARK: Picker Views
        pointsChooser.delegate = self
        pointsChooser.dataSource = self
        pointsChooser.isUserInteractionEnabled = edited
        pointsChooser.selectRow(chore?.points ?? 1,
                                inComponent: 0,
                                animated: true)

        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        frequencyPicker.isUserInteractionEnabled = edited
        frequencyPicker.selectRow(chore?.frequency.rawValue ?? 0,
                                  inComponent: 0,
                                  animated: true)

        dueDatePicker.minimumDate = Date()
        dueDatePicker.isUserInteractionEnabled = edited
        dueDatePicker.setDate(chore?.dueDate ?? Date(),
                              animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if edited {
            guard let chore = chore,
                var child = child
            else { return }
            controller?.updateChore(chore: chore, child: &child)
            delegate?.receiveChild(child)
        }
    }


     // MARK: - Navigation -
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {



     }
}

//MARK: - PickerView DataSource -
extension ChoresDetailViewController: UIPickerViewDataSource {
    private func pointsPickerDataSource() -> [Int] {
        let num = 50
        var numArr: [Int] = []
        for i in 1...num {
            numArr.append(i)
        }
        return numArr
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case pointsChooser:
            return 1
        case frequencyPicker:
            return 1
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pointsChooser:
            return pointsPickerDataSource().count
        case frequencyPicker:
            return Chore.Frequency.allCases.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pointsChooser:
            return "\(pointsPickerDataSource()[row])"
        case frequencyPicker:
            return "\(Chore.Frequency.allCases[row])"
        default:
            return nil
        }
    }
}
