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
    
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 6 {
            newLenght = 2
        } else {
            newLenght += 1
        }
        return String(newLenght)
    }
    
    
    func makeNumber(maxLenght: Int) -> [Int] { //создание числа для игры
        var result: [Int] = []
        while result.count < maxLenght {
            var randomDiggit = Int.random(in: 0...9)
            if !result.contains(randomDiggit) {
                result.append(randomDiggit)
            }
        }
        print(result)
        return result
    }
    
    func  comparisonNumber(_ userDigg: [Int],_ computerNumber: [Int]) -> (Int, Int) {
           var bull = 0
           var cow = 0
           for (i, _) in userDigg.enumerated() {
               for (j, _) in computerNumber.enumerated() {
                   if userDigg[i] == computerNumber[j] && i == j {
                       bull += 1
                   }
                   else if userDigg[i] == computerNumber[j] && i != j {
                       cow += 1
                   }
               }
           }
           return (bull,cow)
       }
    
    func createMassive(userDiggit: String) -> [Int] {
        var result = [Int]()
        for i in userDiggit {
            result.append(Int(String(i))!)
        }
        return result
    }
}
