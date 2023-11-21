//
//  TicTacToeViewController.swift
//  MindMarathon
//
//  Created by Nikita  on 6/15/23.
//

import UIKit

class TicTacToeViewController: UIViewController {
    private var viewModel: TicTacToeViewModel
    private var vStackView: UIStackView!
    private var hStackViewFirst: UIStackView!
    private var hStackViewSecond: UIStackView!
    private var hStackViewThird: UIStackView!
    private var gameContainerView: UIView!
    private var gameControllerView: UIView!
    private var gameStatusBarView: UIView!
    private var gameStatusSpinner: UIActivityIndicatorView!
    private var gameStatusPlayerLabel: UILabel!
    private var gameStatusStackView: UIStackView!
    private let playButton = UIButton()
    private var gameControllerStackView: UIStackView!
    private var seconds = 0
    private var stepCount = 0
    private var stopwatch = Timer()
    
    private var computerThinkingTime = 0
    private var thinkingTimeElapsed = 0
    var computerThinkingTimer: Timer?
    
    var computerRow = 0
    var computerCol = 0
    
    var isStartGame = false
    var iscontinuePlaying = false
    
    var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    
    var buttonBoard: [[UIButton]] = [
        [UIButton(), UIButton(), UIButton()],
        [ UIButton(), UIButton(), UIButton()],
        [ UIButton(), UIButton(), UIButton()]]
    
    init(viewModel: TicTacToeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        createUIElements()
        createConstraints()
    }
    
    //MARK: - UI Setup
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила".localize(), style: .plain, target: self, action: #selector(rulesTapped))
    }
    
    func createUIElements() {
        setupBackgroundColor()
        setupGameControllerView()
        playButtonCreated() 
        setupGameControllerStackView()
        setupGameContainerView()
        setupGameStatusBarView()
        setupGameStatusStackView()
        setupGameStatusPlayerLabel()
        setupGameStatusSpinner()
        setupHorizontalStackViews()
        setupVerticalStackView()
    }
    
    func setupBackgroundColor() {
        self.view.backgroundColor = UIColor(named: "viewColor")
    }
    
    func setupGameControllerView() {
        gameControllerView = UIView()
        gameControllerView.layer.cornerRadius = 10
        gameControllerView.backgroundColor = .clear
        view.addSubview(gameControllerView)
    }
    
    func playButtonCreated() {
        playButton.setImage(Icons.playFill, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = UIColor.white
        playButton.addShadow()
        view.addSubview(playButton)
    }
    
    func setupGameControllerStackView() {
        gameControllerStackView = UIStackView()
        gameControllerStackView.addArrangedSubview(playButton)
        gameControllerStackView.distribution = .equalSpacing
        view.addSubview(gameControllerStackView)
    }
    
    func setupGameContainerView() {
        gameContainerView = UIView()
        gameContainerView.layer.cornerRadius = 20
        gameContainerView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameContainerView)
    }
    
    func setupGameStatusBarView() {
        gameStatusBarView = UIView()
        gameStatusBarView.layer.cornerRadius = 10
        gameStatusBarView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameStatusBarView)
    }
    
    func setupGameStatusStackView() {
        gameStatusStackView = UIStackView()
        gameStatusStackView.axis = .vertical
        gameStatusStackView.spacing = 6
        gameStatusBarView.addSubview(gameStatusStackView)
    }
    
    func setupGameStatusPlayerLabel() {
        gameStatusPlayerLabel = UILabel()
        gameStatusPlayerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gameStatusPlayerLabel.textColor = .label
        gameStatusPlayerLabel.textAlignment = .center
        gameStatusPlayerLabel.text = ""
        gameStatusStackView.addArrangedSubview(gameStatusPlayerLabel)
    }
    
    func setupGameStatusSpinner() {
        gameStatusSpinner = UIActivityIndicatorView()
        gameStatusSpinner.color = .label
        gameStatusSpinner.startAnimating()
    }
    
    func setupHorizontalStackViews() {
        hStackViewFirst = UIStackView()
        hStackViewFirst.axis = .horizontal
        hStackViewFirst.distribution = .fillEqually
        hStackViewFirst.spacing = 5
        hStackViewFirst.layer.cornerRadius = 10
        hStackViewFirst.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(hStackViewFirst)
        
        hStackViewSecond = UIStackView()
        hStackViewSecond.axis = .horizontal
        hStackViewSecond.distribution = .fillEqually
        hStackViewSecond.spacing = 5
        hStackViewSecond.layer.cornerRadius = 10
        hStackViewSecond.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(hStackViewSecond)
        
        hStackViewThird = UIStackView()
        hStackViewThird.axis = .horizontal
        hStackViewThird.distribution = .fillEqually
        hStackViewThird.spacing = 5
        hStackViewThird.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(hStackViewThird)
    }
    
    func setupVerticalStackView() {
        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.addArrangedSubview(hStackViewFirst)
        vStackView.addArrangedSubview(hStackViewSecond)
        vStackView.addArrangedSubview(hStackViewThird)
        vStackView.spacing = 5
        vStackView.distribution = .fillEqually
        vStackView.backgroundColor = UIColor(hex: 0x8c9197)
        self.view.addSubview(vStackView)
        fillStackViews()
    }
    
    func createConstraints() {
        vStackView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.9)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
        gameControllerView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0.1)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.09)
        }
        
        gameControllerStackView.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(gameControllerView).inset(10)
            maker.left.right.equalTo(gameControllerView).inset(50)
        }
        
        gameContainerView.snp.makeConstraints { make in
            make.width.equalTo(gameControllerView)
            make.height.equalTo(gameControllerView.snp.width)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        gameStatusBarView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.1)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).inset(20)
        }
        
        gameStatusStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func createButton(tag: Int) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
        button.tag = tag
        button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        button.backgroundColor = UIColor(named: "gameElementColor")
        button.isUserInteractionEnabled = false
        return button
    }
    
    func fillStackViews() {
        var counter = 1
        var tag = 0
        for _ in counter...3 {
            let button = createButton(tag: tag)
            hStackViewFirst.addArrangedSubview(button)
            buttonBoard[0][tag] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3 {
            let button = createButton(tag: tag)
            hStackViewSecond.addArrangedSubview(button)
            buttonBoard[1][tag-3] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3 {
            let button = createButton(tag: tag)
            hStackViewThird.addArrangedSubview(button)
            buttonBoard[2][tag-6] = button
            counter += 1
            tag += 1
        }
    }
    // MARK: - Field Controls
    func openGameField() {
        for row in buttonBoard {
            for button in row {
                button.isUserInteractionEnabled = true
            }
        }
    }
    
    func closeGameField() {
        for row in buttonBoard {
            for button in row {
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func clearGameField() {
        for row in buttonBoard {
            for button in row {
                button.isUserInteractionEnabled = false
                button.setImage(UIImage(), for: .normal)
            }
        }
        board = [["", "", ""], ["", "", ""], ["", "", ""]]
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController(game: viewModel.game)
        rulesVC.modalPresentationStyle = .formSheet
        present(rulesVC, animated: true)
    }
    
    func playerTurn() {
        self.view.isUserInteractionEnabled = true
        self.gameStatusStackView.removeArrangedSubview(gameStatusSpinner)
        self.gameStatusSpinner.removeFromSuperview()
        self.gameStatusPlayerLabel.text = "Ваш ход!"
    }
    
    func computerTurn() {
        self.view.isUserInteractionEnabled = false
        self.gameStatusStackView.addArrangedSubview(gameStatusSpinner)
        self.gameStatusPlayerLabel.text = "Компьютер думает..."
        self.gameStatusSpinner.startAnimating()
    }
    
    @objc func playerMove(_ sender: UIButton) {
        var row = 0
        var col = 0
        switch sender.tag {
        case 0:
            row = 0
            col = 0
            setUserTurn(row: row, col: col)
        case 1:
            row = 0
            col = 1
            setUserTurn(row: row, col: col)
        case 2:
            row = 0
            col = 2
            setUserTurn(row: row, col: col)
        case 3:
            row = 1
            col = 0
            setUserTurn(row: row, col: col)
        case 4:
            row = 1
            col = 1
            setUserTurn(row: row, col: col)
        case 5:
            row = 1
            col = 2
            setUserTurn(row: row, col: col)
        case 6:
            row = 2
            col = 0
            setUserTurn(row: row, col: col)
        case 7:
            row = 2
            col = 1
            setUserTurn(row: row, col: col)
        case 8:
            row = 2
            col = 2
            setUserTurn(row: row, col: col)
        default: return
        }
    }
    
    func setUserTurn(row: Int, col: Int) {
        thinkingTimeElapsed = 0
        drawUserTurn(row: row, col: col)
        board[row][col] = "X"
        let isUserWon = viewModel.checkForWinner(board: board, symbol: "X")
        
        if isUserWon {
            stopwatch.invalidate()
            showAlertAboutFinishGame(title: "End game".localize(), message: "congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            saveResult(result: WhiteBoardModel(nameGame: "tictactoe".localize(), resultGame: "Win".localize(), countStep: stepCount.description, timerGame:  seconds))
            CheckTaskManager.shared.checkPlayGame(game: 2)
        } else {
            guard let position = viewModel.computerMove(board: board) else {
                stopwatch.invalidate()
                showAlertAboutFinishGame(title: "End game".localize(), message: "draw_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
                saveResult(result: WhiteBoardModel(nameGame: "tictactoe".localize(), resultGame: "Draw".localize(), countStep: stepCount.description, timerGame:  seconds))
                return
            }
            setComputerTurn(row: position.0, col: position.1)
        }
    }
    
    func setComputerTurn(row: Int, col: Int) {
        self.computerRow = row
        self.computerCol = col
        computerTurn()
        
        setCountdownTimer()
        board[row][col] = "O"
    }
    
    func setCountdownTimer() {
        computerThinkingTime = Int.random(in: 1...3)
        
        computerThinkingTimer = Timer.scheduledTimer(timeInterval: 1,
                                                     target: self,
                                                     selector: #selector(updateComputerThinking),
                                                     userInfo: nil,
                                                     repeats: true)
    }
    
    @objc func updateComputerThinking() {
        thinkingTimeElapsed += 1
        
        if thinkingTimeElapsed >= computerThinkingTime {
            drawComputerTurn(row: computerRow, col: computerCol)
            let isComputerWon = viewModel.checkForWinner(board: board, symbol: "O")
            if isComputerWon {
                stopwatch.invalidate()
                showAlertAboutFinishGame(title: "End game".localize(), message: "defeat_message".localize() + "time_message".localize() + " \(TimeManager.shared.convertToMinutes(seconds: seconds))")
                saveResult(result: WhiteBoardModel(nameGame: "tictactoe".localize(), resultGame: "Lose".localize(), countStep: stepCount.description, timerGame:  seconds))
            } else {
                computerThinkingTimer?.invalidate()
                playerTurn()
            }
            
        }
    }
    
    
    
    func drawUserTurn(row: Int, col: Int) {
        stepCount += 1
        buttonBoard[row][col].setImage(UIImage(named: "X"), for: .normal)
        buttonBoard[row][col].subviews.first?.contentMode = .scaleAspectFit
        buttonBoard[row][col].isUserInteractionEnabled = false
    }
    
    func drawComputerTurn(row: Int, col: Int) {
        let image = UIImage(named: "O")
        buttonBoard[row][col].setImage(image, for: .normal)
        buttonBoard[row][col].isUserInteractionEnabled = false
    }
    
    // MARK: - Game Controls
    
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
    
    @objc func startGameTapped(_ sender: UIButton) {
        let chekPartGame = (isStartGame, iscontinuePlaying)
        gameStatusPlayerLabel.text = "Ваш ход!"
        if chekPartGame == (false, false) {
            startNewGame()
        } else if chekPartGame == (true, true) {
            pauseGame()
            showAlertAboutFinishGame()
        } else {
            continueGame()
        }
    }
    
    func showAlertAboutFinishGame() {
        let alertController = UIAlertController(title: "Attention!".localize(), message: "Do you really want to finish the game?".localize(), preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
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
    
    func startNewGame() {
        playerTurn()
        seconds = 0
        createTimer()
        openGameField()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isStartGame = true
        iscontinuePlaying = true
    }
    
    func continueGame() {
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createTimer()
        openGameField()
        iscontinuePlaying = true
    }
    
    func pauseGame() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        navigationItem.title = "PAUSE"
        stopwatch.invalidate()
        closeGameField()
        iscontinuePlaying = false
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        clearGameField()
        computerThinkingTime = 0
        computerThinkingTimer?.invalidate()
        startNewGame()
        isStartGame = true
        iscontinuePlaying = true
    }
    
    func saveResult(result: WhiteBoardModel) {
        RealmManager.shared.saveResult(result: result)
    }
    
    func exitGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        self.dismiss(animated: true)
    }
}
