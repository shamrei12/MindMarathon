//
//  BullCowTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.06.23.
//

import UIKit

class BullCowTableViewCell: UITableViewCell {
    
    var mainView = UIView()
    let mainStackView = UIStackView()
    let userMoveStackView = UIStackView()
    let resultStepStacvkView = UIStackView()
    let imageStackView = UIStackView()
    let numberStackView = UIStackView()
    var gameData = [BullCowProtocol]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.isSelected = false
    }
    
    func clearView() {
        for view in userMoveStackView.arrangedSubviews {
            userMoveStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        mainView.removeFromSuperview()
    }
    
    func createView() {
        
        // Создание главного View
        mainView.backgroundColor = UIColor(named: "gameElementColor")
        mainView.layer.cornerRadius = 10
        self.addSubview(mainView)
        
        mainView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(5)
        }
    }
    
    func createMainStackView() {
        // Создание главного Stackview и двух в него входящих Stackview
        for view in mainStackView.arrangedSubviews {
            imageStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        mainStackView.addArrangedSubview(userMoveStackView)
        mainStackView.addArrangedSubview(resultStepStacvkView)
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 5
        mainView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(mainView).inset(5)
            maker.left.right.equalTo(mainView).inset(10)
        }
    }
    
    func createUserMoveStackView() {
        // Создание stack с ответом пользователя
        userMoveStackView.axis = .horizontal
        userMoveStackView.backgroundColor = .clear
        userMoveStackView.distribution = .fillEqually
        userMoveStackView.spacing = 5
        let widthConstraint = userMoveStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.7)
        widthConstraint.isActive = true
    }
    
    func createResultStackView() {
        // Создание stack с ответом алгоритма
        resultStepStacvkView.axis = .vertical
        resultStepStacvkView.backgroundColor = .clear
        resultStepStacvkView.distribution = .fillEqually
        resultStepStacvkView.spacing = 5
    }
    
    func makeUserMove() {
        for i in 0..<gameData.first!.size {
            let viewElement = UIView()
            let userDiggitLabel = UILabel()
            viewElement.backgroundColor = .tertiaryLabel
            viewElement.layer.cornerRadius = 10
            userDiggitLabel.text = String(gameData.first!.userStep[i])
            userDiggitLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 30.0)
            userDiggitLabel.textAlignment = .center
            userDiggitLabel.textColor = .white
            mainView.addSubview(viewElement)
            viewElement.addSubview(userDiggitLabel)
            userDiggitLabel.snp.makeConstraints { maker in
                maker.left.right.bottom.top.equalTo(viewElement).inset(0)
            }
            userMoveStackView.addArrangedSubview(viewElement)
        }
    }
    
    func createUI() {
        clearView()
        createView()
        createMainStackView()
        createUserMoveStackView()
        createResultStackView()
        makeUserMove()
        createImageResult()
        createLabelResult()
    }
    
    func createImageResult() {
        for view in imageStackView.arrangedSubviews {
            imageStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        imageStackView.distribution = .fill
        imageStackView.axis = .horizontal
        imageStackView.spacing = 15
        mainView.addSubview(imageStackView)
        
        let cowImage = UIImageView(image: UIImage(named: "cow"))
        cowImage.translatesAutoresizingMaskIntoConstraints = false
        cowImage.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        mainView.addSubview(cowImage)
        imageStackView.addArrangedSubview(cowImage)
        
        let bullImage = UIImageView(image: UIImage(named: "bull"))
        bullImage.translatesAutoresizingMaskIntoConstraints = false
        bullImage.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        mainView.addSubview(bullImage)
        imageStackView.addArrangedSubview(bullImage)
        resultStepStacvkView.addArrangedSubview(imageStackView)
    }
    
    func createLabelResult() {
        for view in numberStackView.arrangedSubviews {
            numberStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        numberStackView.distribution = .fillEqually
        numberStackView.axis = .horizontal
        numberStackView.spacing = 20
        mainView.addSubview(numberStackView)
        
        let cowLabel = UILabel()
        cowLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        cowLabel.textAlignment = .center
        cowLabel.text = "\(gameData.first!.cow)"
        self.addSubview(cowLabel)
        numberStackView.addArrangedSubview(cowLabel)
        
        let bullLabel = UILabel()
        bullLabel.text = "\(gameData.first!.bull)"
        bullLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        bullLabel.textAlignment = .center
        self.addSubview(bullLabel)
        numberStackView.addArrangedSubview(bullLabel)
        resultStepStacvkView.addArrangedSubview(numberStackView)
    }
}
