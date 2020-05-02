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
    let firstName: String
    let lastName: String
    var children: [Child]
    var rewards: [Reward]

    lazy var parentDict: [String:Any] = [
    "firstName":firstName,
    "lastName":lastName,
    "children":children,
    "rewards":rewards
    ]
    // MARK: Equatable
    static func == (lhs: Parent, rhs: Parent) -> Bool {
        lhs.id == rhs.id
    }
}
