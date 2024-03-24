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
        var countElement: Int = 40
        
        fillBoard(&array)
        print(isValidSudoku(array))

        for i in 0..<100 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if array[row][col] != 0  {
                array[row][col] = 0
                isDiactive[row][col] = true
                countElement -= 1
            }
            if countElement == 0 {
                break
            }
        }
        field = array
        print(array)
    }
    
    func fillBoard(_ board: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == 0 {
                    let nums = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
                    
                    for num in nums {
                        if canPlace(num: num, at: row, col: col, in: board) {
                            board[row][col] = num
                            isDiactive[row][col] = false
                            
                            if fillBoard(&board) {
                                return true
                            }
                            
                            board[row][col] = 0
                        }
                    }
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    func canPlace(num: Int, at row: Int, col: Int, in board: [[Int]]) -> Bool {
        for x in 0..<9 {
            if board[row][x] == num || board[x][col] == num {
                return false
            }
        }
        
        let startRow = row - row % 3
        let startCol = col - col % 3
        
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i + startRow][j + startCol] == num {
                    return false
                }
            }
        }
        
        return true
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
                DispatchQueue.main.sync {
                    self.field[boxIndex][index] = 0
                }
            }
        } else {
            isActivefield[boxIndex][index] = false
            checkFinishGame()
        }
        
        
    }
    
    func isValidSudoku(_ board: [[Int]]) -> Bool {
        for i in 0..<9 {
            var rows = Set<Int>()
            var columns = Set<Int>()
            var cube = Set<Int>()
            
            for j in 0..<9 {
                if board[i][j] != 0 {
                    if rows.contains(board[i][j]) {
                        return false
                    }
                    rows.insert(board[i][j])
                }
                
                if board[j][i] != 0 {
                    if columns.contains(board[j][i]) {
                        return false
                    }
                    columns.insert(board[j][i])
                }
                
                let rowIndex = 3 * (i / 3) + j / 3
                let colIndex = 3 * (i % 3) + j % 3
                
                if board[rowIndex][colIndex] != 0 {
                    if cube.contains(board[rowIndex][colIndex]) {
                        return false
                    }
                    cube.insert(board[rowIndex][colIndex])
                }
            }
        }
        
        return true
    }
    
    func checkFinishGame() {
        let flatMap = field.flatMap { $0 }
        if flatMap.contains(0) {
            isFinishGame = false
        } else {
            isFinishGame = true
        }
    }
    
    func resetField() {
        field = field.map { _ in Array(repeating: 0, count: 9)}
        isActivefield = Array(repeating: Array(repeating: false, count: 9), count: 9)
        isDiactive =  Array(repeating: Array(repeating: true, count: 9), count: 9)
        
        time = 0
        selectedElement = (nil, nil)
        uncorrectSelected = (nil, nil)
    }
    
    func clearElementField() {
        guard let row = selectedElement.0, let column = selectedElement.1 else {
            return
        }
        
        field[row][column] = 0
        isActivefield[row][column] = false
        selectedElement = (nil, nil)
    }
    
}
