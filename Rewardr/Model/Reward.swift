//
//  Reward.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
//MARK: - Codable -
typealias RewardRep = [UUID:Reward]

//MARK: - Object -
struct Reward: Codable, Equatable {
    let id: UUID
    let name: String
    var points: Int
    // MARK: Equatable
    static func == (lhs: Reward, rhs: Reward) -> Bool {
        lhs.id == rhs.id
    }
}
