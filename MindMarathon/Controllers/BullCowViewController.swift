//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class BullCowViewController: UIViewController, AlertDelegate {
    let panelControllView = UIView()
    let combinationCountLabel = UILabel()
    let panelControllStackView = UIStackView()
    private let tableview = UITableView()
    private let levelButton = UIButton()
    private let userDiggitLabel = UILabel()
    private let timerLabel = UILabel()
    private let deleteLastButton = UIButton()
    private let sendDiggits = UIButton()
    private let playButton = UIButton()
    private var stopwatch = Timer()
    private var isshowMessageAlert: Bool = false
    private var computerDiggit = [Int]()
    private var maxLenght: Int = 4
    private var countStep: Int = 0
    private var indexMass: Int = 0
    private var seconds: Int = 0
    private var messegeView: UserMistakeView!
    private var alertView: ResultAlertView!
    private var game: BullCowViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = BullCowViewModel()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        userDiggitLabel.text = ""
        self.view.backgroundColor = UIColor(named: "viewColor")
        tableview.register(UINib(nibName: "BullCowTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowTableViewCell")
        tableview.register(UINib(nibName: "BullCowAlertTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowAlertTableViewCell")
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        createUIElements()
    }
    
    func createUIElements() {
        let panelInputContollStackView = UIStackView()
        let twiceInputLayerStackView = UIStackView()
        let firstLayerStackView = UIStackView()
        let secondLayerStackView = UIStackView()
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
        panelControllView.backgroundColor = .clear
        view.addSubview(panelControllView)
        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        levelButton.setTitle("4", for: .normal)
        levelButton.tintColor = UIColor.label
        levelButton.backgroundColor = UIColor.tertiaryLabel
        levelButton.layer.cornerRadius = 10
        view.addSubview(levelButton)
        
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = UIColor.white
        view.addSubview(playButton)
        
        panelControllStackView.addArrangedSubview(levelButton)
        panelControllStackView.addArrangedSubview(playButton)
        panelControllStackView.axis = .horizontal
        panelControllStackView.spacing = 10
        panelControllStackView.distribution = .fillEqually
        view.addSubview(panelControllStackView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(80)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        view.addSubview(tableview)
        
        deleteLastButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
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
        
        
//        let combinationsView = UIView()
//        combinationsView.layer.cornerRadius = 10
//        combinationsView.layer.borderWidth = 0.5
//        combinationsView.layer.borderColor = UIColor.black.cgColor
//        view.addSubview(combinationsView)
//
//        let labelCombination = UILabel()
//        labelCombination.text = "Комбинации"
//        labelCombination.textAlignment = .center
//        labelCombination.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
//        labelCombination.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
//        labelCombination.minimumScaleFactor = 0.5
//        combinationsView.addSubview(labelCombination)
//
//
//        combinationCountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
//        combinationCountLabel.text = "5040"
//        combinationCountLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
//        combinationCountLabel.minimumScaleFactor = 0.5
//        combinationCountLabel.textAlignment = .center
//        combinationsView.addSubview(combinationCountLabel)
//
//        let combinationStackView = UIStackView()
//        combinationsView.addSubview(combinationStackView)
//        combinationStackView.axis = .vertical
//        combinationStackView.distribution = .fillEqually
//        combinationStackView.alignment = .center
//        combinationStackView.spacing = 5
//        combinationStackView.addArrangedSubview(labelCombination)
//        combinationStackView.addArrangedSubview(combinationCountLabel)
//
//        combinationStackView.snp.makeConstraints { maker in
//            maker.left.right.top.bottom.equalTo(combinationsView).inset(5)
//        }
        
        userDiggitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        userDiggitLabel.tintColor = .label
        userDiggitLabel.textAlignment = .center
//
//        userLabelPanelStackView.addArrangedSubview(combinationsView)
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
        twiceInputLayerStackView.distribution = .fillEqually
        twiceInputLayerStackView.axis = .vertical
        twiceInputLayerStackView.spacing = 5
        
        panelInputContollStackView.addArrangedSubview(userLabelPanelStackView)
        panelInputContollStackView.addArrangedSubview(twiceInputLayerStackView)
        
        
        sendDiggitsButton.setTitle("ОТПРАВИТЬ", for: .normal)
        sendDiggitsButton.backgroundColor = .tertiaryLabel
        sendDiggitsButton.tintColor = UIColor.label
        sendDiggitsButton.layer.cornerRadius = 10
        sendDiggitsButton.addTarget(self, action: #selector(sendDiggitTapped), for: .touchUpInside)
        view.addSubview(sendDiggitsButton)
        
        panelInputContollStackView.addArrangedSubview(sendDiggitsButton)
        
        panelInputContollStackView.axis = .vertical
        panelInputContollStackView.distribution = .fill
        panelInputContollStackView.spacing = 15
        panelIntputControlView.addSubview(panelInputContollStackView)
        panelIntputControlView.layer.cornerRadius = 10
        panelIntputControlView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(panelIntputControlView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
//            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).multipliedBy(0.1)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        tableview.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelIntputControlView.snp.makeConstraints { maker in
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.35)
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
        
        userLabelPanelStackView.snp.makeConstraints { maker in
            maker.height.equalTo(panelIntputControlView.snp.height).multipliedBy(0.2)
        }
        twiceInputLayerStackView.snp.makeConstraints { maker in
            maker.height.equalTo(panelIntputControlView.snp.height).multipliedBy(0.45)
        }
        
        deleteLastButton.snp.makeConstraints { maker in
            maker.width.equalTo(userLabelPanelStackView.snp.width).multipliedBy(0.1)
        }
    }
    //MARK: Navigation Bar
    @objc
    func cancelTapped() {
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        BullCowViewModel.shared.stepList.removeAll()
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
        maxLenght = Int(game.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""))!
        sender.setTitle(String(maxLenght), for: .normal)
//        combinationCountLabel.text = game.firstShowCountCombination(lenght: maxLenght)
        
        
        
    }
    
    func createTimer() {
        stopwatch = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    //MARK: Timer
    @objc
    func updateTimer() {
        seconds += 1
        navigationItem.title = TimeManager.shared.convertToMinutes(seconds: seconds)
    }
    //MARK: Keyboard
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
    
    //MARK: управление статусом игры
    func startNewGame() {
        seconds = 0
        createTimer()
        maxLenght = Int((levelButton.titleLabel?.text)!)!
        levelButton.isEnabled = false
        computerDiggit = game.makeNumber(maxLenght: maxLenght)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func pauseGame() {
        stopwatch.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        navigationItem.title = "PAUSE"
    }
    
    @objc func startGameTapped(_ sender: UIButton) {
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
    
    
    @objc func sendDiggitTapped(_ sender: UIButton) {
        guard game.checkRepeatDiggits(userDiggit: userDiggitLabel.text!) else {
            createMistakeMessage(messages: "В вашем числе есть повторяющиеся цифры")
            return
        }
        
        if game.isStartGame {
            if userDiggitLabel.text?.count == maxLenght {
                game.comparisonNumber(game.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
                
                BullCowViewModel.shared.stepList.append(BullCowModel(size: maxLenght, bull: game.bull, cow: game.cow, userStep: game.createMassive(userDiggit: userDiggitLabel.text!)))
                userDiggitLabel.text = ""
                
                let lastIndexPath = IndexPath(row: BullCowViewModel.shared.stepList.count - 1, section: 0)
                tableview.insertRows(at: [lastIndexPath], with: .automatic)
                tableview.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                countStep += 1
                checkResult(bull: game.bull)
            } else {
                createMistakeMessage(messages: "В веденном Вами числу не хватает цирф")
            }
        }
    }
    //проверка результата
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
        BullCowViewModel.shared.stepList.removeAll()
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
    
    //MARK: создание элементов уведомления
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
//MARK: расширение для tableview
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
        let cell: BullCowTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "BullCowTableViewCell", for: indexPath) as? BullCowTableViewCell {
            cell = reuseCell
        } else {
            cell = BullCowTableViewCell(style: .default, reuseIdentifier: "BullCowTableViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: BullCowTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        let step = BullCowViewModel.shared.stepList[indexPath.row]
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

