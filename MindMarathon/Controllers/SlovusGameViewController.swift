//
//  SlovusGameViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit

class SlovusGameViewController: UIViewController, AlertDelegate {
    private var alertView: ResultAlertView!
    private var messegeView: UserMistakeView!
    private var massLayer = [UIStackView]()
    private var contentViewStackView = UIStackView()
    private let panelControllView = UIView()
    private let panelControllStackView = UIStackView()
    private var stopwatch = Timer()
    private var isshowMessageAlert: Bool = false
    private var puzzleWord = ""
    private var userWords = ""
    private let playButton = UIButton()
    private let levelButton = UIButton()
    private let numberOfRows = 6
    private var numberOfColumns = 5
    private let containerView = UIView()
    private let textFieldHeight: CGFloat = 50
    private let textFieldWidth: CGFloat = 40
    private let spacing: CGFloat = 20
    private var massTextField = [UITextField]()
    private var firstWordIndex = 0
    private var lastWordIndex = 0
    private var controllerTextField = 0
    private var game: SlovusViewModel!
    private var seconds = 0
    private var isstartGame = false
    private var iscontinuePlaying = false
    private var maxLenght = 5
    private var step = 0
    private var gameLevel: GameLevel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        self.view.backgroundColor = UIColor(named: "viewColor")
        createUI()
        levelButton.setTitle("5", for: .normal)
        game = SlovusViewModel()
        gameLevel = GameLevel()
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
    
    func continerCreated() {
        containerView.backgroundColor = UIColor(named: "gameElementColor")
        containerView.layer.cornerRadius = 10
        containerView.isUserInteractionEnabled = false
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
    }
    
    func keyboardViewCreated() -> UIView {
        let keyBoardView = UIView()
        view.addSubview(keyBoardView)
        keyBoardView.snp.makeConstraints { maker in
            maker.top.equalTo(containerView.snp.bottom).inset(-10)
            maker.left.equalToSuperview().inset(10)
            maker.right.bottom.equalToSuperview().inset(20)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        return keyBoardView
    }
    
    func sendButtonCreated() -> UIButton {
        let sendWordsButton = UIButton()
        sendWordsButton.setTitle("ОТПРАВИТЬ", for: .normal)
        sendWordsButton.backgroundColor = UIColor.systemBackground
        sendWordsButton.setTitleColor(UIColor.label, for: .normal)
        sendWordsButton.layer.cornerRadius = 10
        sendWordsButton.addTarget(self, action: #selector(sendWordsTapped), for: .touchUpInside)
        view.addSubview(sendWordsButton)
        
        sendWordsButton.snp.makeConstraints { maker in
            maker.height.equalToSuperview().multipliedBy(0.22)
        }
        
        return sendWordsButton
    }
    
    func keyboardCreated() {
        let view = keyboardViewCreated()
        let keyBoardStackView = UIStackView()
        let keyboardLayers = [UIStackView(), UIStackView(), UIStackView()]
        let keyboard = [
            ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"],
            ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"],
            ["Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "delete"]
        ]
        
        for (indexRow, row) in keyboard.enumerated() {
            let keyboardRowStackView = UIStackView()
            keyboardRowStackView.axis = .horizontal
            keyboardRowStackView.spacing = 5
            keyboardRowStackView.distribution = .fillEqually
            
            for indexKey in row {
                let keyboarButton = UIButton()
                if indexKey == "delete" {
                    keyboarButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
                    keyboarButton.addTarget(self, action: #selector(deleteLastWord), for: .touchDown)
                } else {
                    keyboarButton.setTitle(indexKey, for: .normal)
                    keyboarButton.layer.cornerRadius = 5
                    keyboarButton.backgroundColor = UIColor.systemBackground
                    keyboarButton.setTitleColor(UIColor.label, for: .normal)
                    keyboarButton.addTarget(self, action: #selector(letterinputTapped), for: .touchDown)
                }
                keyboardRowStackView.addArrangedSubview(keyboarButton)
            }
            
            keyboardLayers[indexRow].addArrangedSubview(keyboardRowStackView)
            keyBoardStackView.addArrangedSubview(keyboardLayers[indexRow])
        }
        
        keyBoardStackView.addArrangedSubview(sendButtonCreated())
        
        for keyboardLayer in keyboardLayers {
            keyboardLayer.axis = .horizontal
            keyboardLayer.distribution = .fillEqually
            keyboardLayer.spacing = 5
        }
        
        keyBoardStackView.axis = .vertical
        keyBoardStackView.distribution = .fillEqually
        keyBoardStackView.spacing = 5
        view.addSubview(keyBoardStackView)
        
        keyBoardStackView.snp.makeConstraints { maker in
            maker.edges.equalTo(view).inset(5)
        }
    }
    
    func createUI() {
        panelControlCreated()
        continerCreated()
        keyboardCreated()
    }
    
    func textFieldWindowCreated() -> UITextField {
        let textFieldWindow = UITextField()
        textFieldWindow.isEnabled = false
        textFieldWindow.tintColor = UIColor.label
        textFieldWindow.backgroundColor = UIColor.tertiaryLabel
        textFieldWindow.layer.cornerRadius = 5
        textFieldWindow.layer.borderColor = UIColor.gray.cgColor
        textFieldWindow.layer.borderWidth = 0.1
        textFieldWindow.font = UIFont(name: "HelveticaNeue-Bold", size: 40.0)
        textFieldWindow.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        textFieldWindow.minimumFontSize = 30
        textFieldWindow.textAlignment = .center
        
        view.addSubview(textFieldWindow)
        return textFieldWindow
    }
    
    func createPlaceGame() {
        massTextField.removeAll()
        massLayer.removeAll()
        
        // Удаляем все элементы из contentViewStackView
        for view in contentViewStackView.arrangedSubviews {
            contentViewStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        // Добавляем contentViewStackView на view
        view.addSubview(contentViewStackView)
        
        // Создаем и добавляем все элементы в массивы
        for i in 0..<numberOfRows {
            for _ in 0..<numberOfColumns {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.spacing = 1
                massLayer.append(stackView)
                let textFieldWindow = textFieldWindowCreated()
                massTextField.append(textFieldWindow)
                massLayer[i].addArrangedSubview(textFieldWindow)
            }
            
            contentViewStackView.addArrangedSubview(massLayer[i])
        }
        
        // Устанавливаем необходимые свойства
        for i in massLayer {
            i.axis = .horizontal
            i.distribution = .fillEqually
            i.spacing = 1
        }
        
        contentViewStackView.axis = .vertical
        contentViewStackView.distribution = .fillEqually
        contentViewStackView.spacing = 1
        
        contentViewStackView.snp.makeConstraints { maker in
            maker.edges.equalTo(containerView).inset(10)
        }
    }
    
    // MARK: Таймер и управление игрой
    @objc
    func selectMaxLenghtTapped() {
        levelButton.setTitle(String(gameLevel.getLevel(level: Int(levelButton.titleLabel!.text!)!, step: 1, curentGame: CurentGame.slovusGame)), for: .normal)
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
    
    // MARK: Статус игры
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
        maxLenght = Int((levelButton.titleLabel?.text)!)!
        lastWordIndex = maxLenght
        numberOfColumns = maxLenght
        controllerTextField = 0
        firstWordIndex = 0
        step = 0
        seconds = 0
        createTimer()
        levelButton.isEnabled = false
        puzzleWord = game.choiceRandomWord(size: maxLenght)
        print(puzzleWord)
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createPlaceGame()
    }
    
    func continueGame() {
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createTimer()
    }
    
    func pauseGame() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        stopwatch.invalidate()
        navigationItem.title = "PAUSE"
        
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        for i in massTextField {
            i.textColor = UIColor.label
            i.backgroundColor = UIColor.tertiaryLabel
            i.text = ""
        }
        pauseGame()
        levelButton.isEnabled = true
        isstartGame = false
        iscontinuePlaying = false
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    // MARK: Этапы работы клавиатуры
    @objc func deleteLastWord() {
        for i in massTextField[firstWordIndex..<lastWordIndex].reversed() where !i.text!.isEmpty {
            i.text = ""
            break
        }
        if controllerTextField - 1 >= firstWordIndex {
            controllerTextField -= 1
            userWords = String(userWords.dropLast())
        }
    }
    
    @objc func letterinputTapped(sender: UIButton) {
        if (isstartGame, iscontinuePlaying) == (true, true) {
            let letter = sender.titleLabel?.text ?? ""
            checkTextField(letter: letter.uppercased())
        }
    }
    
    func checkTextField(letter: String) {
        if controllerTextField < lastWordIndex {
            if massTextField[controllerTextField].text?.isEmpty ?? true {
                massTextField[controllerTextField].text = letter
                controllerTextField += 1
                userWords += letter
            }
        }
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
        rulesVC.rulesGame(numberGame: 2)
        present(rulesVC, animated: true)
    }
    
    @objc func sendWordsTapped() {
        if userWords.count == maxLenght {
            if game.checkWord(wordToCheck: userWords) {
                makeColorTextField(massiveAnswer: game.checkWord(puzzleWord: puzzleWord, userWord: userWords.lowercased()), startIndex: firstWordIndex, lastIndex: lastWordIndex)
                if firstWordIndex < maxLenght * 6 && lastWordIndex < maxLenght * 6 {
                    controllerTextField = firstWordIndex + Int(levelButton.titleLabel?.text ?? "")!
                    firstWordIndex += Int(levelButton.titleLabel?.text ?? "")!
                    lastWordIndex += Int(levelButton.titleLabel?.text ?? "")!
                }
            } else {
                if !isshowMessageAlert {
                    isshowMessageAlert = true
                    createAlertMessage()
                }
                
            }
        }
    }
    // MARK: Проверка ответа и вывод результата
    func checkCorrctAnswer(massiveAnswer: [Int]) -> Bool {
        for i in massiveAnswer where i != 2 {
            if i != 2 {
                return false
            }
        }
        return true
    }
    
    func makeColorTextField(massiveAnswer: [Int], startIndex: Int, lastIndex: Int) {
        let massiveIndex = Array(startIndex..<lastIndex)
        
        for i in 0..<massiveAnswer.count {
            if massiveAnswer[i] == 0 {
                massTextField[massiveIndex[i]].textColor = .gray
            } else if massiveAnswer[i] == 1 {
                massTextField[massiveIndex[i]].textColor = .white
                massTextField[massiveIndex[i]].backgroundColor = .systemYellow
            } else if massiveAnswer[i] == 2 {
                massTextField[massiveIndex[i]].textColor = .white
                massTextField[massiveIndex[i]].backgroundColor = .systemGreen
            }
        }
        step += 1
        
        if checkCorrctAnswer(massiveAnswer: massiveAnswer) {
            createAlertMessage(description: "Поздравляем! Мы загадали слово \(puzzleWord), которое вы угадали за \(TimeManager.shared.convertToMinutes(seconds: seconds)) и за \(step) попыток")
            let resultGame = WhiteBoardModel(nameGame: "Словус", resultGame: "Победа", countStep: "\(step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
            
        } else if step == 6 {
            createAlertMessage(description: "Ходы закончились! Мы загадали слово \(puzzleWord). Попробуешь еще раз?")
            let resultGame = WhiteBoardModel(nameGame: "Словус", resultGame: "Поражение", countStep: "\(step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        }
        
        userWords = ""
    }
    
    //MARK: Alerts
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
    
    func createAlertMessage() {
        guard messegeView == nil else {
            return
        }
        
        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topPadding = window?.safeAreaInsets.top ?? 0
        let alertViewWidth: CGFloat = self.view.frame.size.width / 1.1
        let alertViewHeight: CGFloat = 100
        
        messegeView.createUI(messages: "Данного слова не существует в словаре. Проверьте написание и повторите попытку")
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
