//
//  ProfileViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let statiscticCollectionView = StatiscticsCollectionView()
    let firebase = FirebaseData()
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "profile".localized()
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        
        return mainLabel
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
        
        return userImage
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        userName.textColor = .label
        userName.text = "Batonkmn"
        
        return userName
    }()
    
    private lazy var ratingPossitionLabel: UILabel = {
        let ratingPossitionLabel = UILabel()
        ratingPossitionLabel.backgroundColor = .lightGray
        ratingPossitionLabel.text = "#5"
        ratingPossitionLabel.textAlignment = .center
        ratingPossitionLabel.tintColor = .white
        ratingPossitionLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 17), weight: .semiBold)
        ratingPossitionLabel.layer.cornerRadius = 5
        ratingPossitionLabel.clipsToBounds = true
        
        return ratingPossitionLabel
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.layer.cornerRadius = 8
        progress.layer.cornerCurve = .continuous
        progress.clipsToBounds = true
        progress.progress = 0
        
        return progress
    }()
    
    private lazy var currentRankScore: UILabel = {
        let currentRankScore = UILabel()
        currentRankScore.font = UIFont.sfProText(ofSize: 10, weight: .bold)
        currentRankScore.textColor = .label
        currentRankScore.text = "12"
        
        return currentRankScore
    }()
    
    private lazy var ratingButton: UIButton = {
        let ratingButton = UIButton()
        ratingButton.setTitle("leaderboard".localized(), for: .normal)
        ratingButton.setTitleColor(.label, for: .normal)
        ratingButton.layer.cornerCurve = .circular
        ratingButton.layer.cornerRadius = 16
        ratingButton.setImage(UIImage(named: "rating"), for: .normal)
        ratingButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        ratingButton.titleLabel?.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 20), weight: .semiBold)
        ratingButton.backgroundColor = UIColor(named: "gameElementColor")
        
        return ratingButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func refreshData() {
        mainLabel.text = "profile".localized()
        ratingButton.setTitle("leaderboard".localized(), for: .normal)
        getCurrentAndNextRank(exp: UserDefaultsManager.shared.getUserExperience(), level: UserDefaultsManager.shared.getUserLevel())
        getUserStatistics()
    }
    
    func setupUI() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(userView)
        self.view.addSubview(statiscticCollectionView)
        self.view.addSubview(ratingButton)
        userView.addSubview(mainLabel)
        userView.addSubview(userImage)
        userView.addSubview(userName)
        userView.addSubview(ratingPossitionLabel)
        userView.addSubview(progress)
        progress.addSubview(currentRankScore)
    }
    
    func makeConstraints() {
        userView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.right.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        userImage.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-10)
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(userView.snp.width).multipliedBy(0.25)
        }
        
        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        userName.snp.makeConstraints { maker in
            maker.top.equalTo(userImage.snp.bottom).inset(-10)
            maker.centerX.equalToSuperview()
        }
        
        ratingPossitionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(userName.snp.top)
            maker.bottom.equalTo(userName.snp.bottom)
            maker.left.equalTo(userName.snp.right).inset(-10)
            maker.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        progress.snp.makeConstraints { maker in
            maker.top.equalTo(userName.snp.bottom).inset(-15)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            maker.bottom.equalToSuperview().inset(15)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.03)
        }
        
        currentRankScore.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(5)
            maker.centerX.centerY.equalToSuperview()
        }
        
        statiscticCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(userView.snp.bottom).inset(-15)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.22)
        }
        
        ratingButton.snp.makeConstraints { maker in
            maker.top.equalTo(statiscticCollectionView.snp.bottom).inset(-15)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.08)
        }
    }
    
    func getCurrentAndNextRank(exp: Int, level: Int) {
        var maxRank: Double = Double(level * 100) + (Double(level) + 0.5)
        
        if exp > Int(maxRank) {
            UserDefaultsManager.shared.changeExpirience(exp: exp - Int(maxRank))
            UserDefaultsManager.shared.changeUserLebel(level: level + 1)
            
            let newLevel = UserDefaultsManager.shared.getUserLevel()
            let newMaxRank: Double = Double(newLevel * 100) + (Double(newLevel) + 0.5)
            let newExp = UserDefaultsManager.shared.getUserExperience()
            
            currentRankScore.text = "\(newLevel)" + " " + "level".localized()!
            makeResultsForProgressBar(newExp: newExp, maxExp: newMaxRank)
        } else {
            progress.progress = Float(exp) / Float(maxRank)
            currentRankScore.text = "\(level)" + " " + "level".localized()!
            makeResultsForProgressBar(newExp: exp, maxExp: maxRank)
        }
    }
    
    func makeResultsForProgressBar(newExp: Int, maxExp: Double) {
        if newExp != 0 {
            let newExp: Float = Float(newExp) / Float(maxExp)
            progress.progress = newExp
        } else {
            progress.progress = 0
        }
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
        
        favoriteGame = mostFrequentWord(in: labelGame) ?? "isHaveData".localized()!
        countWinStrike = getWinStrike(massive: massiveResultsGames)
        
        let newDataMassive: [String] = [
            "\(TimeManager.shared.convertToMinutesWhiteBoard(seconds: secondsTime))",
            "\(userStatistics.count)",
            favoriteGame,
            "\(countWinStrike)"
        ]
        statiscticCollectionView.dataMassive = newDataMassive
        
        guard let timeGame = "timeGame".localized(), let favorite = "favoritegame".localized(), let countGames = "countGames".localized(), let seriesWin = "seriesWin".localized() else {
            return
        }
        statiscticCollectionView.descriptionMassive = [timeGame, countGames, favorite, seriesWin]
        statiscticCollectionView.reloadData()
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
