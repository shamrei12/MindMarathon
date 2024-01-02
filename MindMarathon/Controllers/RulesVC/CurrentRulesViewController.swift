//
//  RulesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.05.23.
//

import UIKit
import SnapKit

class CurrentRulesViewController: UIViewController {
    let game: Game
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "viewColor")
        rulesGame()
    }

    func rulesGame() {
        let gameRules = UILabel()
        let rulesLabel = UILabel()
        
        switch game.title {
        case "Быки и Коровы".localize():
            gameRules.text = game.rules
        case "Словус".localize():
            gameRules.text = game.rules
        case "Крестики Нолики".localize():
            gameRules.text = game.rules
        case "Бинарио".localize():
            gameRules.text = game.rules
        case "Заливка".localize():
            gameRules.text = game.rules
        default: gameRules.text = game.rules
        }
        
        rulesLabel.text = "Правила игры".localize()
        rulesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        rulesLabel.textAlignment = .center
        rulesLabel.textColor = .label
        view.addSubview(rulesLabel)
        
        gameRules.font = UIFont(name: "HelveticaNeue-Light", size: 35.0)
        gameRules.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        gameRules.minimumScaleFactor = 0.5
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
            maker.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}