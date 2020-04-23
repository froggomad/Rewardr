//
//  ChildrenCollectionViewController.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ChildrenCollectionViewController: UICollectionViewController {
    //MARK: - Properties -
    private let childDetailSegue = "ChildDetailSegue"
    lazy var parentController = ParentController(delegate: self)
    var myChildren: [Child] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        parentController.downloadChildren(from: KENNY) {
            KENNY.children = self.myChildren
        }
    }

    //MARK: - Navigation -
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == childDetailSegue {
            guard let destination = segue.destination as? ChildDetailViewController,
                let childIndex = collectionView.indexPathsForSelectedItems?.first?.item else { return }
            destination.child = parentController.myChildren[childIndex]
            guard let childReceiverDestination = destination as? ChoreReceiver else { return }
            destination.controller = ParentController(delegate: childReceiverDestination)
        }
     }

    //MARK: - UICollectionViewDataSource -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentController.myChildren.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.reuseIdentifier, for: indexPath) as? ChildCollectionViewCell else { fatalError("couldn't dequeue cell of type ChildCollectionViewCell with identifier: \(ChildCollectionViewCell.reuseIdentifier)") }
        let child = myChildren[indexPath.item]
        cell.child = child
        return cell
    }

}

extension ChildrenCollectionViewController: ChildReceiver {
    func receive(children: [Child]) {
        self.myChildren = children
    }
}

//MARK: - UICollectionViewFlowDelegateLayout -
extension ChildrenCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40
        return CGSize(width: width, height: collectionView.bounds.height / 3)
    }
}
