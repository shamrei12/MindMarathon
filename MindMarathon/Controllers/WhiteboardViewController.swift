//
//  WhiteboardViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.06.23.
//

import UIKit
import SnapKit
import RealmSwift

class WhiteboardViewController: UIViewController {
    private let tableView = UITableView()
    private var gameList: Results<WhiteBoardManager>!
    private var gameListArray = [WhiteBoardManager]()
    let game = WhiteBoardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        self.view.backgroundColor = UIColor(named: "viewColor")
        
        navigationItem.title = "Статистика игр"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        loadGameList()
        createUI()
    }
    
    func loadGameList() {
        do {
            let realm = try Realm()
            gameList = realm.objects(WhiteBoardManager.self)
            gameListArray = Array(gameList).reversed()
        } catch {
            // Обработка ошибки, если не удалось создать экземпляр Realm или выполнить запрос
            print("Failed to load game list: \(error)")
        }
    }
    
    func createUI() {
        let gameNameLabel = UILabel()
        gameNameLabel.text = "Игра"
        gameNameLabel.textAlignment = .center
        gameNameLabel.numberOfLines = 0
        gameNameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        view.addSubview(gameNameLabel)
        
        let gameResultLabel = UILabel()
        gameResultLabel.text = "Статус"
        gameResultLabel.textAlignment = .center
        gameResultLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        view.addSubview(gameResultLabel)
        
        let gameCountLabel = UILabel()
        gameCountLabel.text = "Ходы"
        gameCountLabel.textAlignment = .center
        gameCountLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        view.addSubview(gameCountLabel)
        
        let gameTimerLabel = UILabel()
        gameTimerLabel.text = "Время"
        gameTimerLabel.textAlignment = .center
        gameTimerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        view.addSubview(gameTimerLabel)
        
        let labelStackView = UIStackView(arrangedSubviews: [gameNameLabel, gameResultLabel, gameCountLabel, gameTimerLabel])
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 5
        view.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(25)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(labelStackView).inset(20)
            maker.left.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
}

extension WhiteboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !gameList.isEmpty {
            return gameList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GameTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell") as? GameTableViewCell {
            cell = reuseCell
        } else {
            cell = GameTableViewCell()
        }
        
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: GameTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        let item = gameListArray[indexPath.row]
        cell.gameName.text = item.nameGame
        cell.gameResult.text = item.resultGame
        cell.gameCount.text = item.countStep
        cell.gameTimer.text = item.timerGame
        
        if item.resultGame == "Победа" {
            cell.mainView.backgroundColor = UIColor(hex: 0x00ff7f)
        } else if item.resultGame == "Ничья" {
            cell.mainView.backgroundColor = UIColor.systemYellow
        } else {
            cell.mainView.backgroundColor = UIColor(hex: 0xfe6f5e)
        }
        return cell
    }
}
