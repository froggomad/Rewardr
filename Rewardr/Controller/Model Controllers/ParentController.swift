//
//  ParentController.swift
//  Rewardr
//
//  Created by Kenny on 4/20/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

protocol ChildrenReceiver: class {
    var myChildren: [Child] { get set }
    func receive(children: [Child])
}

class ParentController {
    weak var childDelegate: ChildrenReceiver?

    let databaseService = DatabaseService()

    var myChildren: [Child] = [] {
        didSet {
            childDelegate?.receive(children: myChildren)
        }
    }



    init(delegate: ChildrenReceiver) {
        self.childDelegate = delegate
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

    func updateChild(_ child: Child) {
        databaseService.update(child: child)
    }

    func updateChore(chore: Chore, child: inout Child) {
        if child.chores == nil {
            child.chores = [chore]
            updateChild(child)
            return
        }
        if let index = child.chores?.firstIndex(of: chore) {
            child.chores?[index] = chore
        } else {
            child.chores?.append(chore)
        }
        updateChild(child)
    }

    func deleteChore(chore: Chore, child: inout Child) {
        guard let index = child.chores?.firstIndex(of: chore) else { return }
        child.chores?.remove(at: index)
        updateChild(child)
    }
}
