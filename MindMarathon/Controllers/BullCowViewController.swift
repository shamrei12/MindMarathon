//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class BullCowViewController: UIViewController, AlertDelegate {
    private let tableview = UITableView()
    private let countButton = UIButton()
    private let userDiggitLabel = UILabel()
    //    private let dashBoardTextView = UITextView()
    private let timerLabel = UILabel()
    private let deleteLastButton = UIButton()
    private let sendDiggits = UIButton()
    private let playButton = UIButton()
    
    private var stopwatch = Timer()
    private var seconds: Int = 0
    private var isStartGame: Bool = false
    private var isContinueGame: Bool = false
    private var game: BullCowViewModel!
    private var computerDiggit = [Int]()
    private var maxLenght: Int = 4
    private var countStep: Int = 0
    private var indexMass: Int = 0
    
    private var alertView: ResultAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        game = BullCowViewModel()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        navigationItem.title = "Быки и Коровы"
        userDiggitLabel.text = ""
        self.view.backgroundColor = UIColor(named: "viewColor")
        tableview.register(UINib(nibName: "BullCowTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowTableViewCell")
        tableview.register(UINib(nibName: "BullCowAlertTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowAlertTableViewCell")
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        createUIElements()
        //        tableview.reloadData()
    }
    
    func createUIElements() {
        let panelControllStackView = UIStackView()
        let panelInputContollStackView = UIStackView()
        let twiceInputLayerStackView = UIStackView()
        let firstLayerStackView = UIStackView()
        let secondLayerStackView = UIStackView()
        let panelControllView = UIView()
        let panelIntputControlView = UIView()
        let userLabelPanelStackView = UIStackView()
        
        //ButtonsDiggits
        let zeroTapped = UIButton()
        let oneTapped = UIButton()
        let twoTapped = UIButton()
        let threeTapped = UIButton()
        let fourTapped = UIButton()
        let fiveTapped = UIButton()
        let sixTapped = UIButton()
        let sevenTapped = UIButton()
        let eightTapped = UIButton()
        let nineTapped = UIButton()
        let sendDiggitsButton = UIButton()
        let massDiggit = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        let massButton = [oneTapped, twoTapped, threeTapped, fourTapped, fiveTapped, sixTapped, sevenTapped, eightTapped, nineTapped, zeroTapped]
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(panelControllView)
        
        countButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        countButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        countButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        countButton.setTitle("4", for: .normal)
        countButton.tintColor = UIColor.label
        countButton.backgroundColor = UIColor.tertiaryLabel
        countButton.layer.cornerRadius = 10
        view.addSubview(countButton)
        
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameButton), for: .touchUpInside)
        playButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(countButton)
        
        timerLabel.text = "0"
        timerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        panelControllStackView.addArrangedSubview(countButton)
        panelControllStackView.addArrangedSubview(playButton)
        panelControllStackView.addArrangedSubview(timerLabel)
        panelControllStackView.distribution = .equalCentering
        view.addSubview(panelControllStackView)
        
        view.addSubview(tableview)
        
        deleteLastButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteLastButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        deleteLastButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        deleteLastButton.addTarget(self, action: #selector(deleteLastTapped), for: .touchUpInside)
        
        
        for (index, button) in massButton.enumerated() {
            button.tag = massDiggit[index] // присваиваем tag кнопке
            button.backgroundColor = .tertiaryLabel
            button.setTitle(String(massDiggit[index]), for: .normal) // присваиваем title кнопке
            button.tintColor = UIColor.label
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 45).isActive = true
            button.heightAnchor.constraint(equalToConstant: 45).isActive = true
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(diggitsTapped), for: .touchUpInside)
            
            if index > 4 {
                secondLayerStackView.addArrangedSubview(button)
            } else {
                firstLayerStackView.addArrangedSubview(button)
            }
        }
        
        userDiggitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 35.0)
        userDiggitLabel.tintColor = .label
        userDiggitLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userDiggitLabel.textAlignment = .right
        
        
        userLabelPanelStackView.addArrangedSubview(userDiggitLabel)
        userLabelPanelStackView.addArrangedSubview(deleteLastButton)
        userLabelPanelStackView.distribution = .equalSpacing
        userLabelPanelStackView.axis = .horizontal
        
        
        firstLayerStackView.distribution = .fillEqually
        secondLayerStackView.distribution = .fillEqually
        firstLayerStackView.spacing = 10
        secondLayerStackView.spacing = 10
        
        
        twiceInputLayerStackView.addArrangedSubview(firstLayerStackView)
        twiceInputLayerStackView.addArrangedSubview(secondLayerStackView)
        twiceInputLayerStackView.distribution = .equalCentering
        twiceInputLayerStackView.axis = .vertical
        twiceInputLayerStackView.spacing = 10
        
        panelInputContollStackView.addArrangedSubview(userLabelPanelStackView)
        panelInputContollStackView.addArrangedSubview(twiceInputLayerStackView)
        
        
        sendDiggitsButton.setTitle("ОТПРАВИТЬ", for: .normal)
        sendDiggitsButton.backgroundColor = .tertiaryLabel
        sendDiggitsButton.tintColor = UIColor.label
        sendDiggitsButton.layer.cornerRadius = 10
        sendDiggitsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendDiggitsButton.addTarget(self, action: #selector(sendDiggitTapped), for: .touchUpInside)
        
        panelInputContollStackView.addArrangedSubview(sendDiggitsButton)
        
        panelInputContollStackView.axis = .vertical
        panelInputContollStackView.distribution = .equalCentering
        panelInputContollStackView.spacing = 20
        panelIntputControlView.addSubview(panelInputContollStackView)
        
        view.addSubview(panelIntputControlView)
        
        panelIntputControlView.layer.cornerRadius = 10
        panelIntputControlView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(panelIntputControlView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        tableview.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView).inset(70)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelIntputControlView.snp.makeConstraints { maker in
            maker.height.equalTo(250)
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.top.equalTo(tableview.snp.bottom).offset(10) // Отступ между dashBoardTextView и panelInputControlView
        }
        
        panelInputContollStackView.snp.makeConstraints { maker in
            maker.bottom.equalTo(panelIntputControlView).inset(20)
            maker.left.right.top.equalTo(panelIntputControlView).inset(10)
        }
        
    }
    
    @objc func selectMaxLenghtTapped(_ sender: UIButton) {
        sender.setTitle( game.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""), for: .normal)
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
    
    @objc func diggitsTapped(_ sender: UIButton) {
        if isStartGame && isContinueGame {
            if userDiggitLabel.text!.count < maxLenght {
                userDiggitLabel.text! += "\(sender.tag)"
            }
        }
    }
    
    @objc func deleteLastTapped(_ sender: UIButton) {
        if !userDiggitLabel.text!.isEmpty {
            userDiggitLabel.text = String(userDiggitLabel.text!.dropLast())
        }
    }
    
    func startNewGame() {
        seconds = 0
        createTimer()
        //        dashBoardTextView.text = ""
        maxLenght = Int((countButton.titleLabel?.text)!)!
        countButton.isEnabled = false
        computerDiggit = game.makeNumber(maxLenght: maxLenght)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func continueGame() {
        createTimer()
        //        makeResultText(partGame: "Игра возобновлена \n")
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func pauseGame() {
        stopwatch.invalidate()
        //        makeResultText(partGame: "Игра приостановлена\n")
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @objc func startGameButton(_ sender: UIButton) {
        let chekPartGame = (isStartGame, isContinueGame)
        
        if chekPartGame == (false, false) {
            isStartGame = true
            isContinueGame = true
            startNewGame()
        } else if chekPartGame == (true, true) {
            isContinueGame = false
            pauseGame()
        } else {
            isContinueGame = true
            continueGame()
        }
    }
    
    func createAlertMessage(description: String) {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.6
            self.view.isUserInteractionEnabled = false
        }
        
        alertView = ResultAlertView.loadFromNib() as? ResultAlertView
        alertView.delegate = self
        alertView.descriptionLabel.text = description
        UIApplication.shared.keyWindow?.addSubview(alertView)
        alertView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)
    }
    
    @objc
    func cancelTapped() {
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        self.dismiss(animated: true)
    }
    
    @objc func sendDiggitTapped(_ sender: UIButton) {
        if isStartGame && userDiggitLabel.text?.count == maxLenght {
            let (bull, cow) = game.comparisonNumber(game.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
            
            BullCowViewModel.shared.stepList.append(BullCowModel(size: maxLenght, bull: bull, cow: cow, userStep: game.createMassive(userDiggit: userDiggitLabel.text!)))
            userDiggitLabel.text = ""
            
            let lastIndexPath = IndexPath(row: BullCowViewModel.shared.stepList.count - 1, section: 0)
            tableview.insertRows(at: [lastIndexPath], with: .automatic)
            tableview.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            
            countStep += 1
            
            if bull == maxLenght {
                stopwatch.invalidate()
                createAlertMessage(description: "Ура! Мы загадали число \(computerDiggit). Ваш результат \(countStep) попыток за \(TimeManager.shared.convertToMinutes(seconds: seconds)). Сыграем еще?")
                let resultGame = WhiteBoardModel(nameGame: "Быки и Коровы", resultGame: "Победа", countStep: "\(countStep)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
                
                RealmManager.shared.saveResult(result: resultGame)
            }
        }
    }

    @objc
    func rulesTapped() {
        let rulesVC = RulesViewController()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 1)
        present(rulesVC, animated: true)
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        pauseGame()
        timerLabel.text = "0"
        countButton.isEnabled = true
        isStartGame = false
        isContinueGame = false
        //        dashBoardTextView.text = "Для начала игры выберите размер загаданного числа и нажмите СТАРТ \n"
        BullCowViewModel.shared.stepList.removeAll()
        tableview.reloadData()
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        BullCowViewModel.shared.stepList.removeAll()
        tableview.reloadData()
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
}

extension BullCowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = BullCowViewModel.shared.stepList.count
        if count == 0 {
            return count
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if BullCowViewModel.shared.stepList.count == 0 {
//            let cell: BullCowAlertTableViewCell
//            if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "BullCowAlertTableViewCell", for: indexPath) as? BullCowAlertTableViewCell {
//                cell = reuseCell
//            } else {
//                cell = BullCowAlertTableViewCell(style: .default, reuseIdentifier: "BullCowAlertTableViewCell")
//            }
//            return configure(cell: cell, for: indexPath)
//        } else {
            let cell: BullCowTableViewCell
            if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "BullCowTableViewCell", for: indexPath) as? BullCowTableViewCell {
                cell = reuseCell
            } else {
                cell = BullCowTableViewCell(style: .default, reuseIdentifier: "BullCowTableViewCell")
            }
            return configure(cell: cell, for: indexPath)
//        }
    }
    
    private func configure(cell: BullCowAlertTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        // Настройте BullCowAlertTableViewCell здесь, если необходимо
        return cell
    }
    
    private func configure(cell: BullCowTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        let step = BullCowViewModel.shared.stepList[indexPath.row]
        cell.gameData = [step]
        cell.createUI()
        return cell
    }
}

extension BullCowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = BullCowViewModel.shared.stepList.count
        if count == 0 {
            return 150
        } else {
            return 70
        }
        
    }
}

