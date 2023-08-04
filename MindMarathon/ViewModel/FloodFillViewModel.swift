//
//  FloodFillViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.05.23.
//

import Foundation

class FloodFillViewModel {
//    static var shared: FloodFillViewModel = {
//        let instance = FloodFillViewModel()
//        return instance
//    }()
    
    var countStep: Int
    
    init(countStep: Int) {
        self.countStep = countStep
    }

    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 20 {
            newLenght += 5
        } else if newLenght == 25 {
            newLenght = 5
        } else {
            newLenght += 1
        }
        return String(newLenght)
    }
    
    func gameResult() -> String {
        return "\(countStep)"
    }
}
