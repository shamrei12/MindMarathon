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
        self.backgroundColor = .clear
        createUI()
    }
    
    func createUI() {
        let mainView = UIView()
        
        mainView.backgroundColor = .systemBackground
        mainView.layer.cornerRadius = 10
        self.addSubview(mainView)
        
        firstLabel.text = "Конец игры"
        firstLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        firstLabel.numberOfLines = 0
        firstLabel.textAlignment = .center
        self.addSubview(firstLabel)
        
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        self.addSubview(descriptionLabel)
        
        let restartGame = UIButton()
        restartGame.setTitle("Начать сначала", for: .normal)
        restartGame.heightAnchor.constraint(equalToConstant: 60).isActive = true
        restartGame.tintColor = UIColor.label
        restartGame.backgroundColor = UIColor.tertiaryLabel
        restartGame.layer.cornerRadius = 10
        restartGame.addTarget(self, action: #selector(restartGameTapped), for: .touchUpInside)
        self.addSubview(restartGame)
        
        let exitGame = UIButton()
        exitGame.setTitle("Выход в меню", for: .normal)
        exitGame.heightAnchor.constraint(equalToConstant: 60).isActive = true
        exitGame.tintColor = UIColor.label
        exitGame.backgroundColor = UIColor.tertiaryLabel
        exitGame.layer.cornerRadius = 10
        exitGame.addTarget(self, action: #selector(exitGameTapped), for: .touchUpInside)
        self.addSubview(exitGame)
        
        let buttonStackView = UIStackView()
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.axis = .horizontal
        buttonStackView.addArrangedSubview(restartGame)
        buttonStackView.addArrangedSubview(exitGame)
        self.addSubview(buttonStackView)
        
        mainView.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(20)
            maker.bottom.top.equalToSuperview()
        }
        
        firstLabel.snp.makeConstraints { maker in
            maker.top.equalTo(mainView).inset(10)
            maker.left.right.equalTo(mainView).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(firstLabel).inset(50)
            maker.left.right.equalTo(mainView).inset(10)
        }
        
        buttonStackView.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).inset(-10)
            maker.left.right.bottom.equalTo(mainView).inset(20)
        }
    }
    
    @objc func restartGameTapped() {
        delegate.restartGame()
    }
    
    @objc func exitGameTapped() {
        delegate.exitGame()
    }
}
