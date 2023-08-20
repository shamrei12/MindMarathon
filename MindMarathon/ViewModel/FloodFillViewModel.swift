//
//  FloodFillViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.05.23.
//

import Foundation

class FloodFillViewModel {
    var countStep = 0
    
    func gameResult() -> String {
        return "\(countStep)"
    }
    
    func restartGame() {
        countStep = 0
    }
}
