//
//  ResultAlertView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import Foundation
import UIKit
import SnapKit


class ResultAlertView: UIView {
    
    @IBOutlet weak var buttonTapped: UIButton!
    @IBOutlet weak var textAlert: UILabel!
    
    let descriptionLabel = UILabel()
    let firstLabel = UILabel()
    var delegate: AlertDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createUI()
    }
    
    func createUI() {
        self.backgroundColor = UIColor.systemBackground
        firstLabel.text = "Конец игры"
        firstLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        firstLabel.numberOfLines = 0
        firstLabel.textAlignment = .center
        self.addSubview(firstLabel)
        
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .natural
        self.addSubview(descriptionLabel)
        
        let restartGame = UIButton()
        restartGame.setTitle("Начать сначала", for: .normal)
        restartGame.tintColor = UIColor.label
        restartGame.backgroundColor = UIColor.tertiaryLabel
        restartGame.layer.cornerRadius = 10
        restartGame.addTarget(self, action: #selector(restartGameTapped), for: .touchUpInside)
        self.addSubview(restartGame)
        
        let exitGame = UIButton()
        exitGame.setTitle("Выход в меню", for: .normal)
        exitGame.tintColor = UIColor.label
        exitGame.backgroundColor = UIColor.tertiaryLabel
        exitGame.layer.cornerRadius = 10
        exitGame.addTarget(self, action: #selector(exitGameTapped), for: .touchUpInside)
        
        self.addSubview(exitGame)
        
        firstLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(10)
            maker.left.right.equalTo(self).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(firstLabel).inset(50)
            maker.left.right.equalTo(self).inset(20)
        }
        
        restartGame.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel).inset(70)
            maker.left.right.equalTo(self).inset(10)
        }
        
        exitGame.snp.makeConstraints { maker in
            maker.top.equalTo(restartGame).inset(50)
            maker.left.right.equalTo(self).inset(10)
        }
        
    }
    
    
    @objc func restartGameTapped() {
        delegate.restartGame()
    }
    
    @objc func exitGameTapped() {
        delegate.exitGame()
    }
}
