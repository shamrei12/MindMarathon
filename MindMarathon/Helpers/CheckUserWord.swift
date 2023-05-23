//
//  CheckUserWord.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 21.05.23.
//

import Foundation
import UIKit

class CheckUserWord {
    
    static var shared: CheckUserWord = {
        let instance = CheckUserWord()
        return instance
    }()
    
    let dictionary = loadDictionary()
    
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

}




