//
//  ZeroOneViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 2.07.23.
//

import Foundation

class ZeroOneViewModel {
    
    static var shared: ZeroOneViewModel = {
        let instance = ZeroOneViewModel()
        return instance
    }()
    
    var isStartGame = false
    var isContinueGame = false
    
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 8 {
            newLenght = 4
        } else {
            newLenght += 2
        }
        return String(newLenght)
    }
}
