//
//  ChildDetailViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ChildDetailViewController: UIViewController {
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties -
    let addChoreSegue = "AddChoreSegue"
    let editChoreSegue = "EditChoreSegue"
    let choreCellId = "ChoreCellId"
    var controller: ParentController?
    var child: Child? {
        didSet {
            updateViews()
        }
    }

    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }

    private func updateViews() {
        guard let child = child else {
            fatalError("failed to inject child dependency in \(#file)")
            //return
        }
        guard isViewLoaded else { return }
        title = child.displayName
        tableView.reloadData()
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChoresDetailViewController else { return }
        destination.child = child
        destination.controller = controller
        if segue.identifier == editChoreSegue {
            guard let index = tableView.indexPathForSelectedRow?.row,
                let child = child
            else { return }
            let chore = child.chores?[index]
            destination.chore = chore
        }
    }

}

//MARK: - TableView DataSource -
extension ChildDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        child?.chores?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let child = child,
            let chores = child.chores
        else { return UITableViewCell() }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let cell = tableView.dequeueReusableCell(withIdentifier: choreCellId, for: indexPath)
        cell.textLabel?.text = chores[indexPath.row].name
        cell.detailTextLabel?.text = dateFormatter.string(from: chores[indexPath.row].dueDate) 

        return cell
    }
}

extension ChildDetailViewController: UITableViewDelegate {

}
