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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
        setunNavigationBar()
        setupUI()
        loadGameList()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameTableViewCell")
        self.view.backgroundColor = UIColor(named: "viewColor")
        
        view.addSubview(tableView)
    }
    
    func setunNavigationBar() {
        navigationItem.title = "Статистика игр"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
    }
    
    func loadGameList() {
        do {
            let realm = try Realm()
            gameList = realm.objects(WhiteBoardManager.self)
            gameListArray = Array(gameList).reversed()
        } catch {
            print("Failed to load game list: \(error)")
        }
        tableView.reloadData()
    }
    
    func createLabelCategories(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.label
        label.font = UIFont.sfProText(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    func setupUI() {
        let labelStackView = UIStackView(arrangedSubviews: [createLabelCategories(text: "gameLabel".localize()), createLabelCategories(text: "statusLabel".localize()), createLabelCategories(text: "stepsLabel".localize()), createLabelCategories(text: "timeLabel".localize())])
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 5
        
        view.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(25)
        }
        
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
        if !gameListArray.isEmpty {
            return gameListArray.count
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
        cell.createUI()
        let item = gameListArray[indexPath.row]
        cell.gameName.text = item.nameGame.localize()
        cell.gameResult.text = item.resultGame.localize()
        cell.gameCount.text = item.countStep
        cell.gameTimer.text = TimeManager.shared.convertToMinutesWhiteBoard(seconds: item.timerGame)

        switch item.resultGame.localize() {
        case "win".localize():
            cell.mainView.backgroundColor = UIColor(hex: 0x00ff7f)
        case "draw".localize(): cell.mainView.backgroundColor = UIColor.systemYellow
        default: cell.mainView.backgroundColor = UIColor(hex: 0xfe6f5e)
        }
        
        return cell
    }
}
