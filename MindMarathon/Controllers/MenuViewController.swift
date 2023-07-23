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
        creatingUI()
        self.view.backgroundColor = UIColor(named: "viewColor")
    }
    
    func creatingUI() {
        let labelFirst = UILabel()
        labelFirst.text = "MIND"
        labelFirst.font = UIFont(name: "HelveticaNeue-Bold", size: 55.0)
        labelFirst.numberOfLines = 0
        labelFirst.textAlignment = .center
        view.addSubview(labelFirst)
        
        let labelSecond = UILabel()
        labelSecond.text = "MARATHON"
        labelSecond.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        labelSecond.numberOfLines = 0
        labelSecond.textAlignment = .center
        view.addSubview(labelSecond)
        
        let startMarathon = UIButton()
        startMarathon.setTitle("Список игр".localized(), for: .normal)
        startMarathon.setTitleColor(.label, for: .normal)
        startMarathon.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        startMarathon.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        startMarathon.titleLabel!.minimumScaleFactor = 0.5
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
        whiteBoard.titleLabel!.minimumScaleFactor = 0.5
        whiteBoard.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        view.addSubview(whiteBoard)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(startMarathon)
        buttonStackView.addArrangedSubview(whiteBoard)
        view.addSubview(buttonStackView)
        
        labelFirst.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(100)
            maker.left.right.equalToSuperview().inset(100)
        }
        
        labelSecond.snp.makeConstraints { maker in
            maker.top.equalTo(labelFirst).inset(60)
            maker.left.right.equalToSuperview().inset(100)
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
