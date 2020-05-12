//
//  Parent.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

//MARK: - Dummy Data -
var KENNY = Parent(id: "mZ1800hIqUdxxRptguah7kbxwez1",
firstName: "Kenny",
lastName: "Dubroff",
children: [],
rewards: [])
//MARK: - Codable -
typealias ParentRep = [UUID:Parent]

//MARK: - Object -
struct Parent: Codable, Equatable {
    let id: String
    var nickName: String?
    let firstName: String
    let lastName: String
    var children: [Child]
    var rewards: [Reward]
    lazy var knownName: String = nickName ?? firstName

    lazy var parentDict: [String:Any] = [
    "firstName":firstName,
    "lastName":lastName,
    "nickName":nickName as Any,
    "children":children,
    "rewards":rewards
    ]

    init(id: String,
    nickName: String? = nil,
    firstName: String,
    lastName: String,
    children: [Child]? = nil,
    rewards: [Reward]? = nil) {
        self.id = id
        self.nickName = nickName
        self.firstName = firstName
        self.lastName = lastName
        self.children = children ?? []
        self.rewards = rewards ?? []

    }

    init?(parentDict: [String:Any]) {
        guard let id = parentDict.keys.first,
            let dictionary = parentDict.values.first as? [String:Any],
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String
        else { return nil }

        self.id = id
        self.nickName = dictionary["nickname"] as? String ?? nil
        self.firstName = firstName
        self.lastName = lastName
        //handle children
        guard let childArray = dictionary["children"] as? [String:Any] else {
            self.children = []
            self.rewards = []
            return
        }

        func appendChildren() -> [Child] {
            var children = [String:Child]()
            for (id, child) in childArray {
                children[id] = Child(childDict: [id:child])
            }
            //remove nil values, childDict init is failable
            return children.compactMap { $1 }
        }
        self.children = appendChildren()

        #warning("TODO: Fix this after implementing rewards:")
        self.rewards = []
    }
    
    // MARK: Equatable
    static func == (lhs: Parent, rhs: Parent) -> Bool {
        lhs.id == rhs.id
    }
}
