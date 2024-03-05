//
//  ProfileViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit
import FlagKit
import SwiftUI

class ProfileViewController: UIViewController {
    
    let statiscticCollectionView = StatiscticsCollectionView()
    let firebase = FirebaseData()
    let editUserView = EditUserView()
    var hostingController: UIHostingController<ContentView>?
    
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
        userImage.contentMode = .scaleAspectFill
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChangeImageView)))
        return userImage
    }()

    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        userName.textColor = .label
        userName.text = "Unknown"
        
        return userName
    }()
    
    private lazy var userCountry: UIImageView = {
        let userCountry = UIImageView()
        userCountry.layer.borderColor = UIColor.black.cgColor
        userCountry.layer.borderWidth = 1
        
        return userCountry
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
        currentRankScore.text = ""
        
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
        ratingButton.addTarget(self, action: #selector(leaderboardTapped), for: .touchUpInside)
        
        return ratingButton
    }()
    
    private lazy var editProfileButton: UIButton = {
        let editProfileButton = UIButton()
        editProfileButton.setTitle("editProfile".localized(), for: .normal)
        editProfileButton.setTitleColor(.systemBlue, for: .normal)
        editProfileButton.addTarget(self, action: #selector(editViewTapped), for: .touchUpInside)
        return editProfileButton
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
        editProfileButton.setTitle("editProfile".localized(), for: .normal)
        getUserProfileData()
        updateUserStatus()
    }
    
    func setupUI() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(userView)
        self.view.addSubview(statiscticCollectionView)
        self.view.addSubview(ratingButton)
        userView.addSubview(mainLabel)
        userView.addSubview(editProfileButton)
        userView.addSubview(userImage)
        userView.addSubview(userName)
        userView.addSubview(userCountry)
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
        
        editProfileButton.snp.makeConstraints { maker in
            maker.right.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
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
        
        userCountry.snp.makeConstraints { maker in
            maker.top.equalTo(userName.snp.top)
            maker.bottom.equalTo(userName.snp.bottom)
            maker.left.equalTo(userName.snp.right).inset(-10)
            maker.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.08)

        }
        
        progress.snp.makeConstraints { maker in
            maker.top.equalTo(userName.snp.bottom).inset(-20)
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
        let maxRank: Double = Double(level * 100) + (Double(level) + 0.5)
        var newUserExperience = Double(exp)
        var newLevel = level
        var newMaxRank = maxRank

        if exp > Int(maxRank) {
            newUserExperience -= maxRank
            newLevel += 1
            newMaxRank = Double(newLevel * 100) + (Double(newLevel) + 0.5)
            RealmManager.shared.resetUserExpirience(exp: Int(newUserExperience))
            RealmManager.shared.changeUserLevel(level: newLevel)
        }

        currentRankScore.text = "\(newLevel)" + " " + "level".localized()!
        makeResultsForProgressBar(newExp: Int(newUserExperience), maxExp: newMaxRank)
    }

    func makeResultsForProgressBar(newExp: Int, maxExp: Double) {
        let progressValue: Float = Float(newExp) / Float(maxExp)
        progress.progress = progressValue
    }
    
    func getUserStatistics(massive: [ProfileManager]) {
        let timeInGame = String(massive[0].timeInGame)
        let countGames = String(massive[0].countGames)
        let favoriteGame = String(massive[0].favoriteGame).localized()
        let winStrike = String(massive[0].winStrike)
        statiscticCollectionView.dataMassive = [timeInGame, countGames, favoriteGame!, winStrike]
        
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
    
    func getUserProfileData() {
        RealmManager.shared.actualityProfileData()
        
        guard let userProfile = RealmManager.shared.getUserProfileData().first else {
            return
        }
        userName.text = userProfile.username
        userImage.image = UIImage(named: userProfile.userImage)
        currentRankScore.text = "\(userProfile.userLevel) level".localized()
        getCurrentAndNextRank(exp: userProfile.userExpirience, level: userProfile.userLevel)
        getUserStatistics(massive: [userProfile])
        getCurrentAndNextRank(exp: userProfile.userExpirience, level: userProfile.userLevel)
        
        if userProfile.nationality == "world" {
            userCountry.backgroundColor = .systemBlue
        } else {
            let image = Flag(countryCode: userProfile.nationality)
//            let styledImage = image!.image(style: .none)
            let originalImage = image!.originalImage
            userCountry.image = originalImage
        }
        
        if userProfile.premiumStatus > TimeManager.shared.getCurrentTime() {
            userImage.layer.borderColor = UIColor.systemYellow.cgColor
            userImage.layer.borderWidth = 3
        } else {
            userImage.layer.borderColor = UIColor.clear.cgColor
            userImage.layer.borderWidth = 0
        }
        
        firebase.refGetData(from: [userProfile])
    }
    
    func updateUserStatus() {
        var userProfiledata = RealmManager.shared.getUserProfileData()
        firebase.getUserProfile(id: userProfiledata[0].userID) { profileData in
            DispatchQueue.global().async {
                DispatchQueue.main.sync {
                    if userProfiledata[0].premiumStatus != profileData[0].premiumStatus {
                        RealmManager.shared.addPremiumStatus(status: profileData[0].premiumStatus)
                        self.getUserProfileData()
                    } else {
                        self.getUserProfileData()
                    }
                }
            }
        }
    }
    
    @objc
    func leaderboardTapped() {
        let viewController = RatingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func editViewTapped() {
        let view = ContentView(dismisAction: {
            self.dismiss(animated: true)
            self.refreshData()
        })
        let hostingController = UIHostingController(rootView: view)
        self.view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.modalPresentationStyle = .overFullScreen
        self.present(hostingController, animated: true)
        
    }
    
    @objc
    func showChangeImageView() {
        let view = ChangeImageView(dismisAction: {
            self.dismiss(animated: true)
            self.refreshData()
        })
        let hostingController = UIHostingController(rootView: view)
        self.present(hostingController, animated: true)
    }
}
