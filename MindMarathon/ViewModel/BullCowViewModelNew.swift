//
//  BullCowViewModelNew.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.02.24.
//

import Foundation

class BullCowViewModelNew: ObservableObject {
    
    @Published var isStartGame: Bool = false
    @Published var isFinishGame: Bool = false
    @Published var sizeDigits: Int = 0
    @Published var historyGame = [BullCowProtocol]()
    private var bull: Int = 0
    private var cow: Int = 0
    
    func statusStarGame() {
        isStartGame = true
        isFinishGame = false
        historyGame.removeAll()
    }
    
    func statusFinishGame() {
        isStartGame = false
        isFinishGame = true
    }
    
    func nextuserMove(userDigits: String, secretDiggits: [Int]) {
        let userMove = createMassive(userDiggit: userDigits)
        comparisonNumber(userMove, secretDiggits)
        historyGame.append(BullCowModel(size: sizeDigits, bull: bull, cow: cow, userStep: userDigits))
        if historyGame.last?.bull == sizeDigits {
            statusFinishGame()
        }

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
    
    func comparisonNumber(_ userDigg: [Int], _ computerNumber: [Int]) {
        var bullCount = 0
        var cowCount = 0
        for i in 0..<userDigg.count {
            for j in 0..<computerNumber.count {
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
    
    func finishGame() {
        historyGame.removeAll()
        bull = 0
        cow = 0
    }
}
