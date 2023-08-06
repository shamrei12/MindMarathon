//
//  BullCowViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import Foundation

class BullCowViewModel {
    static var shared: BullCowViewModel = {
        let instance = BullCowViewModel()
        return instance
    }()
    
    var isStartGame = false
    var isContinueGame = false
    var stepList = [BullCowProtocol]()
    var countStep = 0
    var bull = 0
    var cow = 0
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        if newLenght == 6 {
            newLenght = 2
        } else {
            newLenght += 1
        }
        return String(newLenght)
    }
    
    func makeNumber(maxLenght: Int) -> [Int] { // создание числа для игры
        var result: [Int] = []
        while result.count < maxLenght {
            let randomDiggit = Int.random(in: 0...9)
            if !result.contains(randomDiggit) {
                result.append(randomDiggit)
            }
        }
        return result
    }
    
    func  comparisonNumber(_ userDigg: [Int], _ computerNumber: [Int]) {
        var bullCount = 0
        var cowCount = 0
        for (i, _) in userDigg.enumerated() {
            for (j, _) in computerNumber.enumerated() {
                if userDigg[i] == computerNumber[j] && i == j {
                    bullCount += 1
                } else if userDigg[i] == computerNumber[j] && i != j {
                    cowCount += 1
                }
            }
        }
        bull = bullCount
        cow = cowCount
    }
    
    func checkRepeatDiggits(userDiggit: String) -> Bool {
        let numbers = createMassive(userDiggit: userDiggit)
        let uniqueNumbers = Set(numbers)
        
        if numbers.count != uniqueNumbers.count {
            return false
        } else {
            return true
        }
    }
    
    func createMassive(userDiggit: String) -> [Int] {
        var result = [Int]()
        for i in userDiggit {
            result.append(Int(String(i))!)
        }
        return result
    }
    
    func restartGame() {
        bull = 0
        cow = 0
        stepList.removeAll()
        countStep = 0
        isStartGame = false
        isContinueGame = false
    }
}
