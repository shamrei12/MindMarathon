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
    @Published var isDiactive: [[Bool]] = Array(repeating: Array(repeating: true, count: 9), count: 9)
    
    @Published var time = 0
    @Published var selectedElement: (Int?, Int?) = (nil, nil)
    @Published var uncorrectSelected: (Int?, Int?) = (nil, nil)
    
    func makeSudokuField() {
        var array = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        for _ in 0..<25 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            let num = Int.random(in: 1...9)
            
            if array[row][col] == 0 {
                array[row][col] = num
                self.isDiactive[row][col] = false
            }
            
            if !isValidSudoku(array) {
                array[row][col] = 0
                self.isDiactive[row][col] = true
            }
        }
        self.field = array
    }
    
    func userMove(boxIndex: Int, index: Int, number: Int) {
        field[boxIndex][index] = number
        
        if !isValidSudoku(field) {
            uncorrectSelected.0 = boxIndex
            uncorrectSelected.1 = index
            self.uncorrectSelected = (boxIndex, index)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.uncorrectSelected = (nil, nil)
                self.isActivefield[boxIndex][index] = false
                self.field[boxIndex][index] = 15
            }
        } else {
            isActivefield[boxIndex][index] = false
        }
    }

func isValidSudoku(_ board: [[Int]]) -> Bool {
    for i in 0..<9 {
        var rows = Set<Int>()
        var columns = Set<Int>()
        var cube = Set<Int>()
        
        for j in 0..<9 {
            if board[i][j] != 0 {
                if rows.contains(board[i][j]) { return false }
                rows.insert(board[i][j])
            }
            
            if board[j][i] != 0 {
                if columns.contains(board[j][i]) { return false }
                columns.insert(board[j][i])
            }
            
            let rowIndex = 3 * (j / 3)
            let colIndex = 3 * (i / 3)
            if board[rowIndex + j % 3][colIndex + i % 3] != 0 {
                if cube.contains(board[rowIndex + j % 3][colIndex + i % 3]) { return false }
                cube.insert(board[rowIndex + j % 3][colIndex + i % 3])
            }
        }
    }
    return true
}

}
