//
//  Child.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

//MARK: - Dummy Data -
let BELLA = Child(id: "47EDA7AC-26A9-426E-999E-D6410B6C8660",
                  parent: KENNY,
                  firstName: "Isabella",
                  lastName: "Dubroff",
                  displayName: "Bella",
                  chores: CHORES)

//MARK: - Codable -
struct ChildRep: Codable {
    let children: [String:Child]
}

//MARK: - Object -
struct Child: Codable, Equatable {
    let id: String
    let parentId: String
    let parentName: String
    var firstName: String
    var lastName: String
    var displayName: String?
    var chores: [Chore]?
    var points: Int

    func childDetails() -> [String:Any] {
        var choreDictArray: [[String:Any]]? {
            guard let chores = self.chores else { return nil }
            var choreDictArray: [Dictionary<String,Any>] = []
            for chore in chores {
                choreDictArray.append(chore.choreDict())
            }
            return choreDictArray
        }

        return [
            "parentId": parentId,
            "parentName": parentName,
            "firstName": firstName,
            "lastName": lastName,
            "displayName": displayName ?? "",
            "chores": choreDictArray ?? [],
            "points": points
            ] as [String : Any]
    }

    // MARK: Equatable
    static func == (lhs: Child, rhs: Child) -> Bool {
        lhs.id == rhs.id
    }

    init(id: String,
         parent: Parent,
         firstName: String,
         lastName: String,
         displayName: String,
         chores: [Chore] = [],
         points: Int = 0) {

        self.id = id
        parentId = parent.id
        parentName = parent.nickName ?? "\(parent.firstName) \(parent.lastName)"
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.chores = chores
        self.points = points
    }
}
