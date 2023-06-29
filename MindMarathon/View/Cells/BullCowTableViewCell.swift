//
//  BullCowTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.06.23.
//

import UIKit

class BullCowTableViewCell: UITableViewCell {
    
    let mainView = UIView()
    let mainStackView = UIStackView()
    let userMoveStackView = UIStackView()
    let resultStepStacvkView = UIStackView()
    var gameData = [BullCowProtocol]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    func createUI() {
        // Создание главного View
        mainView.backgroundColor = UIColor(named: "gameElementColor")
        mainView.layer.cornerRadius = 10
        self.addSubview(mainView)
        
        mainView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(5)
        }
        
        // Создание главного Stackview и двух в него входящих Stackview
        let mainStackView = UIStackView()
        mainStackView.addArrangedSubview(userMoveStackView)
        mainStackView.addArrangedSubview(resultStepStacvkView)
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 10
        mainView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(mainView).inset(5)
            maker.left.right.equalTo(mainView).inset(10)
        }
        
        
        // Создание stack с ответом пользователя
        userMoveStackView.axis = .horizontal
        userMoveStackView.backgroundColor = .clear
        userMoveStackView.distribution = .fillEqually
        userMoveStackView.spacing = 5
        if gameData.first!.size <= 4 {
            let widthConstraint = userMoveStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.6)
            widthConstraint.isActive = true
        } else {
            let widthConstraint = userMoveStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.5)
            widthConstraint.isActive = true
        }
        
       

        
        // Создание stack с ответом алгоритма
        resultStepStacvkView.axis = .horizontal
        resultStepStacvkView.backgroundColor = .clear
        resultStepStacvkView.distribution = .fillEqually
        resultStepStacvkView.spacing = 5
        
        
        
        for view in userMoveStackView.arrangedSubviews {
            userMoveStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        
        for view in resultStepStacvkView.arrangedSubviews {
            resultStepStacvkView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for i in 0..<gameData.first!.size {
            let viewElement = UIView()
            let userDiggitLabel = UILabel()
            viewElement.widthAnchor.constraint(equalToConstant: 5).isActive = true
            viewElement.heightAnchor.constraint(equalToConstant: 5).isActive = true
            viewElement.backgroundColor = .tertiaryLabel
            viewElement.layer.cornerRadius = 10
            userDiggitLabel.text = String(gameData.first!.userStep[i])
            userDiggitLabel.font =  UIFont(name: "HelveticaNeue-Medium", size: 25.0)
            userDiggitLabel.textAlignment = .center
            userDiggitLabel.textColor = .white
            self.addSubview(viewElement)
            self.addSubview(userDiggitLabel)
            userDiggitLabel.snp.makeConstraints { maker in
                maker.left.right.bottom.top.equalTo(viewElement).inset(0)
            }
            userMoveStackView.addArrangedSubview(viewElement)
        }
               
        let bullStackView = UIStackView()
        let cowStackView = UIStackView()
        guard let countCow = gameData.first?.cow, let countBull = gameData.first?.bull else {
            return
        }
//
        if countCow == 0 && countBull == 0 {
            let imageView = UIImageView(image: UIImage(named: "empty"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.snp.makeConstraints { make in
                make.width.equalTo(40)
                make.height.equalTo(40)
            }
            resultStepStacvkView.addArrangedSubview(imageView)
        }
        
        for _ in 0..<countCow {
            let imageView = UIImageView(image: UIImage(named: "cow"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(10)
            }
            mainView.addSubview(imageView)

            resultStepStacvkView.addArrangedSubview(imageView)
        }

        for _ in 0..<countBull {
            let imageView = UIImageView(image: UIImage(named: "bull"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(10)
            }
            mainView.addSubview(imageView)
            resultStepStacvkView.addArrangedSubview(imageView)
        }
    }
    
}
