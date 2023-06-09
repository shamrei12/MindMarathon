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
    
    
    func getRulesGame() -> String {
        let gameRules = """
        1. Вы выбираете количество цифр в загаданном числе и нажимаете кнопку "Play". Игру можно поставить на паузу.
        
        2. Вам предстоит угадать загаданное компьютером число. Число может начинаться с нуля.
        
        3. Вы делаете попытку, вводя число.
        
        4. Компьютер сообщает, сколько цифр в вашей попытке совпадают с загаданным числом и стоят на том же месте (такие цифры называются "быками"), а также сколько цифр совпадают с загаданным числом, но стоят на другом месте (такие цифры называются "коровами").
        
        5. Вы используете эти данные, чтобы сделать следующую попытку, и так до тех пор, пока число не будет угадано.
        
        6. Игра продолжается, пока вы не угадаете загаданное число.
        
        7. Вы можете начать новую игру после окончания предыдущей.
        """
        return gameRules
    }
    
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
            let randomDiggit = Int.random(in: 0...9)
            if !result.contains(randomDiggit) {
                result.append(randomDiggit)
            }
        }
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
