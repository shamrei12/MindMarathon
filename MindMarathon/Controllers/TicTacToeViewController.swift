//
//  TicTacToeViewController.swift
//  MindMarathon
//
//  Created by Nikita  on 6/15/23.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    private var alertView: ResultAlertView!
    var vStackView: UIStackView!
    var hStackViewFirst: UIStackView!
    var hStackViewSecond: UIStackView!
    var hStackViewThird: UIStackView!
    var gameContainerView: UIView!
    var gameControllerView: UIView!
    var gameStatusBarView: UIView!
    var playButton: UIButton!
    var timerLabel: UILabel!
    var gameControllerStackView: UIStackView!
    
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
            button.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .bold)
            
            hStackViewThird.addArrangedSubview(button)
            buttonBoard[2][tag-6] = button
            counter += 1
            tag += 1
        }
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
        drawUserTurn(row: row, col: col)
        board[row][col] = "X"
        let isUserWon = checkForWinner(board: board, symbol: "X")
        
        if isUserWon {
            print("user won")
        }
        else {
            guard let position = computerMove(board: board) else {return}
            print(position)
            setComputerTurn(row: position.0, col: position.1)
        }
        print(board)
    }
    
    func setComputerTurn(row: Int, col: Int) {
        drawComputerTurn(row: row, col: col)
        board[row][col] = "O"
        let isComputerWon = checkForWinner(board: board, symbol: "O")
        
        if isComputerWon {
            print("computer won")
        }
        print(board)
    }
    
    func drawUserTurn(row: Int, col: Int) {
        buttonBoard[row][col].setTitleColor(.systemRed, for: .normal)
        buttonBoard[row][col].setTitle("X", for: .normal)
    }
   
    
    func drawComputerTurn(row: Int, col: Int) {
        buttonBoard[row][col].setTitleColor(.systemBlue, for: .normal)
        buttonBoard[row][col].setTitle("O", for: .normal)
    }
    
    // Функция для определения хода компьютера
    func computerMove(board: [[String]]) -> (Int, Int)? {
        // Проверяем, есть ли у компьютера возможность выиграть
        if let position = findWinningMove(board: board, symbol: "O") {
            return position
        }
        
        // Проверяем, есть ли у игрока возможность выиграть и блокируем его ход, если есть
        if let position = findWinningMove(board: board, symbol: "X") {
            return position
        }
        
        // Если нет возможности выиграть и блокировать игрока, выбираем случайную пустую клетку
        let emptyPositions = findEmptyPositions(board: board)
        if emptyPositions.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emptyPositions.count)))
            return emptyPositions[randomIndex]
        }
        
        // Если все клетки заняты и никто не выиграл, возвращаем nil
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
        
    }
    
    func pauseGame() {
        
    }
    
    func continueGame() {
        
    }
}
