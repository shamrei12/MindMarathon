//
//  ZeroOneViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 2.07.23.
//

import UIKit

class BinarioViewModel: ObservableObject {
    
    @Published var isStartGame = false
    @Published var isFinishGame = false
    @Published var showAlert = false
    @Published var size = 4
    @Published var time = 0
    @Published var showLock = false
    @Published var colorMassive: [UIColor] = [UIColor(hex: 0xa2afbe, alpha: 1), UIColor(hex: 0xd74545, alpha: 1), UIColor(hex: 0x567fb5, alpha: 1)]
    @Published var massiveButtons: [[Int]] = [[Int]]()
    @Published var disableButtons: [Int] = [Int]()
    
    func makeLockMassiveButton() {
        disableButtons.removeAll()
        var massive = [[Int]]()
        for _ in 0..<self.size {
            let randomElement = Int.random(in: 0..<self.size)
            var row = [Int]()
            for j in 0..<self.size {
                if j == randomElement {
                    row.append(Int.random(in: 1...2))
                } else {
                    row.append(0)
                }
            }
            disableButtons.append(randomElement)
            massive.append(row)
            row.removeAll()
        }
        massiveButtons = massive
    }
    
    func changeTypeButton(row: Int, column: Int) {
        if !massiveButtons.isEmpty {
           let element = massiveButtons[row][column]
            if element < 2 {
                massiveButtons[row][column] += 1
            } else {
                massiveButtons[row][column] = 0
            }
        }
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
    
    func clearBoard() {
        for i in 0..<size {
            for j in 0..<size {
                if j != disableButtons[i] {
                    massiveButtons[i][j] = 0
                }
            }
        }
    }
    
    func checkResultGame() {
        if uniqueLines(line: massiveButtons) && uniqueRows(mass: massiveButtons) {
            isFinishGame = true
        } else {
            showAlert = true
        }
    }
}
