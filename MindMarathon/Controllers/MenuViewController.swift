//
//  MenuViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.viewColor.color
        creatingUI()
    }
    
    func creatingUI() {
        let labelStackView = UIStackView()
        let firstLabel = UILabel()
        let secondLabel = UILabel()
        
        firstLabel.text = "MIND"
        firstLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 95.0)
        
        secondLabel.text = "MARATHON"
        secondLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 43.0)
        
        labelStackView.addArrangedSubview(firstLabel)
        labelStackView.addArrangedSubview(secondLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fill
        labelStackView.spacing = 2
        view.addSubview(labelStackView)
        
        let startMarathon = UIButton()
        startMarathon.setTitle("Список игр".localized(), for: .normal)
        startMarathon.setTitleColor(.label, for: .normal)
        startMarathon.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        startMarathon.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        startMarathon.titleLabel!.minimumScaleFactor = 0.1
        startMarathon.backgroundColor = UIColor(named: "gameElementColor")
        
        startMarathon.layer.cornerRadius = 10
        startMarathon.addTarget(self, action: #selector(listGameTapped), for: .touchUpInside)
        view.addSubview(startMarathon)
        
        let whiteBoard = UIButton()
        whiteBoard.setTitle("Статистика игр".localized(), for: .normal)
        whiteBoard.setTitleColor(.label, for: .normal)
        whiteBoard.backgroundColor = UIColor(named: "gameElementColor")
        whiteBoard.layer.cornerRadius = 10
        whiteBoard.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        whiteBoard.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        whiteBoard.titleLabel!.minimumScaleFactor = 0.1
        whiteBoard.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        view.addSubview(whiteBoard)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(startMarathon)
        buttonStackView.addArrangedSubview(whiteBoard)
        view.addSubview(buttonStackView)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            maker.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.90)
            maker.height.equalToSuperview().multipliedBy(0.20)
        }
    }
    
    @objc
    func listGameTapped() {
        let listGame = ListGamesViewController()
        let navigationController = UINavigationController(rootViewController: listGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func whiteBoardTapped() {
        let whiteBoard = WhiteboardViewController()
        let navigationController = UINavigationController(rootViewController: whiteBoard)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
