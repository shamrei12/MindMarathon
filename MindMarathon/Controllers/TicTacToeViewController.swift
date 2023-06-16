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
