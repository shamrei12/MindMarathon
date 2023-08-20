//
//  RulesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.05.23.
//

import UIKit
import SnapKit

class RulesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "viewColor")
    }

    func rulesGame(numberGame: Int) {
        let gameRules = UILabel()
        let rulesLabel = UILabel()
        
        switch numberGame {
        case 1: gameRules.text = GetRules.bullCow.rules
        case 2: gameRules.text = GetRules.slovus.rules
        case 3: gameRules.text = GetRules.floodFill.rules
        case 4: gameRules.text = GetRules.ticTacToe.rules
        case 5: gameRules.text = GetRules.binario.rules
        default: print("error")
        }
        
        rulesLabel.text = "Правила игры".localized()
        rulesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        rulesLabel.textAlignment = .center
        rulesLabel.textColor = .label
        view.addSubview(rulesLabel)
        
        gameRules.font = UIFont(name: "HelveticaNeue-Light", size: 35.0)
        gameRules.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        gameRules.minimumScaleFactor = 0.2
        gameRules.textAlignment = .left
        gameRules.numberOfLines = 0
        gameRules.textColor = .label
        view.addSubview(gameRules)
        
        rulesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        gameRules.snp.makeConstraints { maker in
            maker.top.equalTo(rulesLabel.snp.bottom).inset(-10)
            maker.left.right.bottom.equalToSuperview().inset(20)
        }
    }
}
