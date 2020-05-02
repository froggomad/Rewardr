//
//  ChildCollectionViewCell.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ChildCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var choresLabel: UILabel!

    //MARK: - properties -
    static let reuseIdentifier = "ChildCell"
    var child: Child? {
        didSet {
            updateViews()
        }
    }

    //MARK: - View Lifecycle -
    private func updateViews() {
        let padding:CGFloat = 8
        let innerView = UIView()
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 8
        innerView.layer.borderColor = UIColor.black.cgColor
        innerView.layer.borderWidth = 1
        contentView.addSubview(innerView)
        NSLayoutConstraint.activate([
            innerView.widthAnchor.constraint(equalToConstant: bounds.width - padding*2),
            innerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            innerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            innerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            innerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])

        guard let child = child else { return }
        nameLabel.text = child.displayName
        pointsLabel.text = "Points: \(child.points)"
        //setup the chores label if the child has chores
        guard let chores = child.chores?.sorted(by: {$0.dueDate < $1.dueDate }) else { return }
        let names = chores.map { $0.name }
        choresLabel.text = "Chores:\n\(names.joined(separator: ", "))"
    }
}
