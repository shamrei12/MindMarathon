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
        self.view.backgroundColor = UIColor(named: "viewColor")
        tableView.backgroundColor = UIColor.clear
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
//        cell.gameButton.tag = index
//        cell.gameButton.setTitle(countGame.first?.key, for: .normal)
//        cell.createBy.text = "created by \(String(describing: countGame.first!.value))"
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 10
        if indexPath.row == 0 {
            cell.backgroundView = UIImageView(image: UIImage(named: "BullsAndCowsCell"))
        } else if indexPath.row == 1 {
            cell.backgroundView = UIImageView(image: UIImage(named: "SlovusCell"))

           
        } else if indexPath.row == 2 {
            cell.backgroundView = UIImageView(image: UIImage(named: "FloodFillCell"))

          
        } else if indexPath.row == 3 {
            cell.backgroundView = UIImageView(image: UIImage(named: "TicTacToeCell"))

           
        }
        return cell
    }
}

extension ListGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewWidth = tableView.frame.width
        print(tableViewWidth)
        let height = tableViewWidth / 3.308641975308642
        print(height)
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: bullCowButtonTapped()
        case 1: slovusButtonTapped()
        case 2: floodFillTapped()
        case 3: ticTacToeTapped()
        default: print("Default")
        }
    }
}
