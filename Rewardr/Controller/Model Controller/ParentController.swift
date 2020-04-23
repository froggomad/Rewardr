//
//  ParentController.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

protocol ChildReceiver: class {
    var myChildren: [Child] { get set }
    func receive(children: [Child])
}

protocol ChoreReceiver: class {
    var myChild: Child? { get set }
    func receive(chores: [Chore])
}

class ParentController {
    weak var childDelegate: ChildReceiver?
    weak var choreDelegate: ChoreReceiver?

    let databaseService = DatabaseService()

    var myChildren: [Child] = [] {
        didSet {
            childDelegate?.receive(children: myChildren)
        }
    }

    var myChild: Child? {
        didSet {
            guard let chores = myChild?.chores else { return }
            choreDelegate?.receive(chores: chores)
        }
    }

    init(delegate: ChildReceiver) {
        self.childDelegate = delegate
    }

    init(delegate: ChoreReceiver) {
        self.choreDelegate = delegate
    }

    func downloadChildren(from parent: Parent, complete: @escaping () -> Void = { })  {
        databaseService.downloadChildren(from: parent) { children in
            guard let children = children else { return }
            DispatchQueue.main.async {
                self.myChildren = children
                complete()
            }
        }
    }

    func updateChild(child: Child) {
        databaseService.update(child: child)
    }
}
