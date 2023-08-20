//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class BullCowViewController: UIViewController, AlertDelegate {
    private let panelControllView = UIView()
    private let combinationCountLabel = UILabel()
    private let panelControllStackView = UIStackView()
    private let levelButton = UIButton()
    private let tableview = UITableView()
    private let userDiggitLabel = UILabel()
    private let timerLabel = UILabel()
    private let deleteLastButton = UIButton()
    private let sendDiggitsButton = UIButton()
    private let playButton = UIButton()
    private var stopwatch = Timer()
    private var isshowMessageAlert: Bool = false
    private var computerDiggit = [Int]()
    private var maxLenght: Int = 4
    private var countStep: Int = .zero
    private var indexMass: Int = .zero
    private var seconds: Int = .zero
    private var messegeView: UserMistakeView!
    private var alertView: ResultAlertView!
    private var game: BullCowViewModel!
    private var gameLevel: GameLevel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = BullCowViewModel()
        settingTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила".localized(), style: .plain, target: self, action: #selector(rulesTapped))
        userDiggitLabel.text = ""
        self.view.backgroundColor = CustomColor.viewColor.color
        createUIElements()
        gameLevel = GameLevel()
    }
    
    func settingTableView() {
        tableview.register(UINib(nibName: "BullCowTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowTableViewCell")
        tableview.register(UINib(nibName: "BullCowAlertTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowAlertTableViewCell")
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
    }
    
    func levelButtonCreated() {
        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        levelButton.setTitle("4", for: .normal)
        levelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        levelButton.titleLabel?.minimumScaleFactor = 0.5
        levelButton.tintColor = UIColor.label
        levelButton.backgroundColor = UIColor.tertiaryLabel
        levelButton.layer.cornerRadius = 10
        view.addSubview(levelButton)
    }
    
    func playButtonCreated() {
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = UIColor.white
        view.addSubview(playButton)
    }
    
    func panelControlCreated() {
        levelButtonCreated()
        playButtonCreated()
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .clear
        view.addSubview(panelControllView)

        panelControllStackView.addArrangedSubview(levelButton)
        panelControllStackView.addArrangedSubview(playButton)
        panelControllStackView.axis = .horizontal
        panelControllStackView.spacing = 10
        panelControllStackView.distribution = .fillEqually
        view.addSubview(panelControllStackView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0.1)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.085)
        }
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
    }
    
    func tableViewCreated() {
        view.addSubview(tableview)
        tableview.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
    }
    
    func inputFieldCreated() -> UIStackView {
        let inputFieldStackView = UIStackView()
        userDiggitLabel.tintColor = .label
        userDiggitLabel.textAlignment = .center
        userDiggitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 40.0)
        userDiggitLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        userDiggitLabel.minimumScaleFactor = 0.5
        
        deleteLastButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteLastButton.addTarget(self, action: #selector(deleteLastTapped), for: .touchUpInside)
        
        inputFieldStackView.addArrangedSubview(userDiggitLabel)
        inputFieldStackView.addArrangedSubview(deleteLastButton)
        inputFieldStackView.distribution = .equalSpacing
        inputFieldStackView.axis = .horizontal
        
        view.addSubview(inputFieldStackView)
        inputFieldStackView.snp.makeConstraints { maker in
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.000001)
        }
        
        deleteLastButton.snp.makeConstraints { maker in
            maker.width.equalTo(inputFieldStackView.snp.width).multipliedBy(0.1)
        }
        userDiggitLabel.snp.makeConstraints { maker in
            maker.width.equalTo(inputFieldStackView.snp.width).multipliedBy(0.6)
        }
        
        return inputFieldStackView
    }
    
    func buttonForNumpadCreated(index: Int) -> UIButton {
        let button = UIButton()
        button.tag = index// присваиваем tag кнопке
        button.backgroundColor = .tertiaryLabel
        button.setTitle(String(index), for: .normal) // присваиваем title кнопке
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        button.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        button.titleLabel!.minimumScaleFactor = 0.5
        button.tintColor = UIColor.label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(diggitsTapped), for: .touchUpInside)
        
        return button
    }
    
    func firstLayerNumpadCreated() -> UIStackView {
        let firstLayerStackView = UIStackView()
        firstLayerStackView.distribution = .fillEqually
        firstLayerStackView.spacing = 10
        let massDiggit = [1, 2, 3, 4, 5]
        var massButton: [UIButton] = []
        for _ in 0..<massDiggit.count {
            let button = UIButton()
            massButton.append(button)
        }
        
        for i in 0..<massButton.count {
            let button = buttonForNumpadCreated(index: massDiggit[i])
            firstLayerStackView.addArrangedSubview(button)
        }

        return firstLayerStackView
    }
    
    func secondLayerNumpadCreated() -> UIStackView {
        let secondLayerStackView = UIStackView()
        secondLayerStackView.distribution = .fillEqually
        secondLayerStackView.spacing = 10
        let massDiggit = [6, 7, 8, 9, 0]
        var massButton: [UIButton] = []
        for _ in 0..<massDiggit.count {
            let button = UIButton()
            massButton.append(button)
        }
        
        for i in 0..<massButton.count {
            let button = buttonForNumpadCreated(index: massDiggit[i])
            secondLayerStackView.addArrangedSubview(button)
        }
        
        return secondLayerStackView
    }
    
    func numpudCreated() -> UIStackView {
        let twiceInputLayerStackView = UIStackView()
        twiceInputLayerStackView.addArrangedSubview(firstLayerNumpadCreated())
        twiceInputLayerStackView.addArrangedSubview(secondLayerNumpadCreated())
        twiceInputLayerStackView.distribution = .fillEqually
        twiceInputLayerStackView.axis = .vertical
        twiceInputLayerStackView.spacing = 5
        return twiceInputLayerStackView
    }
    
    func sendButtonCreated() {
        sendDiggitsButton.setTitle("ОТПРАВИТЬ".localized(), for: .normal)
        sendDiggitsButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        sendDiggitsButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        sendDiggitsButton.titleLabel?.minimumScaleFactor = 0.5
        sendDiggitsButton.backgroundColor = .tertiaryLabel
        sendDiggitsButton.tintColor = UIColor.label
        sendDiggitsButton.layer.cornerRadius = 10
        sendDiggitsButton.addTarget(self, action: #selector(sendDiggitTapped), for: .touchUpInside)
        view.addSubview(sendDiggitsButton)
    }
    
    func createUIElements() {
        panelControlCreated()
        
        let panelInputContollStackView = UIStackView()
        let panelIntputControlView = UIView()
        
        sendButtonCreated()
        
        let inputField = inputFieldCreated()
        panelInputContollStackView.addArrangedSubview(inputField)
        panelInputContollStackView.addArrangedSubview(numpudCreated())
        panelInputContollStackView.addArrangedSubview(sendDiggitsButton)
        inputField.heightAnchor.constraint(equalTo: panelInputContollStackView.heightAnchor, multiplier: 0.2).isActive = true
        
        panelInputContollStackView.axis = .vertical
        panelInputContollStackView.distribution = .fill
        panelInputContollStackView.spacing = 15
        panelIntputControlView.addSubview(panelInputContollStackView)
        panelIntputControlView.layer.cornerRadius = 10
        panelIntputControlView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(panelIntputControlView)
        
        tableViewCreated()
        
        panelIntputControlView.snp.makeConstraints { maker in
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.32)
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.top.equalTo(tableview.snp.bottom).offset(10) // Отступ между dashBoardTextView и panelInputControlView
        }
        
        panelInputContollStackView.snp.makeConstraints { maker in
            maker.bottom.equalTo(panelIntputControlView).inset(10)
            maker.left.right.top.equalTo(panelIntputControlView).inset(10)
        }
    
        sendDiggitsButton.snp.makeConstraints { maker in
            maker.height.equalTo(panelIntputControlView.snp.height).multipliedBy(0.15)
        }
    }
    
    // MARK: Navigation Bar
    @objc
    func cancelTapped() {
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        game.stepList.removeAll()
        tableview.reloadData()
        self.dismiss(animated: true)
    }
    
    @objc
    func rulesTapped() {
        let rulesVC = RulesViewController()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 1)
        present(rulesVC, animated: true)
    }
    
    @objc
    func selectMaxLenghtTapped(_ sender: UIButton) {
//        maxLenght = Int(game.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""))!
//        sender.setTitle(String(maxLenght), for: .normal)
        maxLenght = gameLevel.getLevel(level: Int(sender.titleLabel?.text ?? "") ?? 2, step: 1, curentGame: CurentGame.bullCowGame)
        sender.setTitle(String(maxLenght), for: .normal)
    }
    
    func createTimer() {
        stopwatch = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    // MARK: Timer
    @objc
    func updateTimer() {
        seconds += 1
        navigationItem.title = TimeManager.shared.convertToMinutes(seconds: seconds)
    }
    
    // MARK: Keyboard
    @objc
    func diggitsTapped(_ sender: UIButton) {
        if game.isStartGame && game.isContinueGame {
            if userDiggitLabel.text!.count < maxLenght {
                userDiggitLabel.text! += "\(sender.tag)"
            }
        }
    }
    
    @objc
    func deleteLastTapped(_ sender: UIButton) {
        if !userDiggitLabel.text!.isEmpty {
            userDiggitLabel.text = String(userDiggitLabel.text!.dropLast())
        }
    }
    
    // MARK: управление статусом игры
    func startNewGame() {
        seconds = 0
        createTimer()
        maxLenght = Int((levelButton.titleLabel?.text)!)!
        levelButton.isEnabled = false
        computerDiggit = game.makeNumber(maxLenght: maxLenght)
        print(computerDiggit)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func pauseGame() {
        stopwatch.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        navigationItem.title = "ПАУЗА".localized()
    }
    
    @objc
    func startGameTapped(_ sender: UIButton) {
        let chekPartGame = (game.isStartGame, game.isContinueGame)
        if chekPartGame == (false, false) {
            game.isStartGame = true
            game.isContinueGame = true
            startNewGame()
        } else if chekPartGame == (true, true) {
            game.isContinueGame = false
            pauseGame()
        } else {
            game.isContinueGame = true
            continueGame()
        }
    }
    
    @objc
    func sendDiggitTapped(_ sender: UIButton) {
        guard game.checkRepeatDiggits(userDiggit: userDiggitLabel.text!) else {
            createMistakeMessage(messages: "В вашем числе есть повторяющиеся цифры".localized())
            return
        }
        
        if game.isStartGame {
            if userDiggitLabel.text?.count == maxLenght {
                game.comparisonNumber(game.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
                
                    game.stepList.append(BullCowModel(size: maxLenght, bull: game.bull, cow: game.cow, userStep: game.createMassive(userDiggit: userDiggitLabel.text!)))
                userDiggitLabel.text = ""
                
                let lastIndexPath = IndexPath(row: game.stepList.count - 1, section: 0)
                tableview.insertRows(at: [lastIndexPath], with: .automatic)
                tableview.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                countStep += 1
                checkResult(bull: game.bull)
            } else {
                createMistakeMessage(messages: "В веденном Вами числу не хватает цирф".localized())
            }
        }
    }
    // проверка результата
    func checkResult(bull: Int) {
        if bull == maxLenght {
            stopwatch.invalidate()
            createAlertMessage(description: "Ура! Загаданное число \(computerDiggit). Ваш результат \(countStep) попыток за \(TimeManager.shared.convertToMinutes(seconds: seconds)). Сыграем еще?")
            let resultGame = WhiteBoardModel(nameGame: "Быки и Коровы", resultGame: "Победа", countStep: "\(countStep)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        }
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        game.restartGame()
        pauseGame()
        timerLabel.text = "0"
        levelButton.isEnabled = true
        game.stepList.removeAll()
        tableview.reloadData()
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        game.restartGame()
        tableview.reloadData()
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    // MARK: создание элементов уведомления
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
    
    func createMistakeMessage(messages: String) {
        guard messegeView == nil else {
            return
        }
        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topPadding = window?.safeAreaInsets.top ?? 0
        let alertViewWidth: CGFloat = self.view.frame.size.width / 1.1
        let alertViewHeight: CGFloat = 70
        
        messegeView.createUI(messages: messages)
        messegeView.frame = CGRect(x: (window!.frame.width - alertViewWidth) / 2,
                                   y: -alertViewHeight,
                                   width: alertViewWidth,
                                   height: alertViewHeight)
        
        messegeView.layer.cornerRadius = 10
        messegeView.layer.shadowOpacity = 0.2
        messegeView.layer.shadowRadius = 5
        messegeView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        UIApplication.shared.keyWindow?.addSubview(messegeView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.messegeView.frame.origin.y = topPadding // конечное положение
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {
                self.messegeView.frame.origin.y = -alertViewHeight // начальное положение
            }, completion: { _ in
                self.messegeView.removeFromSuperview()
                self.isshowMessageAlert = false
                self.messegeView = nil
            })
        }
    }
}

// MARK: расширение для tableview
extension BullCowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = game.stepList.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BullCowTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "BullCowTableViewCell", for: indexPath) as? BullCowTableViewCell {
            cell = reuseCell
        } else {
            cell = BullCowTableViewCell(style: .default, reuseIdentifier: "BullCowTableViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: BullCowTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        let step = game.stepList[indexPath.row]
        cell.gameData = [step]
        cell.createUI()
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension BullCowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
