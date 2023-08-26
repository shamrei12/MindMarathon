//
//  GameLevelChange.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 16.08.23.
//

import Foundation

enum CurentGame {
    case bullCowGame
    case slovusGame
    case floodFillGame
    case binarioGame
}

struct GameLevel {
    func getLevel(level: Int, step: Int, curentGame: CurentGame) -> Int {
        switch curentGame {
        case .bullCowGame: return level + step > 6 ? 2 : level + step
        case .slovusGame: return level + step > 9 ? 5 : level + step
        case .floodFillGame: return level == 25 ? 5 : level + step > 20 ? 25 : level + step
        case .binarioGame: return level + step > 8 ? 4 : level + step
        }
    }
}
