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
        case .bullCowGame:
            let result = level + step > 6 ? 2 : level + step
            return result
        case .slovusGame:
            let result = level + step > 9 ? 5 : level + step
            return result
        case .floodFillGame:
            if level == 25 {
                return 5
            } else if level + step > 20 {
                return 25
            } else {
                return level + step
            }
        case .binarioGame:
            let result = level + step > 8 ? 4 : level + step
            return result
        }
    }
}
