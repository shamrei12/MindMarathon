//
//  ZeroOneViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 2.07.23.
//

import Foundation

class BinarioViewModel {
    
    static var shared: BinarioViewModel = {
        let instance = BinarioViewModel()
        return instance
    }()
    
    var isStartGame = false
    var isContinueGame = false
    var size = 4
    
    func getRulesGame() -> String {
        let gameRules = """
        1. В сетке есть клетки разных цветов: красные, синие и пустые клетки.
        2. Цель игры - заполнить всю сетку так, чтобы выполнились следующие условия:
            - Ни одна строка или столбец не должны содержать повторяющиеся цвета.
            - Каждая строка и столбец должны содержать одинаковое количество красных и синих клеток.
        3. Игрок может заполнять сетку, нажимая на клетки, чтобы изменить их цвет.
        4. Если все правила выполняются и сетка полностью заполнена, игрок побеждает.
"""
        return gameRules
    }
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 8 {
            newLenght = 4
        } else {
            newLenght += 2
        }
        return String(newLenght)
    }
    
    //функция случайного числа
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
