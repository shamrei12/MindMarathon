//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class BullCowViewController: UIViewController {
    
    private var messegeView: UserMistakeView!
    private var gameLevel = GameLevel()
    private let viewModel: BullCowViewModel
    
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
    private var indexMass: Int = .zero
    private var seconds: Int = .zero

    init(viewModel: BullCowViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.viewColor.color
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила".localize(), style: .plain, target: self, action: #selector(rulesTapped))
        userDiggitLabel.text = ""
        settingTableView()
        createUIElements()
    }
    
    func settingTableView() {
        tableview.register(UINib(nibName: "BullCowTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowTableViewCell")
        tableview.register(UINib(nibName: "BullCowAlertTableViewCell", bundle: nil), forCellReuseIdentifier: "BullCowAlertTableViewCell")
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.showsVerticalScrollIndicator = false
    }
    
    func levelButtonCreated() {
        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        levelButton.setTitle("4", for: .normal)
        levelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        levelButton.titleLabel?.minimumScaleFactor = 0.5
        levelButton.tintColor = UIColor.label
        levelButton.backgroundColor = UIColor.lightGray
        levelButton.layer.cornerRadius = 10
        levelButton.addShadow()
        view.addSubview(levelButton)
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
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.095)
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
    
    func inputFieldCreated() -> UIView {
        let inputFieldStackView = UIStackView()
        let mainView = UIView()
        mainView.backgroundColor = UIColor(named: "gameElementColor")
        mainView.layer.cornerRadius = 10
        mainView.addShadowView()
        view.addSubview(mainView)
        
        userDiggitLabel.tintColor = .label
        userDiggitLabel.textAlignment = .center
        userDiggitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 50.0)
        userDiggitLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        userDiggitLabel.minimumScaleFactor = 0.7
        
        deleteLastButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteLastButton.tintColor = .label
        deleteLastButton.addTarget(self, action: #selector(deleteLastTapped), for: .touchUpInside)
        
        inputFieldStackView.addArrangedSubview(userDiggitLabel)
        inputFieldStackView.addArrangedSubview(deleteLastButton)
        inputFieldStackView.distribution = .fill
        inputFieldStackView.backgroundColor = .clear
        inputFieldStackView.layer.cornerRadius = 10
        inputFieldStackView.axis = .horizontal
        
        mainView.addSubview(inputFieldStackView)
        
        inputFieldStackView.snp.makeConstraints { maker in
            //            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.9)
            maker.edges.equalToSuperview().inset(5)
        }
        
        deleteLastButton.snp.makeConstraints { maker in
            maker.width.equalTo(inputFieldStackView.snp.width).multipliedBy(0.1)
        }
        userDiggitLabel.snp.makeConstraints { maker in
            maker.width.equalTo(inputFieldStackView.snp.width).multipliedBy(0.8)
        }
        
        return mainView
    }
    
    func buttonForNumpadCreated(index: Int) -> UIButton {
        let button = UIButton()
        button.tag = index// присваиваем tag кнопке
        button.backgroundColor = CustomColor.gameElement.color
        button.setTitle(String(index), for: .normal) // присваиваем title кнопке
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 35.0)
        button.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        button.titleLabel!.minimumScaleFactor = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addShadow()
        button.addTarget(self, action: #selector(diggitsTapped), for: .touchUpInside)
        return button
    }
    
    func layerForKeyboarCreate(massDiggits: [Int]) -> UIStackView {
        let layerStackView = UIStackView()
        layerStackView.distribution = .fillEqually
        layerStackView.spacing = 15
        var massButton: [UIButton] = []
        for _ in 0..<massDiggits.count {
            let button = UIButton()
            massButton.append(button)
        }
        for i in 0..<massButton.count {
            let button = buttonForNumpadCreated(index: massDiggits[i])
            layerStackView.addArrangedSubview(button)
        }
        return layerStackView
    }
    
    func numpudCreated() -> UIStackView {
        let twiceInputLayerStackView = UIStackView()
        twiceInputLayerStackView.addArrangedSubview(layerForKeyboarCreate(massDiggits: [1, 2, 3, 4, 5]))
        twiceInputLayerStackView.addArrangedSubview(layerForKeyboarCreate(massDiggits: [6, 7, 8, 9, 0]))
        twiceInputLayerStackView.distribution = .fillEqually
        twiceInputLayerStackView.axis = .vertical
        twiceInputLayerStackView.spacing = 5
        return twiceInputLayerStackView
    }
    
    func sendButtonCreated() {
        sendDiggitsButton.setTitle("ОТПРАВИТЬ".localize(), for: .normal)
        sendDiggitsButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        sendDiggitsButton.setTitleColor(.label, for: .normal)
        sendDiggitsButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        sendDiggitsButton.titleLabel?.minimumScaleFactor = 0.5
        sendDiggitsButton.backgroundColor = CustomColor.gameElement.color
        sendDiggitsButton.tintColor = UIColor.label
        sendDiggitsButton.layer.cornerRadius = 10
        sendDiggitsButton.addShadow()
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
        panelIntputControlView.backgroundColor = .clear
        view.addSubview(panelIntputControlView)
        
        tableViewCreated()
        
        panelIntputControlView.snp.makeConstraints { maker in
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.35)
            maker.left.right.equalToSuperview().inset(5)
            maker.bottom.equalToSuperview().inset(20)
            maker.top.equalTo(tableview.snp.bottom).offset(10) // Отступ между dashBoardTextView и panelInputControlView
        }
        
        panelInputContollStackView.snp.makeConstraints { maker in
            maker.bottom.equalTo(panelIntputControlView).inset(10)
            maker.left.right.top.equalTo(panelIntputControlView).inset(10)
        }
        
        sendDiggitsButton.snp.makeConstraints { maker in
            maker.height.equalTo(panelIntputControlView.snp.height).multipliedBy(0.18)
        }
    }
    
    // MARK: Navigation Bar
    @objc
    func cancelTapped() {
        viewModel.stepList.removeAll()
        tableview.reloadData()
        self.dismiss(animated: true)
    }
    
    @objc
    func rulesTapped() {
        let rulesVC = RulesViewController(game: viewModel.game)
        rulesVC.modalPresentationStyle = .formSheet
        present(rulesVC, animated: true)
    }
    
    @objc
    func selectMaxLenghtTapped(_ sender: UIButton) {
        maxLenght = gameLevel.getLevel(currentLevel: Int(sender.titleLabel?.text ?? "") ?? 2, step: 1, curentGame: CurentGame.bullCowGame)
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
        if viewModel.isStartGame && viewModel.isContinueGame {
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
        computerDiggit = viewModel.makeNumber(maxLenght: maxLenght)
        playButton.setImage(Icons.pauseFill, for: .normal)
        viewModel.isStartGame = true
        viewModel.isContinueGame = true
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(Icons.pauseFill, for: .normal)
        viewModel.isContinueGame = true
    }
    
    func pauseGame() {
        viewModel.isContinueGame = false
        stopwatch.invalidate()
        playButton.setImage(Icons.playFill, for: .normal)
        navigationItem.title = "ПАУЗА"
    }
    
    func endGame() {
        viewModel.restartGame()
        viewModel.countStep = 0
        pauseGame()
        timerLabel.text = "0"
        levelButton.isEnabled = true
        viewModel.stepList.removeAll()
        tableview.reloadData()
    }
    
    func showAlertAboutFinishGame() {
        let alertController = UIAlertController(title: "Внимание!", message: "Вы действительно хотите закончить игру?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Продолжить", style: .default) { _ in
            self.continueGame() // Вызов функции 1 при нажатии кнопки "Продолжить"
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Закончить игру", style: .destructive) { _ in
            self.endGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAboutFinishGame(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Новая игра", style: .default) { _ in
            self.restartGame()
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Закончить игру", style: .destructive) { _ in
            self.exitGame()
        }
        alertController.addAction(endAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func startGameTapped(_ sender: UIButton) {
        let chekPartGame = (viewModel.isStartGame, viewModel.isContinueGame)
        if chekPartGame == (false, false) {
            startNewGame()
        } else if chekPartGame == (true, true) {
            pauseGame()
            showAlertAboutFinishGame()
        } else {
            continueGame()
        }
    }
    
    @objc
    func sendDiggitTapped(_ sender: UIButton) {
        guard viewModel.checkRepeatDiggits(userDiggit: userDiggitLabel.text!) else {
            createMistakeMessage(messages: "В вашем числе есть повторяющиеся цифры")
            return
        }
        
        if viewModel.isStartGame {
            if userDiggitLabel.text?.count == maxLenght {
                viewModel.comparisonNumber(viewModel.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
                viewModel.stepList.append(BullCowModel(size: maxLenght, bull: viewModel.bull, cow: viewModel.cow, userStep: viewModel.createMassive(userDiggit: userDiggitLabel.text!)))
                userDiggitLabel.text = ""
                let lastIndexPath = IndexPath(row: viewModel.stepList.count - 1, section: 0)
                tableview.insertRows(at: [lastIndexPath], with: .automatic)
                tableview.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                viewModel.countStep += 1
                checkResult(bull: viewModel.bull)
            } else {
                createMistakeMessage(messages: "В веденном Вами числу не хватает цирф")
            }
        }
    }
    // проверка результата
    func checkResult(bull: Int) {
        if bull == maxLenght {
            stopwatch.invalidate()
            showAlertAboutFinishGame(title: "Конец игры", message: "Ура! Загаданное число \(viewModel.remakeComputerNumberForAlert(computerDigit: computerDiggit)). Ваш результат \(viewModel.countStep) попыток за \(TimeManager.shared.convertToMinutes(seconds: seconds)). Сыграем еще?")
            let resultGame = WhiteBoardModel(nameGame: "Быки и Коровы".localize(), resultGame: "Победа", countStep: "\(viewModel.countStep)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        }
    }
    
    func restartGame() {
        viewModel.restartGame()
        pauseGame()
        timerLabel.text = "0"
        levelButton.isEnabled = true
        viewModel.stepList.removeAll()
        tableview.reloadData()
    }
    
    func exitGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        viewModel.restartGame()
        tableview.reloadData()
        self.dismiss(animated: true)
    }
}

// MARK: расширение для tableview
extension BullCowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.stepList.count
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
        let step = viewModel.stepList[indexPath.row]
        cell.gameData = [step]
        cell.createUI()
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension BullCowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.size.height
        let cellHeight = safeAreaHeight * 0.11

        return cellHeight
        
    }
}

extension BullCowViewController {
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
