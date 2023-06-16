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
    
    var board: [TicTacToeCell] = [
        TicTacToeCell(),  TicTacToeCell(),  TicTacToeCell(),
        TicTacToeCell(),  TicTacToeCell(),  TicTacToeCell(),
        TicTacToeCell(),  TicTacToeCell(),  TicTacToeCell()]
    
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
            make.height.equalToSuperview().multipliedBy(0.65)
            make.centerX.equalTo(self.view)
            make.top.equalTo(gameControllerView.snp.bottom).offset(20)
        }
    }
    
    func fillStackViews() {
        var counter = 1
        
        for _ in counter...3{
            let button = UIButton()
            button.backgroundColor = .systemBackground
            hStackViewFirst.addArrangedSubview(button)
            counter += 1
        }
        counter = 1
        for _ in counter...3{
            let button = UIButton()
            button.backgroundColor = .systemBackground
            hStackViewSecond.addArrangedSubview(button)
            counter += 1
        }
        counter = 1
        for _ in counter...3{
            let button = UIButton()
            button.backgroundColor = .systemBackground
            hStackViewThird.addArrangedSubview(button)
            counter += 1
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
