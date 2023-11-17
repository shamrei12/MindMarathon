//
//  TaskTableView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class TasksTableView: UITableView, CustomCellDelegate {
    
    var massiveTask = RealmManager.shared.getTasks()
    
    func buttonPressed(in cell: TasksTableViewCell) {
        let reward = massiveTask[cell.takeReward.tag].reward
        RealmManager.shared.updateTasks(index: cell.takeReward.tag)
        massiveTask = RealmManager.shared.getTasks()
        let indexPath = IndexPath(row: cell.takeReward.tag, section: 0) // Пример индекса ячейки
        self.reloadRows(at: [indexPath], with: .fade)
        
//        if let view = ProfileViewController.self as? ProfileViewController {
//            view.getReward(reward: reward)
//        }
    }
    
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
        
        if massiveTask[indexPath.row].status {
            if massiveTask[indexPath.row].finishTime != TimeInterval(0) {
                cell.beforeRestartingStatus()
            } else {
                cell.getRewardStatus()
            }
        } else {
            cell.inactiveButtonStatus()
        }
        
        return cell
    }
}

