//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit
import SwiftUI

class ListGamesViewController: UIViewController {
    let firebase = FirebaseData()
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var gameList: [Game] = ListGamesViewController.createGames()
//    let createUserView = CreateUserView()

    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "listGames".localized()
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        return mainLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        createUserView.delegate = self
        setup()
        makeConstraints()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fisrStart()
    }
    
    func fisrStart() {
        if UserDefaultsManager.shared.checkFirstStart() {
            let view = Preview(dismisAction: {
                self.dismiss(animated: true)
            })
            
            let hostingVC = UIHostingController(rootView: view)
            hostingVC.view.backgroundColor = .clear
            hostingVC.modalPresentationStyle = .overFullScreen
            
            present(hostingVC, animated: true)
        } 
    }
    
    func generateNickname() -> String {
        let uuid = UUID().uuidString
        let lastFourCharacters = String(uuid.suffix(4))
        let nickname = "User" + lastFourCharacters
        return nickname
    }

    
    
    func disableTabBarInteractions() {
        guard let customTabBarController = self.tabBarController as? CustomTabBarController else { return }
        
        for view in customTabBarController.tabBar.subviews {
            if let button = view as? UIControl {
                button.isEnabled = false
            }
        }
    }

    func enableTabBar() {
        EnableTabBarInteractions()
    }
    
    func userCreate() {
        UserDefaultsManager.shared.setupDataUserDefaults()
    }
    
    func EnableTabBarInteractions() {
        guard let customTabBarController = self.tabBarController as? CustomTabBarController else { return }
        
        for view in customTabBarController.tabBar.subviews {
            if let button = view as? UIControl {
                button.isEnabled = true
            }
        }
    }

    func setup() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        self.view.addSubview(collectionView)
        self.view.addSubview(mainLabel)
    }
    
    func makeConstraints() {
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "ListGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListGameCollectionViewCell")
    }
    
    func refreshData() {
        mainLabel.text = "listGames".localized()
        gameList = ListGamesViewController.createGames()
        collectionView.reloadData()
    }
    
    static func createGames() -> [Game] {
        return [BullCowGame(title: "bullcow".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the mystery number".localize(), rules: "bullCow_rules".localize(), gameImage: "BullCow"), SlovusGame(title: "slovus".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the word in 6 moves".localize(), rules: "slovus_rules".localize(), gameImage: "slovusImage"), FloodFillGame(title: "flood_fill".localize(), createdBy: "Aliaksei Shamrei", descripton: "Paint the field one color".localize(), rules: "floodFill_rules".localize(), gameImage: "floodFillImage"), TicTacToeGame(title: "tictactoe".localize(), createdBy: "Nikita Shakalov", descripton: "Collect a line of three symbols".localize(), rules: "tictactoe_rules".localize(), gameImage: "tikTakToeImage"), BinarioGame(title: "binario".localize(), createdBy: "Aliaksei Shamrei", descripton: "Arrange the blue and red blocks".localize(), rules: "binario_rules".localize(), gameImage: "binarioImage"), NumbersGame(title: "Numbers".localize(), createdBy: "Aliaksei Shamrei", descripton: "Remove all the numbers from the field".localize(), rules: "numbers_rules".localize(), gameImage: "numbersImage")]
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    func selected(game: Game) {
        let viewController: UIViewController
        switch game.title {
        case "bullcow".localize():
            viewController = UIViewController()
            let view = UIHostingController(rootView: BullCowGameView())
            view.view.backgroundColor = CustomColor.viewColor.color
            view.modalPresentationStyle = .fullScreen
            present(view, animated: true)
        case "slovus".localize():
            let viewModel = SlovusViewModel(game: game)
            viewController = SlovusGameViewController(viewModel: viewModel)
        case "flood_fill".localize():
            let viewModel = FloodFillViewModel(game: game)
            viewController = FloodFillViewController(viewModel: viewModel)
        case "tictactoe".localize():
            let viewModel = TicTacToeViewModel(game: game)
            viewController = TicTacToeViewController(viewModel: viewModel)
        case "binario".localize():
            let viewModel = BinarioViewModel(game: game)
            viewController = BinarioViewController(viewModel: viewModel)
        default:
            let viewModel = NumbersViewModel(game: game)
            viewController = NumbersViewController(viewModel: viewModel)
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ListGamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ListGameCollectionViewCell
        if let reuseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListGameCollectionViewCell", for: indexPath) as? ListGameCollectionViewCell {
            cell = reuseCell
        } else {
            cell = ListGameCollectionViewCell()
        }
        
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: ListGameCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.gameNameLabel.text = gameList[indexPath.row].title
        cell.aboutGameLabel.text = gameList[indexPath.row].descripton
        cell.gameImageView.image = getImage(index: indexPath.row)
        return cell
    }
    
    func getImage(index: Int) -> UIImage {
        switch index {
        case 0: return UIImage(named: "bullCowImage")!
        case 1: return UIImage(named: "slovusImage")!
        case 2: return UIImage(named: "floodFillImage")!
        case 3: return UIImage(named: "tikTakToeImage")!
        case 4: return UIImage(named: "binarioImage")!
        default: return UIImage(named: "numbersImage")!
        }
    }
}

extension ListGamesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            let itemWidth = collectionViewWidth * 0.49
            let itemHeight = itemWidth * 1.3
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            let collectionViewWidth = collectionView.bounds.width
            let interitemSpacing = collectionViewWidth * 0.005
            return interitemSpacing
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = gameList[indexPath.row]
           selected(game: game)
    }
}
