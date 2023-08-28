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
    func getLevel(curentLevel: Int, step: Int, curentGame: CurentGame) -> Int {
        switch curentGame {
        case .bullCowGame: return curentLevel + step > 6 ? 2 : curentLevel + step
        case .slovusGame: return curentLevel + step > 9 ? 5 : curentLevel + step
        case .floodFillGame: return curentLevel == 25 ? 5 : curentLevel + step > 20 ? 25 : curentLevel + step
        case .binarioGame: return curentLevel + step > 8 ? 4 : curentLevel + step
        }
    }
}
