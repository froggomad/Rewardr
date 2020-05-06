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
        guard let id = parentDict["id"] as? String,
            let firstName = parentDict["firstName"] as? String,
            let lastName = parentDict["lastName"] as? String
        else { return nil }
        self.id = id
        self.nickName = parentDict["nickname"] as? String ?? nil
        self.firstName = firstName
        self.lastName = lastName
        #warning("TODO: Fix this:")
        self.children = []
        self.rewards = []
    }
    
    // MARK: Equatable
    static func == (lhs: Parent, rhs: Parent) -> Bool {
        lhs.id == rhs.id
    }
}
