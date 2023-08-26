//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit

class ListGamesViewController: UIViewController {
    let tableView = UITableView()

    let gameList: [ListGameProtocol] = [ListGameModel(gameName: "Быки и Коровы", createdBy: "Aliaksei Shamrei", aboutGame: "Ваша цель угадать секретное число за минимальное количество ходов", imageName: "BullCow"), ListGameModel(gameName: "Словус", createdBy: "Aliaksei Shamrei", aboutGame: "В данной игре Вам необходимо угадать секретное слово за 6 попыток", imageName: "Game"), ListGameModel(gameName: "Заливка", createdBy: "Aliaksei Shamrei", aboutGame: "Ваша цель закрасить поле в один цвет за минимальное количество ходов", imageName: "Game"), ListGameModel(gameName: "Крестики Нолики", createdBy: "Nikita Shakalov", aboutGame: "Ваша задача быстрее соперника выстроить свои символы (крестики) в линию", imageName: "Game"), ListGameModel(gameName: "Бинарио", createdBy: "Aliaksei Shamrei", aboutGame: "Правильно расставьте синие и красные блоки в сетке, удовлетворяя условиям", imageName: "Game")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр".localized()
        tableView.register(UINib(nibName: "ListGameTableViewCell", bundle: nil), forCellReuseIdentifier: "ListGameTableViewCell")
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = UIColor(named: "viewColor")
        tableView.backgroundColor = UIColor.clear
        createUI()
    }
    
    func createUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.95)
            maker.height.equalToSuperview()
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    func bullCowButtonTapped() {
        let bullCowGame = BullCowViewController()
        let navigationController = UINavigationController(rootViewController: bullCowGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func slovusButtonTapped() {
        let slovusGame = SlovusGameViewController()
        let navigationController = UINavigationController(rootViewController: slovusGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func floodFillTapped() {
        let floodFillGame = FloodFillViewController()
        let navigationController = UINavigationController(rootViewController: floodFillGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func ticTacToeTapped() {
        let ticTacToeGame = TicTacToeViewController()
        let navigationController = UINavigationController(rootViewController: ticTacToeGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    @objc
    func binarioTapped() {
        let zeroOneGame = BinarioViewController()
        let navigationController = UINavigationController(rootViewController: zeroOneGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ListGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ListGameTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "ListGameTableViewCell") as? ListGameTableViewCell {
            cell = reuseCell
        } else {
            cell = ListGameTableViewCell()
        }
        
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: ListGameTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        cell.gameNameLabel.text = gameList[indexPath.row].gameName
        cell.createdByLabel.text = "by \(gameList[indexPath.row].createdBy)"
        cell.aboutGameLabel.text = gameList[indexPath.row].aboutGame
        cell.gameImageView.image = getImage(index: indexPath.row)
        return cell
    }
    
    func getImage(index: Int) -> UIImage {
        switch index {
        case 0: return UIImage(named: "bullCowImage")!
        case 1: return UIImage(named: "slovusImage")!
        case 2: return UIImage(named: "floodFillImage")!
        case 3: return UIImage(named: "tikTakToeImage")!
        case 4: return UIImage(named: "binarioImage")!
        default: return UIImage(named: "bull")!
        }
    }
}

extension ListGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewWidth = tableView.frame.width
        let height = tableViewWidth / 4
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: bullCowButtonTapped()
        case 1: slovusButtonTapped()
        case 2: floodFillTapped()
        case 3: ticTacToeTapped()
        case 4: binarioTapped()
        default: print("Default")
        }
    }
}
