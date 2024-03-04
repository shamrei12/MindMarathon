//
//  SlovusViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import Foundation

class SlovusViewModel: ObservableObject {
    let dictionary = loadDictionary()
    let dictionaryPuzzleWord = loadDictionaryPuzzleWord()
    @Published var isstartGame: Bool = false
    @Published var isFinishGame: Bool = false
    @Published var isCorrectWord: Bool = true
    @Published var step: Int = .zero
    @Published var historyUserMove: [String] = ["", "", "", "", "", ""]
    @Published var historyAnswerMove: [([Int], [Character: Int])] = [([Int], [Character: Int])]()

    func userMove(puzzleWord: String, userWord: String) {
        historyAnswerMove.append(checkWord(puzzleWord: puzzleWord, userWord: userWord))
    }
    
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
    
    func choiceRandomWord(size: Int) -> String {
        var wordArray = [String]()
        for i in dictionaryPuzzleWord where i.count == size {
                wordArray.append(i)
        }
        let randomWord = wordArray[Int.random(in: 0...wordArray.count - 1)]
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

    func checkWord(puzzleWord: String, userWord: String) -> ([Int], [Character: Int]) {

        var result = Array(repeating: 0, count: puzzleWord.count)
        var newUser = userWord
        var usedIndexes = Set<Int>()
        var userLetterCounts = [Character: Int]()
        var puzzleLetterCounts = [Character: Int]()
        var arrayOfKeyboardLetterColors = [Character: Int]()
        
        for letter in puzzleWord {
            puzzleLetterCounts[letter, default: 0] += 1
        }
        // Подсчитываем количество упоминаний каждой буквы в слове пользователя
        for letter in newUser {
            userLetterCounts[letter, default: 0] += 1
            arrayOfKeyboardLetterColors[letter] = 0
        }
        
        // Проверяем буквы на своем месте (2)
        for (index, letter) in userWord.enumerated() {
            if puzzleWord[puzzleWord.index(puzzleWord.startIndex, offsetBy: index)] == letter {
                result[index] = 2
                arrayOfKeyboardLetterColors[letter] = 2
                let index = newUser.index(newUser.startIndex, offsetBy: index)
                newUser.replaceSubrange(index..<newUser.index(after: index), with: " ")
                usedIndexes.insert(index.encodedOffset)
//                userLetterCounts[letter, default: 0] -= 1
                puzzleLetterCounts[letter, default: 0] -= 1
            }
        }
        // Проверяем буквы не на своем месте (1)
        for (index, letter) in newUser.enumerated() where result[index] == 0 {
                // Ищем первое упоминание буквы в загаданном слове
                if let puzzleIndex = puzzleWord.firstIndex(of: letter)?.encodedOffset, !usedIndexes.contains(puzzleIndex) {

                    // Если буква уже использовалась, учитываем ее только один раз
                    if puzzleLetterCounts[letter, default: 0] == 0 {
//                        userLetterCounts.removeValue(forKey: letter)
                        continue
                    } else {
                        result[index] = 1
                        if arrayOfKeyboardLetterColors[letter] != 2 {
                            arrayOfKeyboardLetterColors[letter] = 1
                        }
                        usedIndexes.insert(puzzleIndex)
                        userLetterCounts[letter, default: 0] -= 1
                        puzzleLetterCounts[letter, default: 0] -= 1
                    }
                }
        }
        return (result, arrayOfKeyboardLetterColors)
    }
}
