//
//  SudokuViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.03.24.
//

import Foundation

class SudokuViewModel: ObservableObject {
    var countStep = 0
    @Published var isStartGame: Bool = false
    @Published var isFinishGame: Bool = false
    @Published var field: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @Published var isActivefield: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    @Published var time = 0
    @Published var selectedElement: (Int?, Int?) = (nil, nil)
    
    func makeSudokuField() {
        var array = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        for _ in 0..<10 {
              let row = Int.random(in: 0..<9)
              let col = Int.random(in: 0..<9)
              let num = Int.random(in: 1...9)
              
              // Убедимся, что мы не заменяем уже существующее число
              if array[row][col] == 0 {
                  array[row][col] = num
              }
          }
        
        field = array
        print(array)
    }
}
