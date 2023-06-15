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
}
