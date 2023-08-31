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
    func getLevel(currentLevel: Int, step: Int, curentGame: CurentGame) -> Int {
        switch curentGame {
        case .bullCowGame: return currentLevel + step > 6 ? 2 : currentLevel + step
        case .slovusGame: return currentLevel + step > 9 ? 5 : currentLevel + step
        case .floodFillGame: return currentLevel == 25 ? 5 : currentLevel + step
        case .binarioGame: return currentLevel + step > 8 ? 4 : currentLevel + step
        }
    }
}
