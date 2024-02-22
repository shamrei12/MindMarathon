//
//  GameTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.06.23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    var mainView = UIView()
    var stackView = UIStackView()
    var gameName = UILabel()
    var gameResult = UILabel()
    var gameCount = UILabel()
    var gameTimer = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func createUI() {
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 10
        mainView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        mainView.layer.shadowColor = UIColor.label.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.shadowRadius = 3
        mainView.tintColor = UIColor.label
        self.addSubview(mainView)
        mainView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalToSuperview().inset(10)
        }
        
        gameName.textColor = UIColor.black
        gameName.font = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        gameName.textAlignment = .center
        gameName.numberOfLines = 0 
        self.addSubview(gameName)
        
        gameResult.textColor = UIColor.black
        gameResult.font = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        gameResult.textAlignment = .center
        self.addSubview(gameResult)
        
        gameCount.textColor = UIColor.black
        gameCount.font = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        gameCount.textAlignment = .center
        self.addSubview(gameCount)
        
        gameTimer.textColor = UIColor.black
        gameTimer.font = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        gameTimer.textAlignment = .center
        gameTimer.numberOfLines = 0
        self.addSubview(gameTimer)
        
        stackView.addArrangedSubview(gameName)
        stackView.addArrangedSubview(gameResult)
        stackView.addArrangedSubview(gameCount)
        stackView.addArrangedSubview(gameTimer)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(mainView).inset(5)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
