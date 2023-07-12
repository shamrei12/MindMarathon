//
//  FloodFillViewModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.05.23.
//

import Foundation

class FloodFillViewModel {
    static var shared: FloodFillViewModel = {
        let instance = FloodFillViewModel()
        return instance
    }()
    
    var countStep = 0
    
    func getRulesGame() -> String {
        let gameRules = """
        1. На доске есть ячейки разных цветов. Цвета могут повторяться.
        
        2. Игрок начинает с верхнего левого угла и прогрессирует построчно, выбирая один из цветных квадратов в нижней части экрана.
                
        3. Когда игрок изменяет текущий цвет области, каждый соседний квадрат того же цвета также изменяет цвет.
        
        4. Цель игры - закрасить все ячейки на доске одним цветом.
        
        5. Игра заканчивается, когда все ячейки на доске станут одного цвета.
        
        6. Игрок должен закрашивать ячейки таким образом, чтобы он мог закрасить все ячейки на доске.
        """
        return gameRules
    }

    
    
    
    func selectMaxLenght(maxLenght: String) -> String {
        var newLenght: Int = Int(maxLenght)!
        
        if newLenght == 20 {
            newLenght = 5
        } else {
            newLenght += 1
        }
        return String(newLenght)
    }
}
