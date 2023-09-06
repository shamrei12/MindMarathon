//
//  SlovusGameViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit

class SlovusGameViewController: UIViewController {
    private var messegeView: UserMistakeView!
    private var gameLevel: GameLevel!
    private let viewModel: SlovusViewModel
    private var massLayer = [UIStackView]()
    private var contentViewStackView = UIStackView()
    private let panelControllView = UIView()
    private let panelControllStackView = UIStackView()
    private var stopwatch = Timer()
    private let playButton = UIButton()
    private let levelButton = UIButton()
    private let containerView = UIView()
    private var massTextField = [UITextField]()
    private var firstWordIndex: Int = .zero
    private var lastWordIndex: Int = .zero
    private var controllerTextField: Int = .zero
    private var seconds: Int = .zero
    private var numberOfColumns: Int = 5
    private var maxLenght: Int = 5
    private let numberOfRows: Int = 6
    private var puzzleWord = ""
    private var userWords = ""
    private var isshowMessageAlert: Bool = false
    
    init(viewModel: SlovusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "viewColor")
        navigationBarCreate()
        createUI()
        gameLevel = GameLevel()
    }
    
    func navigationBarCreate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
    }
    
    func levelButtonCreated() {
        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        levelButton.setTitle("5", for: .normal)
        levelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        levelButton.titleLabel?.minimumScaleFactor = 0.5
        levelButton.tintColor = UIColor.label
        levelButton.backgroundColor = UIColor.lightGray
        levelButton.layer.cornerRadius = 10
        levelButton.backgroundColor = UIColor.lightGray
        levelButton.addShadow()
        view.addSubview(levelButton)
    }
    
    func playButtonCreated() {
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = UIColor.white
        playButton.backgroundColor = UIColor.systemBlue
        playButton.addShadow()
        view.addSubview(playButton)
    }
    
    func panelControlCreate() {
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
    
    func panelControlCreated() {
        levelButtonCreated()
        playButtonCreated()
        panelControlCreate()
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
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        return keyBoardView
    }
    
    func sendButtonCreated() -> UIButton {
        let sendWordsButton = UIButton()
        sendWordsButton.setTitle("ПРОВЕРИТЬ СЛОВО", for: .normal)
        sendWordsButton.setTitleColor(UIColor.label, for: .normal)
        sendWordsButton.layer.cornerRadius = 10
        sendWordsButton.backgroundColor = UIColor.systemBackground
        sendWordsButton.addShadow()
        sendWordsButton.addTarget(self, action: #selector(sendWordsTapped), for: .touchUpInside)
        view.addSubview(sendWordsButton)
        
        sendWordsButton.snp.makeConstraints { maker in
            maker.height.equalToSuperview().multipliedBy(0.22)
        }
        
        return sendWordsButton
    }
    
    func layerKeyboardCreate(letters: [String]) -> UIStackView {
        let keyboardRowStackView = UIStackView()
        keyboardRowStackView.axis = .horizontal
        keyboardRowStackView.spacing = 5
        keyboardRowStackView.distribution = .fillEqually
        
        for letter in letters {
            let keyboarButton = UIButton()
            keyboarButton.addShadow()
            keyboarButton.layer.cornerRadius = 5
            
            if letter == "delete" {
                keyboarButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
                keyboarButton.tintColor = UIColor.black
                keyboarButton.backgroundColor = .clear
                keyboarButton.addTarget(self, action: #selector(deleteLastWord), for: .touchDown)
            } else {
                keyboarButton.setTitle(letter, for: .normal)
                keyboarButton.backgroundColor = .systemBackground
                keyboarButton.setTitleColor(UIColor.label, for: .normal)
                keyboarButton.addTarget(self, action: #selector(letterinputTapped), for: .touchDown)
            }
            keyboardRowStackView.addArrangedSubview(keyboarButton)
        }
        return keyboardRowStackView
    }
    
    func keyboardCreated() {
        let view = keyboardViewCreated()
        let keyBoardStackView = UIStackView()
        keyBoardStackView.addArrangedSubview(layerKeyboardCreate(letters: ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"]))
        keyBoardStackView.addArrangedSubview(layerKeyboardCreate(letters: ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"]))
        keyBoardStackView.addArrangedSubview(layerKeyboardCreate(letters: ["Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "delete"]))
        keyBoardStackView.addArrangedSubview(sendButtonCreated())
        
        keyBoardStackView.axis = .vertical
        keyBoardStackView.distribution = .fillEqually
        keyBoardStackView.spacing = 5
        view.addSubview(keyBoardStackView)
        
        keyBoardStackView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide).inset(5)
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
    
    func clearPlaceGame() {
        massTextField.removeAll()
        massLayer.removeAll()
        
        // Удаляем все элементы из contentViewStackView
        for view in contentViewStackView.arrangedSubviews {
            contentViewStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        // Добавляем contentViewStackView на view
        view.addSubview(contentViewStackView)
    }
    
    func createPlaceGame() {
        clearPlaceGame()
        
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
        levelButton.setTitle(String(gameLevel.getLevel(currentLevel: Int(levelButton.titleLabel!.text!)!, step: 1, curentGame: CurentGame.slovusGame)), for: .normal)
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
        let chekPartGame = (viewModel.isstartGame, viewModel.iscontinuePlaying)
        if chekPartGame == (false, false) {
            startNewGame()
        } else if chekPartGame == (true, true) {
            pauseGame()
            showAlertAboutFinishGame()
        } else {
            viewModel.iscontinuePlaying = true
            continueGame()
        }
    }
    
    func endGame() {
        self.dismiss(animated: true)
    }
    
    func startingConditions() {
        levelButton.isEnabled = false
        viewModel.isstartGame = true
        viewModel.iscontinuePlaying = true
    }
    
    func finishingConditions() {
        levelButton.isEnabled = true
        viewModel.isstartGame = false
        viewModel.iscontinuePlaying = false
    }
    
    func resetElementsGame() {
        lastWordIndex = maxLenght
        numberOfColumns = maxLenght
        controllerTextField = 0
        firstWordIndex = 0
        viewModel.step = 0
        seconds = 0
    }
    
    func getPuzzleWord() -> String {
        maxLenght = Int((levelButton.titleLabel?.text)!)!
        return viewModel.choiceRandomWord(size: maxLenght)
    }
    
    func startNewGame() {
        resetElementsGame()
        createTimer()
        startingConditions()
        puzzleWord = getPuzzleWord()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createPlaceGame()
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        viewModel.iscontinuePlaying = true
    }
    
    func pauseGame() {
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        stopwatch.invalidate()
        navigationItem.title = "PAUSE"
    }
    
    func restartGame() {
        for i in massTextField {
            i.textColor = UIColor.label
            i.backgroundColor = UIColor.tertiaryLabel
            i.text = ""
        }
        pauseGame()
        resetElementsGame()
        finishingConditions()
    }
    
    func exitGame() {
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
        if (viewModel.isstartGame, viewModel.iscontinuePlaying) == (true, true) {
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
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController(game: viewModel.game)
        rulesVC.modalPresentationStyle = .formSheet
        present(rulesVC, animated: true)
    }
    
    @objc func sendWordsTapped() {
        if userWords.count == maxLenght {
            if viewModel.checkWord(wordToCheck: userWords) {
                makeColorTextField(massiveAnswer: viewModel.checkWord(puzzleWord: puzzleWord.uppercased(), userWord: userWords.uppercased()), startIndex: firstWordIndex, lastIndex: lastWordIndex)
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
        viewModel.step += 1
        checkCondition(massiveAnswer: massiveAnswer)
        userWords = ""
    }
    
    func checkCondition(massiveAnswer: [Int]) {
        if checkCorrctAnswer(massiveAnswer: massiveAnswer) {
            stopwatch.invalidate()
            showAlertAboutFinishGame(title: "Конец игры", message: "Поздравляем! Мы загадали слово \(puzzleWord), которое вы угадали за \(TimeManager.shared.convertToMinutes(seconds: seconds)) и за \(viewModel.step) попыток")
            let resultGame = WhiteBoardModel(nameGame: "Словус", resultGame: "Победа", countStep: "\(viewModel.step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
            
        } else if viewModel.step == 6 {
            stopwatch.invalidate()
            showAlertAboutFinishGame(title: "Конец игры", message: "Ходы закончились! Мы загадали слово \(puzzleWord). Попробуешь еще раз?")
            let resultGame = WhiteBoardModel(nameGame: "Словус", resultGame: "Поражение", countStep: "\(viewModel.step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        }
    }
}

extension SlovusGameViewController {
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
    
    func showAlertAboutFinishGame(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Новая игра", style: .default) { _ in
            self.restartGame()
        }
        alertController.addAction(continueAction)
        let endAction = UIAlertAction(title: "Выйти из игры", style: .destructive) { _ in
            self.exitGame()
            
        }
        alertController.addAction(endAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAboutFinishGame() {
        let alertController = UIAlertController(title: "Внимание!", message: "Вы действительно хотите закончить игру?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Продолжить", style: .default) { _ in
            self.continueGame()
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Закончить игру", style: .destructive) { _ in
            self.restartGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
