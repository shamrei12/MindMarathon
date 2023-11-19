//
//  ProfileViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let statisctiView = StatiscticsCollectionView()
    let taskTableView = TasksTableView()

    private lazy var userView: UIView = {
        let userView = UIView()
        userView.backgroundColor = .lightGray
        return userView
    }()
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.clipsToBounds = true

        let image = UIImage(named: "userImage")
        userImage.image = image
        userImage.contentMode = .scaleToFill
        userImage.backgroundColor = UIColor(hex: 0x000000, alpha: 1)

        return userImage
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        userName.textColor = UIColor(hex: 0x000000)
        userName.text = "Batonkmn"
        
        return userName
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 0
        return progress
        
    }()
    
    private lazy var currentRank: UILabel = {
        let currentRunk = UILabel()
        currentRunk.font = UIFont.sfProText(ofSize: 10, weight: .light)
        currentRunk.textColor = UIColor(hex: 0x000000)
        currentRunk.text = "Новичок"
        
        return currentRunk
    }()
    
    private lazy var nextRank: UILabel = {
        let nextRunk = UILabel()
        nextRunk.font = UIFont.sfProText(ofSize: 10, weight: .light)
        nextRunk.textColor = UIColor(hex: 0x000000)
        nextRunk.text = "Любитель"
        
        return nextRunk
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProText(ofSize: 22, weight: .bold)
        label.text = "Задания"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserExpiriense(exp: UserDefaultsManager.shared.getUserExpiriense()!)
    }
    
    func setupUI() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(userView)
        userView.addSubview(userImage)
        userView.addSubview(userName)
        userView.addSubview(progress)
        progress.addSubview(currentRank)
        progress.addSubview(nextRank)
        userView.addSubview(statisctiView)
        self.view.addSubview(taskLabel)
        self.view.addSubview(taskTableView)
    }
    
    func makeConstraints() {
        
        userView.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            maker.centerX.equalToSuperview()
//            maker.width.height.equalTo(100)
        }
        
        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        userName.snp.makeConstraints { maker in
            maker.top.equalTo(userImage.snp.bottom).inset(-10)
            maker.centerX.equalToSuperview()
        }
        
        progress.snp.makeConstraints { maker in
            maker.top.equalTo(userName.snp.bottom).inset(-15)
            maker.height.equalTo(20)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        currentRank.snp.makeConstraints { maker in
            maker.top.left.bottom.equalToSuperview().inset(5)
        }
        
        nextRank.snp.makeConstraints { maker in
            maker.top.right.bottom.equalToSuperview().inset(5)
        }
        
        statisctiView.snp.makeConstraints { maker in
            maker.top.equalTo(progress.snp.bottom).inset(-25)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(80)
            maker.bottom.equalToSuperview().inset(15)
        }
        
        taskLabel.snp.makeConstraints { maker in
            maker.top.equalTo(userView.snp.bottom).inset(-15)
            maker.left.equalToSuperview().inset(16)
        }
        
        taskTableView.snp.makeConstraints { maker in
            maker.top.equalTo(taskLabel.snp.bottom).inset(-20)
            maker.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func getUserExpiriense(exp: Int) {
        let currentRank = getCurrentAndNextRank(exp: exp)
        getCurrentAndNextRank(current: currentRank.0, next: currentRank.1)
    }
    
    func getCurrentAndNextRank(exp: Int) -> (String, String?) {
        var currentIndex = 0
        var nextIndex = 0
        var currentRank: String = "Нет звания"
        var nextRank: String?
        let rankExperienceRequirements = [
            ("Новичок", 0...100),
            ("Ученик", 101...300),
            ("Любопытный", 301...600),
            ("Опытный", 601...1000),
            ("Сын маминой подруги", 1001...10000)
        ]
        
        for i in 0..<rankExperienceRequirements.count {
            if rankExperienceRequirements[i].1.contains(exp) {
                currentIndex = i
                nextIndex = i + 1
                currentRank = rankExperienceRequirements[i].0
            }
        }
        
        if nextIndex > rankExperienceRequirements.count - 1 {
            nextRank = nil
        } else {
           nextRank = rankExperienceRequirements[nextIndex].0
        }
        
        makeResultsForProgressBar(newExp: exp, maxExp: rankExperienceRequirements[currentIndex].1.upperBound)
        return (currentRank, nextRank)
    }

    func makeResultsForProgressBar(newExp: Int, maxExp: Int) {
        if newExp != 0 {
            let newExp: Float = Float(newExp) / Float(maxExp)
            progress.progress = newExp
        } else {
            progress.progress = 0
        }
        
        print(progress.progress)
    }
    
    func getCurrentAndNextRank(current: String, next: String?) {
        if next != nil {
            nextRank.text = next
        } else {
            nextRank.text = ""
        }
        currentRank.text = current
    }
}
