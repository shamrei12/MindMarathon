//
//  SlovusGameViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit

protocol KeyboardDelegate: AnyObject {
    func keyPressed(_ key: String)
    func deletePressed()
    func sendWordsTapped()
}

final class SlovusGameViewController: UIViewController, KeyboardDelegate {
    
    private enum GameCondition {
        case started
        case finished
    }
    
    private let keyboardView = KeyboardView()
    private var messegeView: UserMistakeView!
    private var massLayer = [UIStackView]()
    private var contentViewStackView = UIStackView()
    private let panelControllView = UIView()
    private let panelControllStackView = UIStackView()
    private var massiveKeyboardButtons = [UIButton]()
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
    private var stopwatch: Timer?
    private var gameLevel: GameLevel = GameLevel()
    private let viewModel: SlovusViewModel
    
    init(viewModel: SlovusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        navigationBarCreate()
        panelControlCreated()
        continerCreated()
        keyboardView.delegate = self
        view.addSubview(keyboardView)

        keyboardViewCreated()
    }
    
    private func panelControlCreated() {
        levelButtonCreate()
        createPlayButton()
        panelControlCreate()
    }
    
    private func navigationBarCreate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила".localize(), style: .plain, target: self, action: #selector(rulesTapped))
    }
    
    private func levelButtonCreate() {
        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        levelButton.setTitle("5", for: .normal)
        levelButton.titleLabel?.font = Fonts.helveticaNeueBold(20)
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        levelButton.titleLabel?.minimumScaleFactor = 0.5
        levelButton.tintColor = .label
        levelButton.layer.cornerRadius = 10
        levelButton.backgroundColor = .lightGray
        levelButton.addShadow()
        
        view.addSubview(levelButton)
    }
    
    private func createPlayButton() {
        playButton.setImage(Icons.playFill, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 10
        playButton.tintColor = .white
        playButton.addShadow()
        
        view.addSubview(playButton)
    }
    
    private func panelControlCreate() {
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
    
    private func continerCreated() {
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 10
        containerView.isUserInteractionEnabled = false
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
    }
    
    private func keyboardViewCreated() /*-> UIView */{
        keyboardView.keyboardCreated()
        keyboardView.snp.makeConstraints { maker in
            maker.top.equalTo(containerView.snp.bottom).inset(-5)
            maker.left.right.equalToSuperview().inset(5)
            maker.bottom.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.26)
        }
    }
    
    func textFieldWindowCreated() -> UITextField {
        let textFieldWindow = UITextField()
        textFieldWindow.isEnabled = false
        textFieldWindow.tintColor = .label
        textFieldWindow.backgroundColor = .tertiaryLabel
        textFieldWindow.layer.cornerRadius = 5
        textFieldWindow.layer.borderColor = UIColor.gray.cgColor
        textFieldWindow.layer.borderWidth = 0.1
        textFieldWindow.font = Fonts.helveticaNeueBold(40)
        textFieldWindow.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        textFieldWindow.minimumFontSize = 30
        textFieldWindow.textAlignment = .center
        
        return textFieldWindow
    }
    
    func clearPlaceGame() {
        massTextField.removeAll()
        massLayer.removeAll()
        for view in contentViewStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        containerView.addSubview(contentViewStackView)
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
        
        // setup conditions
        for i in massLayer {
            i.axis = .horizontal
            i.distribution = .fillEqually
            i.spacing = 1
        }
        
        contentViewStackView.axis = .vertical
        contentViewStackView.distribution = .fillEqually
        contentViewStackView.spacing = 1
        contentViewStackView.layer.cornerRadius = 5
        
        contentViewStackView.snp.makeConstraints { maker in
            maker.edges.equalTo(containerView).inset(5)
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
    
    private func gameCondition(_ condition: GameCondition) {
        switch condition {
        case .started:
            levelButton.isEnabled = false
            viewModel.isstartGame = true
            viewModel.iscontinuePlaying = true
        case .finished:
            levelButton.isEnabled = true
            viewModel.isstartGame = false
            viewModel.iscontinuePlaying = false
        }
    }
    
    func resetElementsGame() {
        maxLenght = Int((levelButton.titleLabel?.text)!)!
        lastWordIndex = maxLenght
        numberOfColumns = maxLenght
        controllerTextField = 0
        firstWordIndex = 0
        viewModel.step = 0
        seconds = 0
    }
    
    func getPuzzleWord() -> String {
        return viewModel.choiceRandomWord(size: maxLenght)
    }
    
    func startNewGame() {
        resetElementsGame()
        createTimer()
        gameCondition(.started)
        puzzleWord = getPuzzleWord()
        print(puzzleWord)
        playButton.setImage(Icons.pauseFill, for: .normal)
        createPlaceGame()
    }
    
    func continueGame() {
        createTimer()
        playButton.setImage(Icons.pauseFill, for: .normal)
        viewModel.iscontinuePlaying = true
    }
    
    func pauseGame() {
        playButton.setImage(Icons.playFill, for: .normal)
        stopwatch?.invalidate()
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
        gameCondition(.finished)
        clearKeyboardButtons()
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
    
    func letterinputTapped(letter: String) {
        if (viewModel.isstartGame, viewModel.iscontinuePlaying) == (true, true) {
            
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
    
    func deletePressed() {
        for i in massTextField[firstWordIndex..<lastWordIndex].reversed() where !i.text!.isEmpty {
            i.text = ""
            break
        }
        
        if controllerTextField - 1 >= firstWordIndex {
            controllerTextField -= 1
            userWords = String(userWords.dropLast())
        }
    }
    
    func keyPressed(_ key: String) {
        letterinputTapped(letter: key)
    }
    
    func sendWordsTapped() {
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
    
    func makeColorTextField(massiveAnswer: ([Int], [Character: Int]), startIndex: Int, lastIndex: Int) {
        let massiveIndex = Array(startIndex..<lastIndex)
        let arrayResponse = massiveAnswer.0
        for i in 0..<arrayResponse.count {
            if arrayResponse[i] == 0 {
                massTextField[massiveIndex[i]].textColor = .lightGray
            } else if arrayResponse[i] == 1 {
                massTextField[massiveIndex[i]].textColor = .white
                massTextField[massiveIndex[i]].backgroundColor = .systemYellow
            } else if arrayResponse[i] == 2 {
                massTextField[massiveIndex[i]].textColor = .white
                massTextField[massiveIndex[i]].backgroundColor = .systemGreen
            }
        }
        coloringButtonsKeyboard(arrayColor: massiveAnswer.1)
        
        viewModel.step += 1
        checkCondition(massiveAnswer: arrayResponse)
        userWords = ""
    }
    
    func clearKeyboardButtons() {
        keyboardView.clearColorButtons()
    }
    
    func coloringKeyboardButtons(letter: String, color: UIColor) {
        
        for button in keyboardView.massiveKeyboardButtons {
            if button.titleLabel?.text ?? "" == letter {
                button.backgroundColor = color
            }
        }
    }
                                         
    func coloringButtonsKeyboard(arrayColor: [Character: Int]) {
        for value in arrayColor {
            switch value.value {
            case 0: coloringKeyboardButtons(letter: String(value.key), color: .systemGray)
            case 1: coloringKeyboardButtons(letter: String(value.key), color: .systemYellow)
            case 2: coloringKeyboardButtons(letter: String(value.key), color: .systemGreen)
            default: print("Error")
            }
        }
    }
    
    func checkCondition(massiveAnswer: [Int]) {
        if checkCorrctAnswer(massiveAnswer: massiveAnswer) {
            stopwatch?.invalidate()
            let steper = viewModel.step
            let puzzle = puzzleWord
            let time = TimeManager.shared.convertToMinutes(seconds: seconds)
            showAlertAboutFinishGame(title: "End game".localize(), message: "congratulations_message".localize() + "puzzleWord_message".localize() + "\(puzzleWord). " + "time_message".localize() + "\(time)")
            let resultGame = WhiteBoardModel(nameGame: "Словус".localize(), resultGame: "Победа".localize(), countStep: "\(viewModel.step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        } else if viewModel.step == 6 {
            stopwatch?.invalidate()
            showAlertAboutFinishGame(title: NSLocalizedString("End game", comment: ""), message: String(format: NSLocalizedString("The moves are over! We made a word %@. Will you try again?", comment: ""), puzzleWord))
            let resultGame = WhiteBoardModel(nameGame: "Словус".localize(), resultGame: "Поражение".localize(), countStep: "\(viewModel.step)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
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
        
        messegeView.createUI(messages: "This word does not exist in the dictionary. Check the spelling and try again".localize())
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
    
    func showAlertAboutFinishGame() {
        let alertController = UIAlertController(title: "Attention!".localize(), message: "Do you really want to finish the game?".localize(), preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue".localize(), style: .default) { _ in
            self.continueGame() // Вызов функции 1 при нажатии кнопки "Продолжить"
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
            self.restartGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAboutFinishGame(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "New game".localize(), style: .default) { _ in
            self.restartGame()
        }
        alertController.addAction(continueAction)
        
        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
            self.exitGame()
        }
        alertController.addAction(endAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
