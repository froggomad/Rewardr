//
//  Chore.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
//MARK: - Dummy Data -
let CHORES: [Chore] = [
    Chore(id: "1",
          name: "Test",
          points: 10,
          frequency: .weekly,
          dueDate: Date(),
          image: URL(string: "http://www.google.com")!),
    Chore(id: "2",
          name: "Test2",
          points: 20,
          frequency: .daily,
          dueDate: Date(),
          image: URL(string: "http://www.google.com")!)
]
//MARK: - Object -
struct Chore: Codable, Equatable {
    enum Frequency: Int, Codable, CaseIterable {
        case daily
        case weekly
    }

    var id: String
    let name: String
    var points: Int
    var frequency: Frequency
    var dueDate: Date
    var complete: Bool = false
    var image: URL? = nil
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case points
        case frequency
        case dueDate = "date"
        case image
    }
    // MARK: Equatable
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        lhs.id == rhs.id
    }
}
