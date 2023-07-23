//
//  TicTacToeViewModel.swift
//  MindMarathon
//
//  Created by Nikita  on 6/15/23.
//

import Foundation

class TicTacToeViewModel {
    
    static var shared: TicTacToeViewModel = {
        let instance = TicTacToeViewModel()
        return instance
    }()
    
    func getRulesGame() -> String {
        let gameRules = """
        
           1. На доске есть квадрат из 3x3 клеток.
           2. Игрок играет против компьютера. Игрок играет крестиками, компьютер - ноликами.
           3. Цель игры - собрать три своих символа в ряд (по горизонтали, вертикали или диагонали).
           4. Игроки ходят по очереди, ставя свой символ на пустую клетку.
           5. Игрок может ставить свой символ только на пустую клетку.
           6. Игра заканчивается, когда один из игроков собрал три своих символа в ряд или когда все клетки заполнены, и ни один игрок не собрал три своих символа в ряд.
           7. Если игрок собрал три своих символа в ряд, то он побеждает, если же ни один игрок не собрал три своих символа в ряд, то игра заканчивается вничью.
        """
        
        return gameRules
    }
    
    // Функция для определения хода компьютера
    func computerMove(board: [[String]]) -> (Int, Int)? {
        // Проверяем, есть ли у компьютера возможность выиграть
        if let position = findWinningMove(board: board, symbol: "O") {
            return position
        }
        
        // Проверяем, есть ли у пользователя возможность выиграть и блокируем его ход, если есть
        if let position = findWinningMove(board: board, symbol: "X") {
            return position
        }
        
        // Выбираем случайную пустую клетку
        let emptyPositions = findEmptyPositions(board: board)
        if !emptyPositions.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(emptyPositions.count)))
            return emptyPositions[randomIndex]
        }
        
        // Если все клетки заняты и никто не выиграл, возвращаем nil, что означает ничью
        return nil
    }

    // Функция для поиска пустых клеток на доске
    func findEmptyPositions(board: [[String]]) -> [(Int, Int)] {
        var emptyPositions = [(Int, Int)]()
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col] == "" {
                    emptyPositions.append((row, col))
                }
            }
        }
        return emptyPositions
    }
    
    // Функция для поиска выигрышного хода
    func findWinningMove(board: [[String]], symbol: String) -> (Int, Int)? {
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col] == "" {
                    // Проверяем, выиграет ли игрок, если он поставит свой символ на эту клетку
                    var newBoard = board
                    newBoard[row][col] = symbol
                    if checkForWinner(board: newBoard, symbol: symbol) {
                        return (row, col)
                    }
                }
            }
        }
        return nil
    }
    
    func checkForWinner(board: [[String]], symbol: String) -> Bool {
        // Проверяем горизонтали
        for row in 0..<board.count {
            if board[row][0] == symbol && board[row][1] == symbol && board[row][2] == symbol {
                return true
            }
        }
        
        // Проверяем вертикали
        for col in 0..<board[0].count {
            if board[0][col] == symbol && board[1][col] == symbol && board[2][col] == symbol {
                return true
            }
        }
        
        // Проверяем диагонали
        if board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol {
            return true
        }
        if board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol {
            return true
        }
        
        // Если нет победителя, возвращаем false
        return false
    }
    
}
