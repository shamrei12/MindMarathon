//
//  TaskTableView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class TasksTableView: UITableView, CustomCellDelegate {
    
    private var massiveTask = RealmManager.shared.getTasks()

    func buttonPressed(in cell: TasksTableViewCell) {
        let newMassiveTask = RealmManager.shared.getTasks()
        guard !newMassiveTask.isEmpty, !massiveTask.isEmpty else {
            return
        }
        
        if newMassiveTask != massiveTask {
            massiveTask = newMassiveTask
            let reward = massiveTask[cell.takeReward.tag].reward
            RealmManager.shared.awardReceived(index: cell.takeReward.tag)
            UserDefaultsManager.shared.addExpirience(exp: reward)
            let indexPath = IndexPath(row: cell.takeReward.tag, section: 0)
            self.reloadRows(at: [indexPath], with: .fade)
            
            if let cell = self.cellForRow(at: indexPath) as? TasksTableViewCell {
                cell.setupData(data: massiveTask[indexPath.row])
            }
            
            if let profileViewController = UIApplication.shared.keyWindow?.rootViewController as? ProfileViewController {
                profileViewController.getUserExpiriense(exp: UserDefaultsManager.shared.getUserExpiriense() ?? 0)
            }
        }
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
            print(indexPath.row)
            cell.getRewardStatus()
        } else if massiveTask[indexPath.row].isRestartTime == false {
            print(indexPath.row)
            print(massiveTask[indexPath.row].isRestartTime)
            cell.inactiveButtonStatus()
        } else if massiveTask[indexPath.row].isRestartTime == true {
            print(indexPath.row)
            print(massiveTask[indexPath.row].isRestartTime)
            cell.beforeRestartingStatus()
        }
        
        return cell
    }
}
