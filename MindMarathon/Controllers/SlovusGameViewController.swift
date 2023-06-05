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
    var massLayer = [UIStackView]()
    let panelControllView = UIView()
    let panelControllStackView = UIStackView()
    private var stopwatch = Timer()
    private var isshowMessageAlert: Bool = false
    private var puzzleWord = ""
    private var userWords = ""
    let playButton = UIButton()
    let sizeWordButton = UIButton()
    let timerLabel = UILabel()
    let numberOfRows = 6
    var numberOfColumns = 5
    let containerView = UIView()
    let textFieldHeight: CGFloat = 50
    let textFieldWidth: CGFloat = 40
    let spacing: CGFloat = 20
    var massTextField = [UITextField]()
    var firstWordIndex = 0
    var lastWordIndex = 0
    var controllerTextField = 0
    var game: SlovusViewModel!
    var seconds = 0
    var isstartGame = false
    var iscontinuePlaying = false
    var maxLenght = 5
    var step = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        createUI()
        sizeWordButton.setTitle("5", for: .normal)
    }
    
    func createUI() {
        
        //panelControllView
        let playButton = UIButton()
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .systemBackground
        view.addSubview(panelControllView)
        
        sizeWordButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sizeWordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sizeWordButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        sizeWordButton.setTitle("5", for: .normal)
        sizeWordButton.tintColor = UIColor.label
        sizeWordButton.backgroundColor = UIColor.tertiaryLabel
        sizeWordButton.layer.cornerRadius = 10
        view.addSubview(sizeWordButton)
        
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(playButton)
        
        timerLabel.text = "0"
        timerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        panelControllStackView.addArrangedSubview(sizeWordButton)
        panelControllStackView.addArrangedSubview(playButton)
        panelControllStackView.addArrangedSubview(timerLabel)
        panelControllStackView.distribution = .equalCentering
        view.addSubview(panelControllStackView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        //gameBoardView
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 10
        containerView.isUserInteractionEnabled = false
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }

        //keyBoardView
        let keyBoardView = UIView()
        let sendWordsButton = UIButton()
        let keyBoardStacView = UIStackView()
        let keyboardFirstLayerStackView = UIStackView()
        let keyboardSecondLayerStackView = UIStackView()
        let keyboardThirdLayerStackView = UIStackView()
        let keyboardLayers = [keyboardFirstLayerStackView, keyboardSecondLayerStackView, keyboardThirdLayerStackView]
        let keyboard = [
            ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"],
            ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"],
            ["Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "delete"]
        ]
        
        view.addSubview(keyBoardView)
        
        keyBoardView.snp.makeConstraints { maker in
            maker.top.equalTo(containerView.snp.bottom).inset(-10)
            maker.height.equalTo(200)
            maker.left.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
        }
        
        for (indexRow, row) in keyboard.enumerated() {
            for indexKey in row {
                let keyboarButton = UIButton()
                if indexKey == "delete" {
                    keyboarButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
                    keyboarButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
                    keyboarButton.addTarget(self, action: #selector(deleteLastWord), for: .touchUpInside)
                } else {
                    keyboarButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
                    keyboarButton.setTitle(indexKey, for: .normal)
                    keyboarButton.layer.cornerRadius = 5
                    keyboarButton.backgroundColor = UIColor.systemBackground
                    keyboarButton.setTitleColor(UIColor.label, for: .normal)
                    keyboarButton.addTarget(self, action: #selector(letterinputTapped), for: .touchUpInside)
                }
                view.addSubview(keyboarButton)
                keyboardLayers[indexRow].addArrangedSubview(keyboarButton)
                view.addSubview(keyboardLayers[indexRow])
            }
            keyboardLayers[indexRow].snp.makeConstraints { maker in
                maker.height.equalTo(40)
            }
            keyBoardStacView.addArrangedSubview(keyboardLayers[indexRow])
        }
        
        sendWordsButton.setTitle("ОТПРАВИТЬ", for: .normal)
        sendWordsButton.backgroundColor = UIColor.systemBackground
        sendWordsButton.setTitleColor(UIColor.label, for: .normal)
        sendWordsButton.layer.cornerRadius = 10
        sendWordsButton.addTarget(self, action: #selector(sendWordsTupped), for: .touchUpInside)
        sendWordsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(sendWordsButton)
        
        for i in keyboardLayers {
            i.axis = .horizontal
            i.distribution = .fillEqually
            i.spacing = 5
        }
        
        keyBoardStacView.addArrangedSubview(sendWordsButton)
        keyBoardStacView.axis = .vertical
        keyBoardStacView.distribution = .fill
        keyBoardStacView.spacing = 5
        view.addSubview(keyBoardStacView)
        
        keyBoardStacView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalTo(keyBoardView).inset(5)
        }
    }
    
    func createPlaceGame() {
        let contentViewStackView = UIStackView()
        
        for i in massLayer {
            i.axis = .horizontal
            i.distribution = .fillEqually
            i.spacing = 1
        }
        
        for i in 0..<numberOfRows {
            for _ in 0..<numberOfColumns {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.spacing = 1
                massLayer.append(stackView)
                let textFieldWindow = UITextField()
                textFieldWindow.isEnabled = false
                textFieldWindow.tintColor = UIColor.label
                textFieldWindow.backgroundColor = UIColor.tertiaryLabel
                textFieldWindow.layer.cornerRadius = 5
                textFieldWindow.layer.borderColor = UIColor.gray.cgColor
                textFieldWindow.layer.borderWidth = 0.1
                textFieldWindow.font = UIFont(name: "HelveticaNeue-Medium", size: 30.0)
                textFieldWindow.textAlignment = .center
                massTextField.append(textFieldWindow)
                view.addSubview(textFieldWindow)
                massLayer[i].addArrangedSubview(textFieldWindow)
            }
            view.addSubview(massLayer[i])
            contentViewStackView.addArrangedSubview(massLayer[i])
        }
        
        view.addSubview(contentViewStackView)
        contentViewStackView.axis = .vertical
        contentViewStackView.distribution = .fillEqually
        contentViewStackView.spacing = 1
        
        contentViewStackView.snp.makeConstraints { maker in
            maker.left.equalTo(containerView).inset(10)
            maker.top.equalTo(containerView).inset(10)
            maker.right.equalTo(containerView).inset(10)
            maker.bottom.equalTo(containerView).inset(10)
        }
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
    
    func startNewGame() {
        lastWordIndex = Int(sizeWordButton.titleLabel?.text ?? "")!
        maxLenght = Int((sizeWordButton.titleLabel?.text)!)!
        controllerTextField = 0
        firstWordIndex = 0
        lastWordIndex = maxLenght
        step = 0
        seconds = 0
        createTimer()
        sizeWordButton.isEnabled = false
        puzzleWord = SlovusViewModel.shared.choiceRandomWord(size: maxLenght)
        print(puzzleWord)
    }
    
    func continueGame() {
        createTimer()
    }
    
    func pauseGame() {
        stopwatch.invalidate()
    }
    
    @objc func startGameTapped(_ sender: UIButton) {
        
        let chekPartGame = (isstartGame, iscontinuePlaying)
        
        if chekPartGame == (false, false) {
            isstartGame = true
            iscontinuePlaying = true
            numberOfColumns = Int(sizeWordButton.titleLabel?.text ?? "")!
            createPlaceGame()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startNewGame()
        } else if chekPartGame == (true, true) {
            iscontinuePlaying = false
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pauseGame()
        } else {
           iscontinuePlaying = true
            continueGame()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func deleteLastWord() {
        for i in massTextField[firstWordIndex..<lastWordIndex].reversed() {
            if !i.text!.isEmpty {
                i.text = ""
                break
            }
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
            if massTextField[controllerTextField].text?.count == 0 {
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
        let rulesVC = RulesViewController.instantiate()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 2)
        present(rulesVC, animated: true)
    }
    
    @objc func sendWordsTupped() {
        if userWords.count == maxLenght {
            if SlovusViewModel.shared.checkWord(wordToCheck: userWords) {
                makeColorTextField(massiveAnswer: SlovusViewModel.shared.checkWord(puzzleWord: puzzleWord, userWord: userWords.lowercased()), startIndex: firstWordIndex, lastIndex: lastWordIndex)
                if firstWordIndex < 30 && lastWordIndex < 30 {
                    controllerTextField = firstWordIndex + Int(sizeWordButton.titleLabel?.text ?? "")!
                    firstWordIndex += Int(sizeWordButton.titleLabel?.text ?? "")!
                    lastWordIndex += Int(sizeWordButton.titleLabel?.text ?? "")!
                }
            } else {
                if !isshowMessageAlert {
                    isshowMessageAlert = true
                    createAlertMessage()
                }
                
            }
        }
    }
    
    func checkCorrctAnswer(massiveAnswer: [Int]) -> Bool {
        for i in massiveAnswer {
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
        } else if step == 6 {
            createAlertMessage(description: "Ходы закончились! Мы загадали слово \(puzzleWord). Попробуешь еще раз?")
        }
        
        userWords = ""
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
    
    @objc func selectMaxLenghtTapped() {
        sizeWordButton.setTitle(SlovusViewModel.shared.selectMaxLenght(maxLenght: sizeWordButton.titleLabel?.text ?? ""), for: .normal)
    }

    func createAlertMessage() {
        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topPadding = window?.safeAreaInsets.top ?? 0
        let alertViewWidth: CGFloat = self.view.frame.size.width / 1.1
        let alertViewHeight: CGFloat = 100
        
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
            })
        }
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
        alertView.removeFromSuperview()
        startNewGame()
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
