//
//  NumbersViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.09.23.
//

import UIKit
import SnapKit

protocol FinishGameDelegate: AnyObject {
    func alertResult()
}

class NumbersViewController: UIViewController, FinishGameDelegate {
    func alertResult() {
        stopwatch?.invalidate()
        showAlertAboutFinishGame(title: "End game".localize(), message: "congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
        let resultGame = WhiteBoardModel(nameGame: "Numbers".localize(), resultGame: "Win".localize(), countStep: "-", timerGame:  seconds)
        RealmManager.shared.saveResult(result: resultGame)
        CheckTaskManager.shared.checkPlayGame(game: 5)
    }
    
    private let viewModel: NumbersViewModel
    private var collectionView: NumberCollectionView!
    
    private let playButton = UIButton()
    private let panelControllStackView = UIStackView()
    private let panelControllView = UIView()
    private let gameView = UIView()
    private let gameCollectionView: UICollectionView
    private var stopwatch: Timer?
    private let addNumbersButton = UIButton()
    private let movesСheck = UIButton()
    private let gameControlStackView = UIStackView()
    
    private var seconds: Int = .zero
    private var isstartGame = false
    private var iscontinuePlaying = false

//    private var massiveButtons = [[UIButton]]()
    
    init(viewModel: NumbersViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        gameCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func createTimer() {
        stopwatch = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        navigationItem.title = TimeManager.shared.convertToMinutes(seconds: seconds)
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        navigationBarCreate()
        panelControlCreated()
        createGameControlStackView()
    }
    
    func createAddNumbersButton() -> UIButton {
        addNumbersButton.layer.cornerRadius = 10
        addNumbersButton.backgroundColor = .systemGreen
        addNumbersButton.setTitle("Добавить".localize(), for: .normal)
        addNumbersButton.setTitleColor(.white, for: .normal)
        addNumbersButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        addNumbersButton.addTarget(self, action: #selector(addNumbers), for: .touchUpInside)
        addNumbersButton.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        addNumbersButton.titleLabel!.minimumScaleFactor = 0.1
        addNumbersButton.addShadow()
        
        view.addSubview(addNumbersButton)
////        
        addNumbersButton.snp.makeConstraints { maker in
            maker.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.7)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.08)
        }
//        
        return addNumbersButton
    }
    
    func createMovesСheckButton() -> UIButton {
        movesСheck.layer.cornerRadius = 10
        movesСheck.backgroundColor = .systemGray
        movesСheck.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        movesСheck.scalesLargeContentImage = true
        movesСheck.showsLargeContentViewer = true
        movesСheck.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large), forImageIn: .normal)
        movesСheck.tintColor = .white
        movesСheck.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        movesСheck.addTarget(self, action: #selector(showPossibleMove), for: .touchUpInside)
        movesСheck.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        movesСheck.titleLabel!.minimumScaleFactor = 0.1
        movesСheck.addShadow()
        
        return movesСheck
    }
    
    func createGameControlStackView() {
        gameControlStackView.axis = .horizontal
        gameControlStackView.distribution = .fillEqually
        gameControlStackView.spacing = 20
        gameControlStackView.addArrangedSubview(createMovesСheckButton())
        gameControlStackView.addArrangedSubview(createAddNumbersButton())

        view.addSubview(gameControlStackView)
    
        gameControlStackView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.08)
            
        }
        
    }
    
    @objc func addNumbers() {
        guard isstartGame else {
            return
        }
        collectionView.createMassiveWhenAddbuttonWasTapped()
    }
    
    @objc func showPossibleMove() {
        guard isstartGame else {
            return
        }

        collectionView.showPossibleMoveWhenPossibleMoveWasTapped()
    }
    
    func collectionViewCreated() {
        collectionView = NumberCollectionView()
        if let collectionView = collectionView {
            collectionView.delegate = self
        } else {
            print("Error")
        }
        collectionView.setupView(massive: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "1", "1", "1", "2", "1", "3", "1", "4", "1", "5", "1", "6", "1", "7", "1", "8"]
)
        gameView.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalTo(gameView).inset(5)
        }
    }
    
    private func panelControlCreated() {
        createPlayButton()
        panelControlCreate()
    }
    
    private func navigationBarCreate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rules".localize(), style: .plain, target: self, action: #selector(rulesTapped))
    }
    
    private func createPlayButton() {
        playButton.setImage(Icons.playFill, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = .white
        playButton.addShadow()
        
        view.addSubview(playButton)
    }
    
    private func panelControlCreate() {
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .clear
        
        view.addSubview(panelControllView)
        
        panelControllStackView.addArrangedSubview(playButton)
        panelControllStackView.axis = .horizontal
        panelControllStackView.spacing = 10
        panelControllStackView.distribution = .fillEqually
        
        view.addSubview(panelControllStackView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0.1)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.095)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
    }
    
    func createGameView() {
        gameView.backgroundColor = .clear
        view.addSubview(gameView)
        
        gameView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-20)
            maker.width.equalToSuperview()
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.7)
        }
        
        collectionViewCreated()
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController(game: viewModel.game)
        rulesVC.modalPresentationStyle = .formSheet
        present(rulesVC, animated: true)
    }
    
    @objc func startGameTapped(_ sender: UIButton) {
            let chekPartGame = (isstartGame, iscontinuePlaying)
            if chekPartGame == (false, false) {
                startNewGame()
                isstartGame = true
                iscontinuePlaying = true
            } else if chekPartGame == (true, true) {
                pauseGame()
                showAlertAboutFinishGame()
            } else {
                iscontinuePlaying = true
                continueGame()
            }
        }
    
    func startNewGame() {
        createTimer()
        createGameView()
        playButton.setImage(Icons.pauseFill, for: .normal)
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(Icons.pauseFill, for: .normal)
        iscontinuePlaying = true
    }
    
    func pauseGame() {
        playButton.setImage(Icons.playFill, for: .normal)
        stopwatch?.invalidate()
        navigationItem.title = "PAUSE"
    }
    
    func exitGame() {
        collectionView.clearCollectionView()
        self.dismiss(animated: true)
    }
    
    func restartGame() {
        pauseGame()
        collectionView.clearCollectionView()
        seconds = 0
        isstartGame = false
        iscontinuePlaying = false
    }
}

extension NumbersViewController {
    func showAlertAboutFinishGame() {
        let alertController = UIAlertController(title: "Attention!".localize(), message: "Do you really want to finish the game?".localize(), preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue".localize(), style: .default) { _ in
            self.continueGame() // Вызов функции 1 при нажатии кнопки "Продолжить"
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
            self.restartGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAboutFinishGame(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "New game".localize(), style: .default) { _ in
            self.restartGame()
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
            self.exitGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
