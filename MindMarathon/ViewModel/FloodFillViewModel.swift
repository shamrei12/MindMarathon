//
//  FloodFillViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.05.23.
//

import Foundation

class FloodFillViewModel {
    var countStep = 0
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    func gameResult() -> String {
        return "\(countStep)"
    }
    
    func restartGame() {
        countStep = 0
    }
}
