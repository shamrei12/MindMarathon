//
//  TicTacToeViewController.swift
//  MindMarathon
//
//  Created by Nikita  on 6/15/23.
//

import UIKit

class TicTacToeViewController: UIViewController, AlertDelegate {
    
    
   
    
    
    private var alertView: ResultAlertView!
    var vStackView: UIStackView!
    var hStackViewFirst: UIStackView!
    var hStackViewSecond: UIStackView!
    var hStackViewThird: UIStackView!
    var gameContainerView: UIView!
    var gameControllerView: UIView!
    var gameStatusBarView: UIView!
    var gameStatusBarComputerLabel: UILabel!
    var gameStatusSpinner: UIActivityIndicatorView!
    var gameStatusPlayerLabel: UILabel!
    var playButton: UIButton!
    var timerLabel: UILabel!
    var gameControllerStackView: UIStackView!
    var seconds = 0
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
        gameControllerView.backgroundColor = .systemBackground
        view.addSubview(gameControllerView)
        
        playButton = UIButton()
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(playButton)
        
        timerLabel = UILabel()
        timerLabel.text = "0"
        timerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        gameControllerStackView = UIStackView()
        gameControllerStackView.addArrangedSubview(playButton)
        gameControllerStackView.addArrangedSubview(timerLabel)
        gameControllerStackView.distribution = .equalCentering
        view.addSubview(gameControllerStackView)
        
        
        gameContainerView = UIView()
        gameContainerView.layer.cornerRadius = 10
        gameContainerView.backgroundColor = .systemBackground
        view.addSubview(gameContainerView)
        
        gameStatusBarView = UIView()
        gameStatusBarView.layer.cornerRadius = 10
        gameStatusBarView.backgroundColor = .systemBackground
        view.addSubview(gameStatusBarView)
        
        gameStatusBarComputerLabel = UILabel()
        gameStatusBarComputerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gameStatusBarComputerLabel.textColor = .black
        gameStatusBarComputerLabel.textAlignment = .center
        gameStatusBarComputerLabel.text = "Компьютер думает..."
        gameStatusBarComputerLabel.alpha = 0
        gameStatusBarView.addSubview(gameStatusBarComputerLabel)
        
        
        gameStatusPlayerLabel = UILabel()
        gameStatusPlayerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gameStatusPlayerLabel.textColor = .black
        gameStatusPlayerLabel.textAlignment = .center
        gameStatusPlayerLabel.text = "Ваш ход!"
        gameStatusBarView.addSubview(gameStatusPlayerLabel)
        
        
        gameStatusSpinner = UIActivityIndicatorView()
        gameStatusSpinner.color = .black
        gameStatusSpinner.startAnimating()
        gameStatusSpinner.alpha = 0
        self.gameStatusBarView.addSubview(gameStatusSpinner)
        
        hStackViewFirst = UIStackView()
        hStackViewFirst.axis = .horizontal
        hStackViewFirst.distribution = .fillEqually
        hStackViewFirst.spacing = 5
        hStackViewFirst.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(hStackViewFirst)
        
        hStackViewSecond = UIStackView()
        hStackViewSecond.axis = .horizontal
        hStackViewSecond.distribution = .fillEqually
        hStackViewSecond.spacing = 5
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
        vStackView.backgroundColor = .systemGray2
        
        self.view.addSubview(vStackView)
        fillStackViews()
    }
    
    
    func createConstraints() {
        vStackView.snp.makeConstraints { make in
            make.width.height.equalTo(350)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
        gameControllerView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        gameControllerStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(gameControllerView).inset(10)
        }
        
        gameContainerView.snp.makeConstraints { make in
            make.width.equalTo(gameControllerView)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        gameStatusBarView.snp.makeConstraints { make in
            make.width.equalTo(gameControllerView)
            make.height.equalTo(gameControllerView).multipliedBy(2)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-50)
        }
        
        gameStatusBarComputerLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(gameStatusBarView).offset(-15)
            make.centerX.equalToSuperview()
        }
        
        gameStatusSpinner.snp.makeConstraints { make in
            make.centerX.equalTo(gameStatusBarComputerLabel)
            make.top.equalTo(gameStatusBarComputerLabel).offset(30)
        }
        
        gameStatusPlayerLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func fillStackViews() {
        var counter = 1
        var tag = 0
        for _ in counter...3{
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            button.backgroundColor = .systemBackground
            button.isUserInteractionEnabled = false
            
            hStackViewFirst.addArrangedSubview(button)
            buttonBoard[0][tag] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3{
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.backgroundColor = .systemBackground
            button.isUserInteractionEnabled = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            
            hStackViewSecond.addArrangedSubview(button)
            buttonBoard[1][tag-3] = button
            counter += 1
            tag += 1
        }
        counter = 1
        for _ in counter...3{
            let button = UIButton()
            button.addTarget(self, action: #selector(playerMove), for: .touchUpInside)
            button.tag = tag
            button.backgroundColor = .systemBackground
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
                button.setTitle("", for: .normal)
            }
        }
        board = [["","",""], ["","",""], ["","",""]]
       
    }
    
    @objc func cancelTapped() {
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController.instantiate()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 4)
        present(rulesVC, animated: true)
    }
    
    
    func playerTurn() {
        self.view.isUserInteractionEnabled = true 
        gameStatusPlayerLabel.alpha = 1
        
        gameStatusBarComputerLabel.alpha = 0
        gameStatusSpinner.stopAnimating()
        gameStatusBarComputerLabel.alpha = 0
    }
    
    func computerTurn() {
        self.view.isUserInteractionEnabled = false
        
        gameStatusPlayerLabel.alpha = 0
        
        gameStatusBarComputerLabel.alpha = 1
        gameStatusSpinner.alpha = 1
        gameStatusSpinner.startAnimating()
    }
    
    @objc func playerMove(_ sender: UIButton) {
        print(sender.tag)
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
        let isUserWon = checkForWinner(board: board, symbol: "X")
        
        if isUserWon {
            print("user won")
            createAlertMessage(description: "Поздравляем! Вы выиграли! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
        }
        else {
            guard let position = computerMove(board: board) else {
                createAlertMessage(description: "Ничья! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
                return
             }
            print(position)
            setComputerTurn(row: position.0, col: position.1)
        }
        print(board)
    }
    
    func setComputerTurn(row: Int, col: Int) {
        self.computerRow = row
        self.computerCol = col
        
        computerTurn()
      
        setCountdownTimer()
        board[row][col] = "O"
      
        print(board)
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
           let isComputerWon = checkForWinner(board: board, symbol: "O")
           if isComputerWon {
               print("computer won")
               createAlertMessage(description: "Вы проиграли! Время вашей игры: \(TimeManager.shared.convertToMinutes(seconds: seconds))")
           }
            computerThinkingTimer?.invalidate()
            playerTurn()
        }
        
    }
    
    func drawUserTurn(row: Int, col: Int) {
        buttonBoard[row][col].setTitleColor(.systemRed, for: .normal)
        buttonBoard[row][col].setTitle("X", for: .normal)
        buttonBoard[row][col].isUserInteractionEnabled = false
    }
   
    
    func drawComputerTurn(row: Int, col: Int) {
        buttonBoard[row][col].setTitleColor(.systemBlue, for: .normal)
        buttonBoard[row][col].setTitle("O", for: .normal)
        buttonBoard[row][col].isUserInteractionEnabled = false
    }
    
    // Функция для определения хода компьютера
    func computerMove(board: [[String]]) -> (Int, Int)? {
        // Проверяем, есть ли у компьютера возможность выиграть
        if let position = findWinningMove(board: board, symbol: "O") {
            return position
        }
        
        // Проверяем, есть ли у пользователя возможность выиграть и блокируем его ход, если есть
        if let position = findWinningMove(board: board, symbol: "X") {
            return position
        }
        
        // Выбираем случайную пустую клетку
        let emptyPositions = findEmptyPositions(board: board)
        if emptyPositions.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emptyPositions.count)))
            return emptyPositions[randomIndex]
        }
        
        // Если все клетки заняты и никто не выиграл, возвращаем nil, что означает ничью
        return nil
    }


    // Функция для поиска пустых клеток на доске
    func findEmptyPositions(board: [[String]]) -> [(Int, Int)] {
        var emptyPositions = [(Int, Int)]()
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col] == "" {
                    emptyPositions.append((row, col))
                }
            }
        }
        return emptyPositions
    }
    
    // Функция для поиска выигрышного хода
    func findWinningMove(board: [[String]], symbol: String) -> (Int, Int)? {
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col] == "" {
                    // Проверяем, выиграет ли игрок, если он поставит свой символ на эту клетку
                    var newBoard = board
                    newBoard[row][col] = symbol
                    if checkForWinner(board: newBoard, symbol: symbol) {
                        return (row, col)
                    }
                }
            }
        }
        return nil
    }
    
    func checkForWinner(board: [[String]], symbol: String) -> Bool {
        // Проверяем горизонтали
        for row in 0..<board.count {
            if board[row][0] == symbol && board[row][1] == symbol && board[row][2] == symbol {
                return true
            }
        }
        
        // Проверяем вертикали
        for col in 0..<board[0].count {
            if board[0][col] == symbol && board[1][col] == symbol && board[2][col] == symbol {
                return true
            }
        }
        
        // Проверяем диагонали
        if board[0][0] == symbol && board[1][1] == symbol && board[2][2] == symbol {
            return true
        }
        if board[0][2] == symbol && board[1][1] == symbol && board[2][0] == symbol {
            return true
        }
        
        // Если нет победителя, возвращаем false
        return false
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
        timerLabel.text = TimeManager.shared.convertToMinutes(seconds: seconds)
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
        timerLabel.text = "0"
        isstartGame = true
        iscontinuePlaying = true
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
