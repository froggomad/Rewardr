//
//  Parent.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

//MARK: - Dummy Data -
var KENNY = Parent(id: UUID(uuidString: "3431B764-9AC7-4911-A345-F95635654546")!,
firstName: "Kenny",
lastName: "Dubroff",
children: [],
rewards: [])
//MARK: - Codable -
typealias ParentRep = [UUID:Parent]

//MARK: - Object -
struct Parent: Codable, Equatable {
    let id: UUID
    let firstName: String
    let lastName: String
    var children: [Child]
    var rewards: [Reward]
    // MARK: Equatable
    static func == (lhs: Parent, rhs: Parent) -> Bool {
        lhs.id == rhs.id
    }
}
