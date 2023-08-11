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
    
    let dictionary = loadDictionary()
    let dictionaryPuzzleWord = loadDictionaryPuzzleWord()
    
    private static func loadDictionaryPuzzleWord() -> Set<String> {
        if let path = Bundle.main.path(forResource: "singular", ofType: ""),
            let contents = try? String(contentsOfFile: path) {
            let words = contents.components(separatedBy: .newlines)
                .compactMap { $0.lowercased() }
            return Set(words)
        }
        return Set()
    }
    
    func checkWord(wordToCheck: String) -> Bool {
        let cleanWord = wordToCheck.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanWord.isEmpty && dictionary.contains(cleanWord) {
            return true
        } else {
            return false
        }
    }
    
    private static func loadDictionary() -> Set<String> {
        if let path = Bundle.main.path(forResource: "ru_RU", ofType: ""),
            let contents = try? String(contentsOfFile: path) {
            let words = contents.components(separatedBy: .newlines)
                .compactMap { $0.lowercased() }
            return Set(words)
        }
        return Set()
    }
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 9 {
            newLenght = 5
        } else {
            newLenght += 1
        }
        return String(newLenght)
    }
    
    func choiceRandomWord(size: Int) -> String {
        var wordArray = [String]()
        for i in dictionaryPuzzleWord {
            if i.count == size {
                wordArray.append(i)
            }
        }
        var randomWord = wordArray[Int.random(in: 0...wordArray.count - 1)]
        return randomWord.count == size ? randomWord : choiceRandomWord(size: size)
        
    }
    
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
        var userLetterCounts = [Character: Int]()
        
        // Подсчитываем количество упоминаний каждой буквы в слове пользователя
        for letter in newUser {
            userLetterCounts[letter, default: 0] += 1
        }
        
        // Проверяем буквы на своем месте (2)
        for (index, letter) in userWord.enumerated() {
            if puzzleWord[puzzleWord.index(puzzleWord.startIndex, offsetBy: index)] == letter {
                result[index] = 2
                let index = newUser.index(newUser.startIndex, offsetBy: index)
                newUser.replaceSubrange(index..<newUser.index(after: index), with: " ")
                usedIndexes.insert(index.encodedOffset)
                userLetterCounts[letter, default: 0] -= 1
            }
        }
        
        // Проверяем буквы не на своем месте (1)
        for (index, letter) in newUser.enumerated() {
            if result[index] == 0 {
                // Ищем первое упоминание буквы в загаданном слове
                if let puzzleIndex = puzzleWord.firstIndex(of: letter)?.encodedOffset, !usedIndexes.contains(puzzleIndex) {
                    result[index] = 1
                    usedIndexes.insert(puzzleIndex)
                    userLetterCounts[letter, default: 0] -= 1
                    
                    // Если буква уже использовалась, учитываем ее только один раз
                    if userLetterCounts[letter, default: 0] == 0 {
                        userLetterCounts.removeValue(forKey: letter)
                    }
                }
            }
        }
        
        return result
    }
}
