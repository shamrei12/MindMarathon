//
//  SlovusViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import Foundation

class SlovusViewModel {
    static var shared: SlovusViewModel = {
        let instance = SlovusViewModel()
        return instance
    }()
    
    let words = [ "карта", "кухня", "книга", "кровь", "кость", "город", "фильм", "птица", "комод",  "цветы", "чайка", "талия",  "леска", "ручка", "крыша", "дурак", "трава", "глаза", "крест", "свеча", "купец",  "полет", "рюмка", "робот", "котел", "шахта", "берег", "барон", "шпага", "голос", "сосна", "трава", "камин", "пряжа", "шарик", "мужик", "сапог", "факел", "музей", "труба", "сетка", "ворот"]
    
    func choiceRandomWord() -> String {
        return words[Int.random(in: 0..<words.count)]
    }
    
    func checkResult(puzzleWord: String, userWord: String) -> [Int] {
        var resultMass = [0, 0, 0, 0, 0]
        if userWord == puzzleWord {
            return [2, 2, 2, 2, 2]
        } else {
            for (i, valueUser) in userWord.enumerated() {
                for (j, valuePuzzle) in puzzleWord.enumerated() {
                    if i == j && valuePuzzle == valueUser {
                        resultMass[i] = 2
                        break
                    } else if i != j && valuePuzzle == valueUser && resultMass[i] == 0 {
                        resultMass[i] = 1
                        break
                    }
                    
                }
            }
            return resultMass
        }
    }
}
