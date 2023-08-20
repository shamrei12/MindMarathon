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
            if level + step > 6 {
                return 2
            } else {
                return level + step
            }
        case .slovusGame:
            if level + step > 8 {
                return 5
            } else {
                return level + step
            }
        case .floodFillGame:
            if level + step > 20 {
                return 25
            } else if level == 25 {
                return 5
            } else {
                return level + step
            }
        case .binarioGame:
            if level + step > 8 {
                return 4
            } else {
                return level + step
            }
        }
    }
}
