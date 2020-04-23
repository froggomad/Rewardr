//
//  Reward.swift
//  Rewardr
//
//  Created by Kenny on 4/19/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

typealias RewardRep = [UUID:Reward]

struct Reward: Codable, Equatable {
    let id: UUID
    let name: String
    var points: Int

    static func == (lhs: Reward, rhs: Reward) -> Bool {
        lhs.id == rhs.id
    }
}
