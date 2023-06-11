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
    let game = WhiteBoardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
        
        navigationItem.title = "Статистика игр"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        loadGameList()
        createUI()
    }
    
    func loadGameList() {
        let realm = try! Realm()
        gameList = realm.objects(WhiteBoardManager.self)
    }
    
    
    func createUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
}

extension WhiteboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gameList.count != 0 {
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
        let item = gameList[indexPath.row]
        
        cell.gameName.text = item.nameGame
        cell.gameResult.text = item.resultGame
        cell.gameCount.text = item.countStep
        cell.gameTimer.text = item.timerGame
        
        if item.resultGame == "Победа" {
            cell.mainView.backgroundColor = UIColor(hex: 0x00ff7f)
        } else {
            cell.mainView.backgroundColor = UIColor(hex: 0xfe6f5e)
        }
        return cell
    }
}
