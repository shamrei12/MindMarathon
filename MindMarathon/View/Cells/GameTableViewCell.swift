//
//  GameTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.06.23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    let mainView = UIView()
    let stackView = UIStackView()
    let gameName = UILabel()
    let gameResult = UILabel()
    let gameCount = UILabel()
    let gameTimer = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        createUI()
    }
    
    func createUI() {
        mainView.layer.cornerRadius = 10
        mainView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.addSubview(mainView)
        mainView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalToSuperview().inset(10)
        }
        
        gameName.textColor = UIColor.black
        gameName.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.addSubview(gameName)
        
        gameResult.textColor = UIColor.black
        gameResult.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.addSubview(gameResult)
        
        gameCount.textColor = UIColor.black
        gameCount.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.addSubview(gameCount)
        
        gameTimer.textColor = UIColor.black
        gameTimer.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.addSubview(gameTimer)
        
        stackView.addArrangedSubview(gameName)
        stackView.addArrangedSubview(gameResult)
        stackView.addArrangedSubview(gameCount)
        stackView.addArrangedSubview(gameTimer)
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
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
