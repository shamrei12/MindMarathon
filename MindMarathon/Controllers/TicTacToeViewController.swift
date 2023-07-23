//
//  TicTacToeViewController.swift
//  MindMarathon
//
//  Created by Nikita  on 6/15/23.
//

import UIKit

class TicTacToeViewController: UIViewController, AlertDelegate {
    
    private var ticTacToeManager: TicTacToeViewModel!
    private var alertView: ResultAlertView!
    var vStackView: UIStackView!
    var hStackViewFirst: UIStackView!
    var hStackViewSecond: UIStackView!
    var hStackViewThird: UIStackView!
    var gameContainerView: UIView!
    var gameControllerView: UIView!
    var gameStatusBarView: UIView!
    var gameStatusSpinner: UIActivityIndicatorView!
    var gameStatusPlayerLabel: UILabel!
    var gameStatusStackView: UIStackView!
    var playButton: UIButton!
    var gameControllerStackView: UIStackView!
    var seconds = 0
    var stepCount = 0
    private var stopwatch = Timer()
    
    private var computerThinkingTime = 0
    private var thinkingTimeElapsed = 0
    var computerThinkingTimer: Timer?
    
    var computerRow = 0
    var computerCol = 0
    
    var isstartGame = false
    var iscontinuePlaying = false
    
    var board: [[String]] =
    [["","",""],
     ["","",""],
     ["","",""]]
    
    var buttonBoard: [[UIButton]] = [
        [UIButton(), UIButton(), UIButton()],
        [ UIButton(), UIButton(), UIButton()],
        [ UIButton(), UIButton(), UIButton()]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.view.backgroundColor = UIColor(named: "viewColor")
        self.ticTacToeManager = TicTacToeViewModel()
        setupNavigationBar()
        createUI()
        createConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
    }
    
    func createUI() {
        gameControllerView = UIView()
        gameControllerView.layer.cornerRadius = 10
        gameControllerView.backgroundColor = .clear
        view.addSubview(gameControllerView)
        
        playButton = UIButton()
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = UIColor.white
        view.addSubview(playButton)
        
        gameControllerStackView = UIStackView()
        gameControllerStackView.addArrangedSubview(playButton)
        gameControllerStackView.distribution = .equalSpacing
        view.addSubview(gameControllerStackView)
        
        gameContainerView = UIView()
        gameContainerView.layer.cornerRadius = 20
        gameContainerView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameContainerView)
        
        gameStatusBarView = UIView()
        gameStatusBarView.layer.cornerRadius = 10
        gameStatusBarView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameStatusBarView)
        
        gameStatusStackView = UIStackView()
        gameStatusStackView.axis = .vertical
        gameStatusStackView.spacing = 6
        gameStatusBarView.addSubview(gameStatusStackView)
        
        gameStatusPlayerLabel = UILabel()
        gameStatusPlayerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gameStatusPlayerLabel.textColor = .label
        gameStatusPlayerLabel.textAlignment = .center
        gameStatusPlayerLabel.text = ""
        gameStatusStackView.addArrangedSubview(gameStatusPlayerLabel)
        
        gameStatusSpinner = UIActivityIndicatorView()
        gameStatusSpinner.color = .label
        gameStatusSpinner.startAnimating()
        
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
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(80)
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
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.15)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-70)
        }
        
        gameStatusStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func fillStackViews() {
        var counter = 1
        var tag = 0
        for _ in counter...3 {
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            button.backgroundColor = UIColor(named: "gameElementColor")
            button.isUserInteractionEnabled = false
            
            hStackViewFirst.addArrangedSubview(button)
            buttonBoard[0][tag] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3 {
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.backgroundColor = UIColor(named: "gameElementColor")
            button.isUserInteractionEnabled = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            
            hStackViewSecond.addArrangedSubview(button)
            buttonBoard[1][tag-3] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3 {
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.backgroundColor = UIColor(named: "gameElementColor")
            button.isUserInteractionEnabled = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            
            hStackViewThird.addArrangedSubview(button)
            buttonBoard[2][tag-6] = button
            counter += 1
            tag += 1
        }
    }
    
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
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 4)
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
        let isUserWon = ticTacToeManager.checkForWinner(board: board, symbol: "X")
        
        if isUserWon {
            createAlertMessage(description: "Поздравляем! Вы выиграли! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
            saveResult(result: WhiteBoardModel(nameGame: "Крестики Нолики", resultGame: "Победа", countStep: stepCount.description, timerGame: "\(seconds.description) с"))
        } else {
            guard let position = ticTacToeManager.computerMove(board: board) else {
                createAlertMessage(description: "Ничья! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
                saveResult(result: WhiteBoardModel(nameGame: "Крестики Нолики", resultGame: "Ничья", countStep: stepCount.description, timerGame: "\(seconds.description) с"))
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
        
       if thinkingTimeElapsed == computerThinkingTime {
            drawComputerTurn(row: computerRow, col: computerCol)
           let isComputerWon = ticTacToeManager.checkForWinner(board: board, symbol: "O")
           if isComputerWon {
               createAlertMessage(description: "Вы проиграли! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
               saveResult(result: WhiteBoardModel(nameGame: "Крестики Нолики", resultGame: "Поражение", countStep: stepCount.description, timerGame: "\(seconds.description) с"))
           }
            computerThinkingTimer?.invalidate()
            playerTurn()
        }
        
    }
    
    func drawUserTurn(row: Int, col: Int) {
        stepCount += 1
        buttonBoard[row][col].setImage(UIImage(named: "X"), for: .normal)
        buttonBoard[row][col].isUserInteractionEnabled = false
    }
    
    func drawComputerTurn(row: Int, col: Int) {
        buttonBoard[row][col].setImage(UIImage(named: "O"), for: .normal)
        buttonBoard[row][col].isUserInteractionEnabled = false
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
    
    func createAlertMessage(description: String) {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.6
            self.view.isUserInteractionEnabled = false
        }
        stopwatch.invalidate()
        alertView = ResultAlertView.loadFromNib() as? ResultAlertView
        alertView.delegate = self
        alertView.descriptionLabel.text = description
        UIApplication.shared.keyWindow?.addSubview(alertView)
        alertView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)
        
    }
    
    @objc func startGameTapped(_ sender: UIButton) {
        let chekPartGame = (isstartGame, iscontinuePlaying)
        gameStatusPlayerLabel.text = "Ваш ход!"
        if chekPartGame == (false, false) {
            isstartGame = true
            iscontinuePlaying = true
            startNewGame()
        } else if chekPartGame == (true, true) {
            iscontinuePlaying = false
            pauseGame()
        } else {
            iscontinuePlaying = true
            continueGame()
        }
    }
    
    func startNewGame() {
        playerTurn()
        seconds = 0
        createTimer()
        openGameField()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func continueGame() {
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createTimer()
        openGameField()
    }
    
    func pauseGame() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        navigationItem.title = "PAUSE"
        stopwatch.invalidate()
        closeGameField()
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        clearGameField()
        computerThinkingTime = 0
        computerThinkingTimer?.invalidate()
        alertView.removeFromSuperview()
        startNewGame()
        isstartGame = true
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
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
}
