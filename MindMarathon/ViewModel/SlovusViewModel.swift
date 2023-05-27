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
    
    func getRulesGame() -> String {
        let gameRules = """
        1. Вы должны угадать загаданное компьютером слово. Слово может содержать повторяющиеся буквы. Вы делаете попытку, вводя слово.
        
        2. Компьютер проверяет каждую букву в вашей попытке и выделяет ее цветом:
        - Если буква выделена зеленым, то это значит, что буква есть в слове и стоит на своем месте.
        - Если буква выделена желтым, то это значит, что буква есть в слове, но не на своем месте.
        
        3. Вы получаете обратную связь от компьютера и используете эту информацию, чтобы сделать следующую попытку.
        
        4. Вы можете сделать до 6 попыток, чтобы угадать слово.
        
        5. Если вы угадали слово за меньшее количество попыток, то вы победили.
        
        6. Если вы не угадали слово за 6 попыток, то игра завершается.
        
        7. Вы можете начать новую игру после окончания предыдущей.
        
        """
        return gameRules
    }
    
    let words = [ "карта", "кухня", "книга", "кровь", "кость", "город", "фильм", "птица", "комод",  "цветы", "чайка", "талия",  "леска", "ручка", "крыша", "дурак", "трава", "глаза", "крест", "свеча", "купец",  "полет", "рюмка", "робот", "котел", "шахта", "берег", "барон", "шпага", "голос", "сосна", "трава", "камин", "пряжа", "шарик", "мужик", "сапог", "факел", "музей", "труба", "сетка", "ворот"]
    
    func choiceRandomWord() -> String {
        return words[Int.random(in: 0..<words.count)]
    }
    
    //
    func replaceLetter(userString: String) -> String {
        var newWord = String()
        for i in userString {
            if !newWord.contains(i) {
                newWord.append(i)
            } else {
                newWord.append(" ")
            }
        }
        return newWord
    }

    func checkWord(puzzleWord: String, userWord: String) -> [Int] {
        var result = Array(repeating: 0, count: puzzleWord.count)
        var newUser = userWord
        var usedIndexes = Set<Int>()
        
        // Проверяем буквы на своем месте (2)
        for (index, letter) in userWord.enumerated() {
            if puzzleWord[puzzleWord.index(puzzleWord.startIndex, offsetBy: index)] == letter {
                result[index] = 2
                let index = newUser.index(newUser.startIndex, offsetBy: index)
                newUser.replaceSubrange(index..<newUser.index(after: index), with: " ")
                usedIndexes.insert(index.encodedOffset)
            }
        }
        
        // Проверяем буквы не на своем месте (1)
        for (index, letter) in newUser.enumerated() {
            if result[index] == 0 {
                for (puzzleIndex, puzzleLetter) in puzzleWord.enumerated() {
                    if puzzleIndex != index && puzzleLetter == letter && !usedIndexes.contains(puzzleIndex) {
                        result[index] = 1
                        usedIndexes.insert(puzzleIndex)
                        break
                    }
                }
            }
        }
        
        return result
    }
}

