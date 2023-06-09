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
        startMarathon.setTitle("Список игр", for: .normal)
        startMarathon.setTitleColor(.label, for: .normal)
        startMarathon.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        startMarathon.backgroundColor = UIColor(named: "gameElementColor")
        startMarathon.layer.cornerRadius = 10
        startMarathon.addTarget(self, action: #selector(listGameTapped), for: .touchUpInside)
        view.addSubview(startMarathon)
        
        let whiteBoard = UIButton()
        whiteBoard.setTitle("Статистика игр", for: .normal)
        whiteBoard.setTitleColor(.label, for: .normal)
        whiteBoard.backgroundColor = UIColor(named: "gameElementColor")
        whiteBoard.layer.cornerRadius = 10
        whiteBoard.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        whiteBoard.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        view.addSubview(whiteBoard)
    
        labelFirst.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(100)
            maker.left.right.equalToSuperview().inset(100)
        }
        
        labelSecond.snp.makeConstraints { maker in
            maker.top.equalTo(labelFirst).inset(60)
            maker.left.right.equalToSuperview().inset(100)
        }
        startMarathon.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(10)
            maker.top.equalTo(labelSecond).inset(250)
            maker.height.equalTo(50)
        }
        
        whiteBoard.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(10)
            maker.top.equalTo(startMarathon).inset(80)
            maker.height.equalTo(50)
        }
    }
    
    @objc
    func listGameTapped() {
        let listGame = ListGamesViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: listGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func whiteBoardTapped() {
        let whiteBoard = WhiteboardViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: whiteBoard)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

