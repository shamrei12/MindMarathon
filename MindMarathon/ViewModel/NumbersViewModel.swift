//
//  NumbersViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.09.23.
//

import Foundation

class NumbersViewModel: ObservableObject {
    @Published var isStartGame: Bool = false
    @Published var isFinishGame: Bool = false
    @Published var isDeleteStatus: Bool = false
    @Published var time: Int = 0
    @Published var addCount: Int = 5
    @Published var hintCount = 3
    @Published var numberArray: [(Int, Bool)] = [(Int, Bool)]()
    
    @Published var selectArray: [Int] = [Int]()
    @Published var hintArray: [Int] = [Int]()
    
    func createArray() {
        var array = [(Int, Bool)]()
        for _ in 0..<27 {
            array.append((Int.random(in: 1...9), true))
        }
        numberArray = array
    }
    
    func clearArray() {
        numberArray.removeAll()
    }

    func gameMove(index: Int) {
        
        guard !selectArray.contains(index) else {
            selectArray.removeAll()
            return
        }
        
        guard numberArray[index].1 else {
            return
        }

        if hintArray.contains(index) {
            hintArray = hintArray.filter { $0 != index }
        }
        
        selectArray.append(index)
        
        if selectArray.count == 2 {
            let firstIndex = min(selectArray[0], selectArray[1])
            let secondIndex = max(selectArray[0], selectArray[1])
            if  checkConditions(firstIndex: firstIndex, secondIndex: secondIndex) {
                numberArray[selectArray[0]].1 = false
                numberArray[selectArray[1]].1 = false
                selectArray.removeAll()
                hintArray.removeAll()
                checkFinishGame()
                deletedEmptyRow()
            } else {
                selectArray.removeAll()
            }
            
            if selectArray.count == 3 {
                selectArray.removeAll()
                selectArray.append(index)
            }
        }
    }
    
    func checkConditions(firstIndex: Int, secondIndex: Int) -> Bool {
        return (checkEqualCondition(firstIndex: firstIndex, secondIndex: secondIndex) || checkSumTenCondition(firstIndex: firstIndex, secondIndex: secondIndex)) &&
            (checkNextConditions(firstIndex: firstIndex, secondIndex: secondIndex) ||
            checkUnderCondition(firstIndex: firstIndex, secondIndex: secondIndex) ||
            checkDisableBetwenCondition(firstIndex: firstIndex, secondIndex: secondIndex) ||
            checkDisableUnderCondition(firstIndex: firstIndex, secondIndex: secondIndex) ||
            checkNextDiagonalCondition(firstIndex: firstIndex, secondIndex: secondIndex) ||
            checkDiagonalCondition(firstIndex: firstIndex, secondIndex: secondIndex))
    }

    
    func checkEqualCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        return numberArray[firstIndex].0 == numberArray[secondIndex].0
    }
    
    func checkSumTenCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        return numberArray[firstIndex].0 + numberArray[secondIndex].0 == 10
    }
    
    func checkNextConditions(firstIndex: Int, secondIndex: Int) -> Bool {
        return firstIndex + 1 == secondIndex
    }
    
    func checkUnderCondition (firstIndex: Int, secondIndex: Int) -> Bool {
        return firstIndex + 9 == secondIndex
    }

    // Проверка условий когда между элементами есть неактивные элементы
    func checkDisableBetwenCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        for index in firstIndex + 1..<secondIndex {
            if numberArray[index].1 {
                return false
            }
        }
        return true
    }
    
    // проверка элементов которые находятся друг под другом и между ними есть неактивные элементы
    func checkDisableUnderCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        if (secondIndex - firstIndex) % 9 == 0 {
            for i in stride(from: firstIndex + 9, to: secondIndex, by: 9)  {
                if numberArray[i].1 {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    // проверка элементов по диаоганли на наличие неактивных элементов
    func checkNextDiagonalCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        guard sameDiagonal(firstIndex: firstIndex, secondIndex: secondIndex) else {
            return false
        }
        
        if firstIndex + 10 == secondIndex {
            return true
        } else if firstIndex + 8 == secondIndex {
            return true
        } else {
            return false
        }
    }

    
    func checkDiagonalCondition(firstIndex: Int, secondIndex: Int) -> Bool {
        guard sameDiagonal(firstIndex: firstIndex, secondIndex: secondIndex) else {
            return false
        }
        
        let difference = secondIndex - firstIndex
        if difference % 10 == 0 {
            return getDiagonalElement(firstIndex: firstIndex, secondIndex: secondIndex, step: 10)
        } else if difference % 8 == 0 {
            return getDiagonalElement(firstIndex: firstIndex, secondIndex: secondIndex, step: 8)
        } else {
            return false
        }
    }
    
    func sameDiagonal(firstIndex: Int, secondIndex: Int) -> Bool {
        let (firstX, firstY) = (firstIndex / 9, firstIndex % 9)
        let (secondX, secondY) = (secondIndex / 9, secondIndex % 9)
        return abs(firstX - secondX) == abs(firstY - secondY)
    }
    
    func getDiagonalElement(firstIndex: Int, secondIndex: Int, step: Int) -> Bool {
        var element = firstIndex + step
        while element < secondIndex {
            if numberArray[element].1 {
                return false
            }
            element += step
        }
        return true
    }
    
    func getRangeColumn(min: Int, max: Int) -> [Int] {
        var array = [Int]()
        for i in stride(from: min, to: max, by: 9) {
            array.append(i)
        }
        return array
    }
    
    func addNewDigit() {
        var newMassive: [(Int, Bool)] = [(Int, Bool)]()
        for i in 0..<numberArray.count {
            if numberArray[i].1 {
                newMassive.append((numberArray[i].0, true))
            }
        }
        
        for i in newMassive {
            numberArray.append(i)
        }
    }
    
    func showHintMove() {
        for i in 0..<numberArray.count {
            for j in i + 1..<numberArray.count {
                if numberArray[i].1 && numberArray[j].1 {
                    if checkConditions(firstIndex: i, secondIndex: j) {
                        hintArray.append(i)
                        hintArray.append(j)
                        break
                    }
                }
            }
            if !hintArray.isEmpty {
                break
            }
        }
    }
    
    func deletedEmptyRow() {
        var deleterRanges: [Range<Int>] = [Range<Int>]()
        
        for i in stride(from: 0, to: self.numberArray.count - 1, by: 9) {
            if i + 8 <= self.numberArray.count - 1 {
                let rowRange = Range(i...(i + 8))
                if self.numberArray[rowRange].allSatisfy({ !$0.1 }) {
                    deleterRanges.append(rowRange)
                }
                
            }
        }
        for i in deleterRanges.reversed() {
            numberArray.removeSubrange(i)
        }
    }
    
    func checkFinishGame() {
        let contains = numberArray.contains { $0.1 == true}
        if !contains {
            isFinishGame = true
        }
    }
}
