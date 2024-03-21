//
//  FloodFillViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.05.23.
//

import UIKit

class FloodFillViewModel: ObservableObject {
    var countStep = 0
    @Published var sizeField = 5
    @Published var isStartGame: Bool = false
    @Published var isFinishGame: Bool = false
    @Published var field: [[Int]] = [[Int]]()
    @Published var time = 0
    
    var colorMass = [UIColor(hex: 0xdeecf2, alpha: 1), UIColor(hex: 0xeba967, alpha: 1), UIColor(hex: 0xdd6480, alpha: 1), UIColor(hex: 0x7bb39d, alpha: 1), UIColor(hex: 0x5a96c3, alpha: 1), UIColor(hex: 0x2f5f8f, alpha: 1)]

    func makeField(size: Int) {
        var massive = [[Int]]()
        for _ in 0..<size {
            var row = [Int]()
            for _ in 0..<size {
                row.append(Int.random(in: 0..<6))
            }
            massive.append(row)
        }
        self.field = massive
    }
    
    func changeLevel(level: Int) {
        if level + 5 > 20 {
            sizeField = 5
        } else {
            sizeField += 5
        }
    }
    
        func fillCell(row: Int, col: Int, color: Int, currentColor: Int) {
            // Проверяем, что ячейка находится в пределах игрового поля
            guard row >= 0 && row < sizeField && col >= 0 && col < sizeField else {
                return
            }
            // Проверяем, что ячейка еще не закрашена выбранным цветом
            guard field[row][col] != color else {
                return
            }
            // Проверяем, что цвет ячейки совпадает с текущим цветом
            guard field[row][col] == currentColor else {
                return
            }
            
            // Закрашиваем ячейку выбранным цветом
            field[row][col] = color
            
            // Рекурсивно закрашиваем соседние ячейки выбранным цветом
            fillCell(row: row + 1, col: col, color: color, currentColor: currentColor)
            fillCell(row: row - 1, col: col, color: color, currentColor: currentColor)
            fillCell(row: row, col: col + 1, color: color, currentColor: currentColor)
            fillCell(row: row, col: col - 1, color: color, currentColor: currentColor)
        }
    
    func checkFinishGame() -> Bool {
        let mass = field.flatMap {$0}
        return mass.allSatisfy { $0 == mass.first}
    }
    
}
