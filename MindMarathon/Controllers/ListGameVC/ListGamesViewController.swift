//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit

class ListGamesViewController: UIViewController {
  
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var gameList: [Game] = ListGamesViewController.createGames()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupCollectionView()
        createUI()
        fisrStart()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func fisrStart() {
        UserDefaultsManager.shared.checkFirstStart()
    }
    
    func refreshData() {
        gameList = ListGamesViewController.createGames()
        collectionView.reloadData()
    }
    
    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        let titleLabel = UILabel()
        titleLabel.text = "Список игр".localize()
        
        titleLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        navigationItem.titleView = titleLabel
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "ListGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListGameCollectionViewCell")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.95)
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    static func createGames() -> [Game] {
        return [BullCowGame(title: "bullcow".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the mystery number".localize(), rules: "bullCow_rules".localize(), gameImage: "BullCow"), SlovusGame(title: "slovus".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the word in 6 moves".localize(), rules: "slovus_rules".localize(), gameImage: "slovusImage"), FloodFillGame(title: "flood_fill".localize(), createdBy: "Aliaksei Shamrei", descripton: "Paint the field one color".localize(), rules: "floodFill_rules".localize(), gameImage: "floodFillImage"), TicTacToeGame(title: "tictactoe".localize(), createdBy: "Nikita Shakalov", descripton: "Collect a line of three symbols".localize(), rules: "tictactoe_rules".localize(), gameImage: "tikTakToeImage"), BinarioGame(title: "binario".localize(), createdBy: "Aliaksei Shamrei", descripton: "Arrange the blue and red blocks".localize(), rules: "binario_rules".localize(), gameImage: "binarioImage"), NumbersGame(title: "Numbers".localize(), createdBy: "Aliaksei Shamrei", descripton: "Remove all the numbers from the field".localize(), rules: "numbers_rules".localize(), gameImage: "numbersImage")]
    }

    func createUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    func selected(game: Game) {
        let viewController: UIViewController
        switch game.title {
        case "bullcow".localize():
            let viewModel = BullCowViewModel(game: game)
            viewController = BullCowViewController(viewModel: viewModel)
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
