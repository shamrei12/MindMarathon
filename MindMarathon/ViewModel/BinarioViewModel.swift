//
//  ZeroOneViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 2.07.23.
//

import Foundation

class BinarioViewModel {
    
    var isStartGame = false
    var isContinueGame = false
    var size = 4
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    
    // функция случайного числа
    func makeRandomDiggit(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    func uniqueLines(line: [[Int]]) -> Bool {
        for i in 0..<size {
            if !equalCountOfOnesAndTwos(array: line[i]) {
                return false
            }
        }
        return true
    }
    
    func uniqueRows(mass: [[Int]]) -> Bool {
        var newMass = [[Int]]()
        
        for i in 0..<size {
            var newLine = [Int]()
            for j in 0..<size {
                newLine.append(mass[j][i])
            }
            newMass.append(newLine)
        }
        return uniqueLines(line: newMass)
    }
    
    func equalCountOfOnesAndTwos(array: [Int]) -> Bool {
        let onesCount = array.reduce(0) { $1 == 1 ? $0 + 1 : $0 }
        let twosCount = array.reduce(0) { $1 == 2 ? $0 + 1 : $0 }
        
        return onesCount == twosCount
    }
    
    func checkForZero(array: [[Int]]) -> Bool {
        return array.flatMap { $0 }.contains(0)
    }
    
}
