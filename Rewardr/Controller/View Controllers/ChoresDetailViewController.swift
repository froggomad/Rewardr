//
//  ChoresDetailViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ChoresDetailViewController: UIViewController, UIPickerViewDelegate {
    //MARK: - Properties -
    var chore: Chore?
    var child: Child?
    var controller: ParentController?
    var edited = false //one way switch

    //MARK: - Outlets -
    @IBOutlet private weak var choreNameTextField: UITextField!
    @IBOutlet private weak var pointsChooser: UIPickerView!
    @IBOutlet private weak var rewardsPicker: UIPickerView!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    @IBOutlet private weak var completeButton: UIButton!

    //MARK: - Actions -
    @IBAction func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addRewardButtonTapped(_ sender: UIButton) {

    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {

    }

    //MARK: - Save/Update -
    @objc func saveChore() {
        guard let name = choreNameTextField.text,
            name != ""
        else { return }
        self.chore = Chore(name: name,
                           points: pointsChooser.selectedRow(inComponent: 0),
                           dueDate: dueDatePicker.date)
        
    }

    //MARK: - Editing -
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.hidesBackButton = editing
        if editing { edited = true }
        choreNameTextField.isUserInteractionEnabled = editing
        pointsChooser.isUserInteractionEnabled = editing
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChore))
        }
        choreNameTextField.text = chore?.name

        // MARK: Picker Views
        pointsChooser.delegate = self
        pointsChooser.dataSource = self
        pointsChooser.isUserInteractionEnabled = edited
        pointsChooser.selectRow(chore?.points ?? 1,
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
            guard let chore = chore else { return }
            self.child?.chores?.append(chore)
            guard let child = child else { return }
            DatabaseService().update(child: child)
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
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pointsChooser:
            return pointsPickerDataSource().count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pointsChooser:
            return "\(pointsPickerDataSource()[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        default:
            break
        }
    }
}
