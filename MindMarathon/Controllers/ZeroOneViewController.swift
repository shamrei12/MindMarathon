//
//  ZeroOneViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 2.07.23.
//

import UIKit

class ZeroOneViewController: UIViewController, AlertDelegate {
    
    let panelControllView = UIView()
    let panelControllStackView = UIStackView()
    let sendClearStackView = UIStackView()
    let clearMoves = UIButton()
    private var stopwatch = Timer()
    private var seconds = 0
    var isstartGame = false
    var iscontinuePlaying = false
    let playButton = UIButton()
    let levelButton = UIButton()
    private var alertView: ResultAlertView!
    let containerView = UIView()
    private var gridSize = 4
    private let contentStackView = UIStackView()
    private var index = 0
    private var massLayer = [UIStackView]()
    private var cells = [[UIView]]()
    private var row = [UIView]()
    private var messegeView: UserMistakeView!
    private var game = ZeroOneViewModel()
    
    private var colorMass = [UIColor(hex: 0xb5b5b5),UIColor(hex: 0xff2b66), UIColor(hex: 0x006fc5)]
    let checkResultButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "viewColor")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        createUI()
        
    }
    
    func createUI() {
        //ControlStatusGame
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(panelControllView)
        levelButton.addTarget(self, action: #selector(selectedGridSize), for: .touchUpInside)
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
        
        //GameZone
        containerView.backgroundColor = UIColor(named: "gameElementColor")
        containerView.layer.cornerRadius = 10
        containerView.isUserInteractionEnabled = false
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-30)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(350)
        }
        
        
        checkResultButton.layer.cornerRadius = 10
        checkResultButton.backgroundColor = UIColor(named: "gameElementColor")
        checkResultButton.setTitle("ПРОВЕРИТЬ", for: .normal)
        checkResultButton.setTitleColor(.label, for: .normal)
        checkResultButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        checkResultButton.addTarget(self, action: #selector(checkResultTapped), for: .touchUpInside)
        checkResultButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(checkResultButton)
        
        
        clearMoves.layer.cornerRadius = 10
        clearMoves.backgroundColor = UIColor(named: "gameElementColor")
        clearMoves.setTitle("Очистить", for: .normal)
        clearMoves.setTitleColor(.label, for: .normal)
        clearMoves.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        clearMoves.addTarget(self, action: #selector(clearColor), for: .touchUpInside)
        clearMoves.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(clearMoves)
        
        sendClearStackView.axis = .horizontal
        sendClearStackView.alignment = .fill
        sendClearStackView.distribution = .fillEqually
        sendClearStackView.spacing = 10
        
        sendClearStackView.addArrangedSubview(clearMoves)
        sendClearStackView.addArrangedSubview(checkResultButton)
        view.addSubview(sendClearStackView)
        
        sendClearStackView.snp.makeConstraints { maker in
            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(10)
            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(10)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
    func createGamePlace(size: Int) {
        for _ in 0..<gridSize {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            massLayer.append(stackView)
        }
        
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                let cell = UIView()
                cell.addGestureRecognizer(tapRecognizer)
                cell.backgroundColor = UIColor.tertiaryLabel
                massLayer[i].addArrangedSubview(cell)
                row.append(cell)
            }
            view.addSubview(massLayer[i])
            contentStackView.addArrangedSubview(massLayer[i])
            cells.append(row)
            row.removeAll()
        }
        
        view.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 5
        
        contentStackView.snp.makeConstraints { maker in
            maker.left.equalTo(containerView).inset(10)
            maker.top.equalTo(containerView).inset(10)
            maker.right.equalTo(containerView).inset(10)
            maker.bottom.equalTo(containerView).inset(10)
        }
        
        createGameElement()
    }
    //Cоздание view
    func createGameElement() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                cells[i][j].tag = 0
                cells[i][j].isUserInteractionEnabled = true
                cells[i][j].layer.cornerRadius = 5
            }
        }
        
        for i in 0..<gridSize {
            let random = makeRandomDiggit(min: 1, max: 2)
            cells[i][random].tag = makeRandomDiggit(min: 1, max: 2)
            cells[i][random].isUserInteractionEnabled = false
        }
        coloringView()
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
    
    @objc
    func selectedGridSize(sender: UIButton) {
        sender.setTitle( game.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""), for: .normal)
    }
    
    //MARK: управление статусом игры
    func startNewGame() {
        seconds = 0
        createTimer()
        gridSize = Int((levelButton.titleLabel?.text)!)!
        levelButton.isEnabled = false
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        createGamePlace(size: gridSize)
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
    
    //раскраская каждого view в зависимости от tag
    func coloringView() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                makeColor(viewElement: cells[i][j])
            }
        }
    }
    
    
    //функция случайного числа
    func makeRandomDiggit(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    //функция раскраски view
    func makeColor(viewElement: UIView) {
        switch viewElement.tag {
        case 1:
            viewElement.backgroundColor = UIColor(cgColor: colorMass[1].cgColor)
            viewElement.layer.shadowColor = UIColor.black.cgColor
            viewElement.layer.shadowOpacity = 0.8
            viewElement.layer.shadowOffset = CGSize(width: 1, height: 1)
            viewElement.layer.shadowRadius = 5
            
            
        case 2:
            viewElement.backgroundColor = UIColor(cgColor: colorMass[2].cgColor)
            viewElement.layer.shadowColor = UIColor.black.cgColor
            viewElement.layer.shadowOpacity = 0.8
            viewElement.layer.shadowOffset = CGSize(width: 1, height: 1)
            viewElement.layer.shadowRadius = 5
        default:
            viewElement.backgroundColor = UIColor(cgColor: colorMass[0].cgColor)
            viewElement.layer.shadowColor = .none
            viewElement.layer.shadowOpacity = 1
            viewElement.layer.shadowOffset = CGSize(width: 0, height: 0) // смещение тени
            viewElement.layer.shadowRadius = 0 // радиус размытия тени
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    func rulesTapped() {
        let rulesVC = RulesViewController()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 5)
    }
    
    @objc
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let selectedCell = recognizer.view else {
            return
        }
        
        if selectedCell.isUserInteractionEnabled {
            if selectedCell.tag + 1 > 2 {
                selectedCell.tag = 0
            } else {
                selectedCell.tag = selectedCell.tag + 1
            }
            makeColor(viewElement: selectedCell)
        }
    }
    
    func clearGame() {
        for view in contentStackView.arrangedSubviews {
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
  
        
        contentStackView.removeFromSuperview()
        cells.removeAll()
        row.removeAll()
        massLayer.removeAll()
    }
    
    @objc
    func checkResultTapped() {
        let mass = createMassiveTag()
        
        guard !checkForZero(array: mass) else {
            return
        }
        
        if makeAnswer(mass: mass) {
            createAlertMessage(description: "Победа! Вы закрасили все поле за \(TimeManager.shared.convertToMinutes(seconds: seconds)). Неплохой результат. Дальше больше!")
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
    
    func makeAnswer(mass: [[Int]]) -> Bool {
        
        guard uniqueLines(line: mass) else {
            createMistakeMessage(messages: "В одной из строк у Вас ошибка. Проверьте и повторите попытку")
            return false
        }
        
        guard uniqueRows(mass: mass) else {
            createMistakeMessage(messages: "В одном из столбцов у Вас ошибка. Проверьте и повторите попытку")
            return false
        }
        
        return true
    }
    
    func uniqueLines(line: [[Int]]) -> Bool {
        for i in 0..<gridSize {
            if !equalCountOfOnesAndTwos(array: line[i]) {
                return false
            }
        }
        return true
    }
    
    func uniqueRows(mass: [[Int]]) -> Bool {
        
        var newMass = [[Int]]()
        
        for i in 0..<gridSize {
            var newLine = [Int]()
            for j in 0..<gridSize {
                newLine.append(mass[j][i])
            }
            newMass.append(newLine)
        }
        
        if uniqueLines(line: newMass) {
            return true
        } else {
            return false
        }
    }
    
    func checkForZero(array: [[Int]]) -> Bool {
        return array.flatMap { $0 }.contains(0)
    }
    
    func equalCountOfOnesAndTwos(array: [Int]) -> Bool {
        let onesCount = array.reduce(0) { $1 == 1 ? $0 + 1 : $0 }
        let twosCount = array.reduce(0) { $1 == 2 ? $0 + 1 : $0 }
        
        return onesCount == twosCount
    }

    
    func createMassiveTag() -> [[Int]] {
        var resultMass = [[Int]]()
        for i in 0..<gridSize {
            var row = [Int]() // Создаем новую строку
            for j in 0..<gridSize {
                row.append(cells[i][j].tag) // Добавляем значение в строку
            }
            resultMass.append(row) // Добавляем строку в результат
        }
        return resultMass
    }
    
    
    @objc
    func clearColor() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                if cells[i][j].isUserInteractionEnabled {
                    cells[i][j].tag = 0
                    makeColor(viewElement: cells[i][j])
                }
            }
        }
    }
    
    func createMistakeMessage(messages: String) {
        guard messegeView == nil else {
            return
        }
        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topPadding = window?.safeAreaInsets.top ?? 0
        let alertViewWidth: CGFloat = self.view.frame.size.width / 1.1
        let alertViewHeight: CGFloat = 90
        
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
                self.messegeView = nil
            })
        }
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        pauseGame()
        levelButton.isEnabled = true
        game.isContinueGame = false
        game.isStartGame = false
        stopwatch.invalidate()
        seconds = 0
        clearGame()
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
}
