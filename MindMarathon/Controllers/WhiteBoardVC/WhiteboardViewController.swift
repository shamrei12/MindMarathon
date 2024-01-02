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
    private let labelStack = ["gameLabel", "statusLabel", "stepsLabel", "timeLabel"]
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()

        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        return mainLabel
    }()
    
    private lazy var labelStackView: UIStackView = {
        var labelStackView = UIStackView()
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 5
        return labelStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        makeConstraints()
        setupTableView()
        loadGameList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    func setup() {
        self.view.addSubview(mainLabel)
        setupLabelStackView()
        self.view.addSubview(labelStackView)
        self.view.addSubview(tableView)
    }
    
    func makeConstraints() {
        mainLabel.snp.makeConstraints { maker in
            maker.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(25)
        }
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(labelStackView).inset(20)
            maker.left.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupLabelStackView() {
        labelStackView = UIStackView(arrangedSubviews: [
            createLabelCategories(text: "gameLabel".localized()!),
            createLabelCategories(text: "statusLabel".localized()!),
            createLabelCategories(text: "stepsLabel".localized()!),
            createLabelCategories(text: "timeLabel".localized()!)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameTableViewCell")
        self.view.backgroundColor = UIColor(named: "viewColor")
    }

    func setupData() {
        mainLabel.text = "historyGames".localized()
        tableView.reloadData()
        for (index, subview) in labelStackView.arrangedSubviews.enumerated() {
            if let label = subview as? UILabel {
                label.text = labelStack[index].localized()
            }
        }
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
    
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }
}

extension WhiteboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell else {
            return GameTableViewCell()
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
        
        cell.mainView.backgroundColor = backgroundColor(for: item.resultGame.localize())
        
        return cell
    }

    private func backgroundColor(for result: String) -> UIColor {
        switch result {
        case "win".localize():
            return UIColor(hex: 0x00ff7f)
        case "draw".localize():
            return UIColor.systemYellow
        default:
            return UIColor(hex: 0xfe6f5e)
        }
    }
}
