//
//  Chore.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

let CHORES: [Chore] = [
    Chore(name: "Test",
          points: 10,
          dueDate: Date(),
          image: URL(string: "http://www.google.com")!),
    Chore(name: "Test2",
    points: 20,
    dueDate: Date(),
    image: URL(string: "http://www.google.com")!)
]

typealias ChoreRep = [UUID:Chore]

struct Chore: Codable, Equatable {
    let id: UUID = UUID()
    let name: String
    var points: Int
    var dueDate: Date
    var complete: Bool = false
    var image: URL? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case points
        case dueDate = "date"
        case image
    }

    static func == (lhs: Chore, rhs: Chore) -> Bool {
        lhs.id == rhs.id
    }
}
