//
//  TaskTableView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit
import SnapKit

protocol CustomCellDelegate: AnyObject {
    func buttonPressed(in cell: TasksTableViewCell)
}

class TasksTableViewCell: UITableViewCell {
    private var stopwatch: Timer?
    private var seconds = 0
    private var dataCell: TasksManager!
    weak var delegate: CustomCellDelegate?
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(hex: 0xfcfcfc, alpha: 1)
        mainView.layer.cornerRadius = 12
        return mainView
    }()
    
    private lazy var insertView: UIView = {
        let insertView = UIView()
        insertView.backgroundColor = .clear
        return insertView
    }()
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.font = UIFont.sfProText(ofSize: 12, weight: .regular)
        mainLabel.textColor = UIColor(hex: 0x000000, alpha: 1)
        mainLabel.numberOfLines = 0
        return mainLabel
    }()
    
    lazy var takeReward: UIButton = {
        let takeReward = UIButton()
        takeReward.clipsToBounds = true
        takeReward.titleLabel?.font = UIFont.sfProText(ofSize: 14, weight: .light)
        takeReward.setTitleColor(UIColor(hex: 0xffffff, alpha: 1), for: .normal)
        takeReward.layer.cornerRadius = 12
        takeReward.addTarget(self, action: #selector(getReward), for: .touchUpInside)
        return takeReward
    }()    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data: TasksManager) {
        dataCell = data
        mainLabel.text = data.condition
        setupUI()
        makeConstaints()
    }
    
    func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.contentView.addSubview(mainView)
        self.contentView.addSubview(insertView)
        self.mainView.addSubview(mainLabel)
        self.mainView.addSubview(takeReward)
    }
    
    func makeConstaints() {
        insertView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(12)
        }
        
        mainView.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(5)
            maker.bottom.equalTo(insertView.snp.top).inset(-1)
        }
        
        takeReward.snp.makeConstraints { maker in
            maker.right.top.bottom.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.4)
        }
        
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.bottom.equalToSuperview().inset(15)
            maker.right.equalTo(takeReward.snp.left).inset(-5)
        }
    }
    
    @objc func getReward(sender: UIButton) {
        delegate?.buttonPressed(in: self)
        beforeRestartingStatus()
    }
    
    func createTimer() {
        stopwatch = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        takeReward.setTitle(TimeManager.shared.convertToMinutes(seconds: seconds), for: .normal)
        if seconds < 0 {
            stopwatch?.invalidate()
            takeReward.isEnabled = true
            delegate?.buttonPressed(in: self)
        }
    }
    
    func startTimer() {
        seconds = TimeManager.shared.getFinishTimeForTask(taskTime: dataCell.timeRestart)
        createTimer()
    }
    
    func inactiveButtonStatus() {
        takeReward.isEnabled = false
        takeReward.backgroundColor = .systemGray
        takeReward.setTitle("Не выполнено", for: .normal)
    }
    
    func beforeRestartingStatus() {
        takeReward.backgroundColor = .systemGray
        takeReward.isEnabled = false
        startTimer()
    }
    
    func getRewardStatus() {
        takeReward.setTitle("Забрать награду", for: .normal)
        takeReward.backgroundColor = .systemMint
        takeReward.isEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
