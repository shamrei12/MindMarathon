//
//  TaskTableView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class TasksTableView: UITableView, CustomCellDelegate {
    
//    private lazy var profileVC = ProfileViewController()
    
    func buttonPressed(in cell: TasksTableViewCell) {
        let reward = massiveTask[cell.takeReward.tag].reward
        if let view = ProfileViewController.self as? ProfileViewController {
            view.getReward(reward: reward)
        }
    }
    
    private let massiveTask: [TasksModel] = [TasksModel(condition: "Выйграйте в любую игру", status: true, timeRestart: 10, reward: 10), TasksModel(condition: "Сыграйте в крестики нолики", status: true, timeRestart: 150, reward: 10), TasksModel(condition: "Закрасте поле в игре заливка в зеленый цвет", status: true, timeRestart: 1, reward: 100), TasksModel(condition: "Победите в крестики нолики 3 раза подряд", status: true, timeRestart: 11, reward: 20), TasksModel(condition: "В игре быки и коровы угадайте число за 7 попыток", status: true, timeRestart: 12, reward: 100), ]
    
    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setup()
        self.register(TasksTableViewCell.self, forCellReuseIdentifier: "TasksTableViewCell")
    }
    
    func setup() {
        self.dataSource = self
//        self.delegate = self
        self.separatorStyle = .none
        self.backgroundColor = .clear
    }
}

extension TasksTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massiveTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TasksTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "TasksTableViewCell") as? TasksTableViewCell {
            cell = reuseCell
        } else {
            cell = TasksTableViewCell()
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: TasksTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        cell.setupData(data: massiveTask[indexPath.row])
        cell.takeReward.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

