//
//  FloodFillViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.05.23.
//

import UIKit

class FloodFillViewController: UIViewController, AlertDelegate {
    private var levelButton = UIButton()
    private let timerLabel = UILabel()
    private let gameView = UIView()
    private let colorView = UIView()
    private var contentViewStackView = UIStackView()
    private var massLayer = [UIStackView]()
    private let panelControllView = UIView()
    private let panelControllStackView = UIStackView()
    private var gridSize = 5
    private let cellSize: CGFloat = 40 // Размер ячейки
    private var stopwatch = Timer()
    private var seconds = 0
    private var alertView: ResultAlertView!
    private var messegeView: UserMistakeView!
    private var cells = [[UIView]]()
    private var row = [UIView]()
    private var isStartGame: Bool = false
    private var isContinuePlaying: Bool = false
    private var colorMassiveButton = [UIButton]()
    private var colorMass = [UIColor(hex: 0xff2b66), UIColor(hex: 0xfee069), UIColor(hex: 0x8ae596), UIColor(hex: 0x006fc5), UIColor(hex: 0xd596fa), UIColor(hex: 0xffb5a3)]
    private var indexTag = 0
    private var currentColor = UIColor()
    private var selectedColor = UIColor()
    let playButton = UIButton()
    var game: FloodFillViewModel = FloodFillViewModel()
    private var gameLevel: GameLevel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        self.view.backgroundColor = UIColor(named: "viewColor")
        createUI()
        gameLevel = GameLevel()
    }
    
    func levelButtonCreated() {
        levelButton.addTarget(self, action: #selector(selectMaxSizeTapped), for: .touchUpInside)
        levelButton.setTitle("5", for: .normal)
        levelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        levelButton.titleLabel?.minimumScaleFactor = 0.5
        levelButton.tintColor = UIColor.blue
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
    
    func createUI() {
        
        guard let firstColor = colorMass.first else { return }
        selectedColor = firstColor
        
        panelControlCreated()
        
        gameView.layer.cornerRadius = 10
        gameView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameView)
        gameView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(100)
            maker.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.9)
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.9)
            maker.centerX.equalTo(self.view)
            maker.centerY.equalTo(self.view)
        }
        let colorStackView = UIStackView()
        colorView.backgroundColor = .clear
        colorView.layer.cornerRadius = 10
        view.addSubview(colorView)
        view.addSubview(colorStackView)
        colorStackView.axis = .horizontal
        colorStackView.distribution = .equalSpacing
        colorStackView.spacing = 10
        
        for index in 0..<colorMass.count {
            let colorButton = UIButton()
            colorButton.backgroundColor = UIColor(cgColor: colorMass[index].cgColor)
            colorButton.layer.cornerRadius = 10
            colorButton.tag = index
            colorButton.addTarget(self, action: #selector(selectedColorTapped), for: .touchUpInside)
            view.addSubview(colorButton)
            colorButton.snp.makeConstraints { maker in
                maker.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.15)
            }
            colorStackView.addArrangedSubview(colorButton)
            colorMassiveButton.append(colorButton)
        }
        
        colorView.snp.makeConstraints { maker in
            maker.top.equalTo(gameView.snp.bottom).inset(-10)
            maker.bottom.equalToSuperview().inset(30)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.15)
        }
        
        colorStackView.snp.makeConstraints { maker in
            maker.left.right.bottom.top.equalTo(colorView).inset(0.001)
        }
    }
    
    // MARK: Выход и правила
    @objc func cancelTapped() {
        if alertView != nil {
            alertView.removeFromSuperview()
        }
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
        let rulesVC = RulesViewController()
        rulesVC.modalPresentationStyle = .formSheet
        rulesVC.rulesGame(numberGame: 3)
        present(rulesVC, animated: true)
    }
    
    // MARK: создание поля с игрой
    func createGamePlace(sizePlace: Int) {
        indexTag = 0
        var row = [UIView]() // Инициализируем переменную row
        
        for _ in 0..<gridSize {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            massLayer.append(stackView)
        }
        
        for index in 0..<gridSize {
            for _ in 0..<gridSize {
                let cell = UIView()
                cell.tag = indexTag
                indexTag += 1
                cell.backgroundColor = UIColor.tertiaryLabel
                cell.layer.borderColor = UIColor.black.cgColor
                massLayer[index].addArrangedSubview(cell)
                row.append(cell)
            }
            view.addSubview(massLayer[index])
            contentViewStackView.addArrangedSubview(massLayer[index])
            cells.append(row)
            row.removeAll()
        }
        
        view.addSubview(contentViewStackView)
        contentViewStackView.axis = .vertical
        contentViewStackView.distribution = .fillEqually
        contentViewStackView.spacing = 0
        
        contentViewStackView.snp.makeConstraints { maker in
            maker.left.equalTo(gameView).inset(5)
            maker.top.equalTo(gameView).inset(5)
            maker.right.equalTo(gameView).inset(5)
            maker.bottom.equalTo(gameView).inset(5)
        }
        
        coloringView() // Вызываем функцию расскрашивания ячеек
    }
    
    func coloringView() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let color = colorMass[Int.random(in: 0...colorMass.count - 1)]
                cells[i][j].backgroundColor = UIColor(cgColor: color.cgColor)
            }
        }
    }
    
    @objc func selectedColorTapped(sender: UIButton) {
        let chekPartGame = (isStartGame, isContinuePlaying)
        if chekPartGame == (true, true) {
            for index in colorMassiveButton {
                index.layer.borderColor = .none
                index.layer.borderWidth = 0
            }
            
            selectedColor = colorMass[sender.tag]
            
            let currentColor = cells[0][0].backgroundColor
            
            if currentColor != selectedColor {
                game.countStep += 1
                fillCell(row: 0, col: 0, color: selectedColor, currentColor: currentColor!)
            }
        }
        // Проверяем, достигнута ли цель
        if checkResult() {
            stopwatch.invalidate()
            createAlertMessage(description: "Поздравляем. Вы полностью закрасили поле за \(TimeManager.shared.convertToMinutes(seconds: seconds)) и \(game.gameResult()) ходов.")
            let resultGame = WhiteBoardModel(nameGame: "Заливка", resultGame: "Победа", countStep: "\(game.gameResult())", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
            RealmManager.shared.saveResult(result: resultGame)
        }
    }
    
    func fillCell(row: Int, col: Int, color: UIColor, currentColor: UIColor) {
        // Проверяем, что ячейка находится в пределах игрового поля
        guard row >= 0 && row < gridSize && col >= 0 && col < gridSize else {
            return
        }
        let cell = cells[row][col]
        
        // Проверяем, что ячейка еще не закрашена выбранным цветом
        guard cell.backgroundColor != color else {
            return
        }
        // Проверяем, что цвет ячейки совпадает с текущим цветом
        guard cell.backgroundColor == currentColor else {
            return
        }
        // Закрашиваем ячейку выбранным цветом
        cell.backgroundColor = color
        // Рекурсивно закрашиваем соседние ячейки выбранным цветом
        fillCell(row: row + 1, col: col, color: color, currentColor: currentColor)
        fillCell(row: row - 1, col: col, color: color, currentColor: currentColor)
        fillCell(row: row, col: col + 1, color: color, currentColor: currentColor)
        fillCell(row: row, col: col - 1, color: color, currentColor: currentColor)
    }
    
    func checkResult() -> Bool {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                if cells[i][j].backgroundColor != selectedColor {
                    return false
                }
            }
        }
        return true
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
    
    @objc func startGameTapped(_ sender: UIButton) {
        let chekPartGame = (isStartGame, isContinuePlaying)
        
        if chekPartGame == (false, false) {
            isStartGame = true
            isContinuePlaying = true
            startNewGame()
        } else if chekPartGame == (true, true) {
            isContinuePlaying = false
            pauseGame()
        } else {
            isContinuePlaying = true
            continueGame()
        }
    }
    
    func startNewGame() {
        let size = levelButton.titleLabel?.text ?? ""
        gridSize = Int(size)!
        createGamePlace(sizePlace: gridSize)
        seconds = 0
        createTimer()
        levelButton.isEnabled = false
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func continueGame() {
        gameView.isUserInteractionEnabled = true
        colorView.isUserInteractionEnabled = true
        createTimer()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func pauseGame() {
        gameView.isUserInteractionEnabled = false
        colorView.isUserInteractionEnabled = false
        stopwatch.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        navigationItem.title = "PAUSE"
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
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        
        for view in contentViewStackView.arrangedSubviews {
            contentViewStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        contentViewStackView.removeFromSuperview()
        
        massLayer.removeAll()
        cells.removeAll()
        pauseGame()
        indexTag = 0
        timerLabel.text = "0"
        levelButton.isEnabled = true
        isContinuePlaying = false
        isStartGame = false
        game.countStep = 0
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func selectMaxSizeTapped(_ sender: UIButton) {
        sender.setTitle(String(gameLevel.getLevel(level: Int(sender.titleLabel!.text!)!, step: 1, curentGame: CurentGame.floodFillGame)), for: .normal)
    }
}
//
