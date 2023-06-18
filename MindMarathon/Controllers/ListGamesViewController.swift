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
    let gameList: [[String: String]] = [["Быки и Коровы": "Aliaksei Shamrei"], ["Словус": "Aliaksei Shamrei"], ["Заливка": "Aliaksei Shamrei"], ["Крестики Нолики": "Nikita Shakalov"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр"
        tableView.register(UINib(nibName: "ListGameTableViewCell", bundle: nil), forCellReuseIdentifier: "ListGameTableViewCell")
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        createUI()
    }
    
    func createUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    func bullCowButtonTapped() {
        let bullCowGame = BullCowViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: bullCowGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func slovusButtonTapped() {
        let slovusGame = SlovusGameViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: slovusGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func floodFillTapped() {
        let floodFillGame = FloodFillViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: floodFillGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func ticTacToeTapped() {
        let ticTacToeGame = TicTacToeViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: ticTacToeGame)
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
        let index = Int(indexPath.row)
        let countGame = gameList[index]
        cell.gameButton.tag = index
        cell.gameButton.setTitle(countGame.first?.key, for: .normal)
        cell.createBy.text = "created by \(String(describing: countGame.first!.value))"
        
        if indexPath.row == 0 {
            cell.gameButton.addTarget(self, action: #selector(bullCowButtonTapped), for: .touchUpInside)
        } else if indexPath.row == 1 {
            cell.gameButton.addTarget(self, action: #selector(slovusButtonTapped), for: .touchUpInside)
        } else if indexPath.row == 2 {
            cell.gameButton.addTarget(self, action: #selector(floodFillTapped), for: .touchUpInside)
        } else if indexPath.row == 3 {
            cell.gameButton.addTarget(self, action: #selector(ticTacToeTapped), for: .touchUpInside)
        }
        return cell
    }
}

extension ListGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
