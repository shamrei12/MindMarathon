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
    
    private lazy var userCoinView: UIView = {
        let userCoinView = UIView()
        userCoinView.backgroundColor = .lightGray
        userCoinView.layer.cornerRadius = 10
        return userCoinView
    }()
    
    private lazy var coinImageView: UIImageView = {
        let coinImageView = UIImageView()
        coinImageView.image = UIImage(named: "coin")
        return coinImageView
    }()
    
    private lazy var coinLabel: UILabel = {
        let coinLabel = UILabel()
        coinLabel.text = "10"
        coinLabel.font = UIFont.sfProText(ofSize: 15, weight: .light)
        return coinLabel
    }()
    
    private lazy var diamondImageView: UIImageView = {
        let diamondImageView = UIImageView()
        diamondImageView.image = UIImage(named: "diamond")
        return diamondImageView
    }()
    
    private lazy var diamondLabel: UILabel = {
        let diamondLabel = UILabel()
        diamondLabel.text = "1"
        diamondLabel.font = UIFont.sfProText(ofSize: 15, weight: .light)
        return diamondLabel
    }()

    private lazy var userView: UIView = {
        let userView = UIView()
        userView.backgroundColor = .clear
        return userView
    }()
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.clipsToBounds = true

        let image = UIImage(named: "userImage")
        userImage.image = image
        userImage.contentMode = .scaleToFill
        userImage.layer.borderColor = UIColor.gray.cgColor
        userImage.layer.borderWidth = 2
        

        return userImage
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        userName.textColor = .label
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
        currentRunk.font = UIFont.sfProText(ofSize: 11, weight: .light)
        currentRunk.textColor = UIColor(hex: 0x000000)
        currentRunk.text = "Новичок"
        
        return currentRunk
    }()
    
    private lazy var nextRank: UILabel = {
        let nextRunk = UILabel()
        nextRunk.font = UIFont.sfProText(ofSize: 11, weight: .light)
        nextRunk.textColor = UIColor(hex: 0x000000)
        nextRunk.text = "Любитель"
        return nextRunk
    }()
    
    private lazy var currentRankScore: UILabel = {
        let currentRankScore = UILabel()
        currentRankScore.font = UIFont.sfProText(ofSize: 11, weight: .light)
        currentRankScore.textColor = UIColor(hex: 0x000000)
        currentRankScore.text = "0"
        
        return currentRankScore
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
        getUserStatistics()
        taskTableView.updateAllCells()
    }
    
    func setupUI() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(userCoinView)
        self.userCoinView.addSubview(coinImageView)
        self.userCoinView.addSubview(coinLabel)
        self.userCoinView.addSubview(diamondImageView)
        self.userCoinView.addSubview(diamondLabel)
        
        self.view.addSubview(userView)
        userView.addSubview(userImage)
        userView.addSubview(userName)
        userView.addSubview(progress)
        progress.addSubview(currentRank)
        progress.addSubview(currentRankScore)
        progress.addSubview(nextRank)
        userView.addSubview(statisctiView)
        self.view.addSubview(taskLabel)
        self.view.addSubview(taskTableView)
    }
    
    func makeConstraints() {
        
        userCoinView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            maker.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.04)
        }
        
        coinImageView.snp.makeConstraints { maker in
            maker.bottom.top.equalToSuperview().inset(1)
            maker.left.equalToSuperview().inset(5)
            maker.width.height.equalTo(userCoinView.snp.height).multipliedBy(0.9)
        }
        
        coinLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(5)
            maker.left.equalTo(coinImageView.snp.right).inset(-5)
        }
        
        diamondImageView.snp.makeConstraints { maker in
            maker.bottom.top.equalToSuperview().inset(1)
            maker.left.equalTo(coinLabel.snp.right).inset(-10)
            maker.width.height.equalTo(userCoinView.snp.height).multipliedBy(0.9)
        }
        
        diamondLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(5)
            maker.left.equalTo(diamondImageView.snp.right).inset(-5)
            maker.right.equalToSuperview().inset(5)
        }
        
        userView.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { maker in
            maker.top.equalTo(userCoinView.snp.bottom).inset(-15)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(100)
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
        
        currentRankScore.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
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
        progress.progress = 0
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
        currentRankScore.text = "\(exp)"
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
    }
    
    func getCurrentAndNextRank(current: String, next: String?) {
        if next != nil {
            nextRank.text = next
        } else {
            nextRank.text = ""
        }
        currentRank.text = current
    }
    
    func getUserStatistics() {
        let userStatistics = RealmManager.shared.getUserStatistics()
        var secondsTime = 0
        var labelGame = [String]()
        var favoriteGame = ""
        var countWinStrike = 0
        var massiveResultsGames = [String]()
        for i in userStatistics {
            secondsTime += i.timerGame
            labelGame.append(i.nameGame)
            massiveResultsGames.append(i.resultGame)
        }
        
        favoriteGame = mostFrequentWord(in: labelGame) ?? "Нет данных"
        countWinStrike = getWinStrike(massive: massiveResultsGames)
        
        statisctiView.dataMassive[0] = "\(TimeManager.shared.convertToMinutesWhiteBoard(seconds: secondsTime))"
        statisctiView.dataMassive[1] = favoriteGame
        statisctiView.dataMassive[2] = "\(countWinStrike)"
        statisctiView.reloadData()
    }
    
    func mostFrequentWord(in words: [String]) -> String? {
        let wordCounts = words.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        return wordCounts.max { $0.1 < $1.1 }?.key.localize()
    }

    func getWinStrike(massive: [String]) -> Int {
        var countWinStrike = 0
        var tempCountWinStrike = 0
        
        for i in massive {
            if i == "win" {
                tempCountWinStrike += 1
                countWinStrike = max(countWinStrike, tempCountWinStrike)
            } else {
                tempCountWinStrike = 0
            }
        }
        return countWinStrike
    }
}
