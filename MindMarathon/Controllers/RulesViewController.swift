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

        // Do any additional setup after loading the view.
    }

    func rulesGame(numberGame: Int) {
        let gameRules = UILabel()
        let rulesLabel = UILabel()
        
        switch numberGame {
        case 1:
            gameRules.text = BullCowViewModel.shared.getRulesGame()
        case 2:
            gameRules.text = SlovusViewModel.shared.getRulesGame()
        default:
            print("error")
        }
        rulesLabel.text = "Правила игры"
        rulesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        rulesLabel.textAlignment = .center
        rulesLabel.textColor = .label
        view.addSubview(rulesLabel)
        
        
        gameRules.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        gameRules.textAlignment = .left
        gameRules.numberOfLines = 0
        gameRules.textColor = .label
        view.addSubview(gameRules)
        
        rulesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        gameRules.snp.makeConstraints { maker in
            maker.top.equalTo(rulesLabel).inset(40)
            maker.left.right.bottom.equalToSuperview().inset(20)
        }
        
        
        
    }

}
