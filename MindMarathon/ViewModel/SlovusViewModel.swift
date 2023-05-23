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
    
    
    func replaceLetter(userString: String) -> String {
        var newWord = String()
        for i in userString {
            if !newWord.contains(i) {
                newWord.append(i)
            }
        }
        return newWord
    }

    func checkResult(puzzleWord: String, userWord: String) -> [Int] {
        var resultMass = Array(repeating: 0, count: puzzleWord.count)
        let newUser = replaceLetter(userString: userWord)
        print(puzzleWord)
        if userWord == puzzleWord {
            return Array(repeating: 2, count: puzzleWord.count)
        } else {
            for (i, valueUser) in newUser.enumerated() {
                for (j, valuePuzzle) in puzzleWord.enumerated() {
                    if i == j && valuePuzzle == valueUser {
                        resultMass[j] = 2
                        break
                    } else if i != j && valuePuzzle == valueUser && resultMass[j] == 0 {
                        resultMass[i] = 1
                        break
                    }
                }
            }
        }
        return resultMass
    }
}
