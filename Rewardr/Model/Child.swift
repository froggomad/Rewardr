//
//  Child.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

let BELLA = Child(id: UUID(uuidString: "47EDA7AC-26A9-426E-999E-D6410B6C8660")!,
                  parent: KENNY,
                  firstName: "Isabella",
                  lastName: "Dubroff",
                  displayName: "Bella",
                  chores: CHORES)


struct ChildRep: Codable {
    let children: [String:Child]
}

struct Child: Codable, Equatable {
    let id: UUID
    let parentId: UUID
    let parentName: String
    var firstName: String
    var lastName: String
    var displayName: String
    var chores: [Chore]?
    var points: Int

    static func == (lhs: Child, rhs: Child) -> Bool {
        lhs.id == rhs.id
    }

    init(id: UUID = UUID(),
         parent: Parent,
         firstName: String,
         lastName: String,
         displayName: String,
         chores: [Chore] = [],
         points: Int = 0) {

        self.id = id
        parentId = parent.id
        parentName = "\(parent.firstName) \(parent.lastName)"
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.chores = chores
        self.points = points
    }
}
