//
//  FloodFillViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.05.23.
//

import UIKit

class FloodFillViewController: UIViewController {
    private var gameLevel: GameLevel!
    private let viewModel: FloodFillViewModel
    private var messegeView: UserMistakeView!
    private var colorStackView = UIStackView()
    private var levelButton = UIButton()
    private let timerLabel = UILabel()
    private let gameView = UIView()
    private let colorView = UIView()
    private let panelControllStackView = UIStackView()
    private let panelControllView = UIView()
    private var contentViewStackView = UIStackView()
    private var massLayer = [UIStackView]()
    private var stopwatch = Timer()
    private var currentColor = UIColor()
    private var selectedColor = UIColor()
    private let playButton = UIButton()
    private var cells = [[UIView]]()
    private var row = [UIView]()
    private var colorMassiveButton = [UIButton]()
    private var indexTag: Int = .zero
    private var seconds: Int = .zero
    private var gridSize = 5
    private let cellSize: CGFloat = 40 // Размер ячейки
    private var colorMass = [UIColor(hex: 0xff2b66), UIColor(hex: 0xfee069), UIColor(hex: 0x8ae596), UIColor(hex: 0x006fc5), UIColor(hex: 0xd596fa), UIColor(hex: 0xffb5a3)]
    private var isStartGame: Bool = false
    private var isContinuePlaying: Bool = false

    init(viewModel: FloodFillViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rules".localize(), style: .plain, target: self, action: #selector(rulesTapped))
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
    
    func gameViewCreated() {
        gameView.layer.cornerRadius = 10
        gameView.backgroundColor = .clear
        view.addSubview(gameView)
        gameView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(100)
            maker.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.95)
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.95)
            maker.centerX.equalTo(self.view)
            maker.centerY.equalTo(self.view)
        }
    }
    
    func createButtonColorView(index: Int) -> UIButton {
        let colorButton = UIButton()
        colorButton.backgroundColor = UIColor(cgColor: colorMass[index].cgColor)
        colorButton.layer.cornerRadius = 10
        colorButton.tag = index
        colorButton.addShadow()
        colorButton.addTarget(self, action: #selector(selectedColorTapped), for: .touchUpInside)
        return colorButton
    }
    
    func createColorStackView() {
        colorStackView.axis = .horizontal
        colorStackView.distribution = .equalSpacing
        colorStackView.spacing = 10
        view.addSubview(colorStackView)
    }
    
    func createStackViewWithColorButton() {
        for index in 0..<colorMass.count {
            let colorButton = createButtonColorView(index: index)
            view.addSubview(colorButton)
            colorButton.snp.makeConstraints { maker in
                maker.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.15)
            }
            colorStackView.addArrangedSubview(colorButton)
            colorMassiveButton.append(colorButton)
        }
        colorStackView.snp.makeConstraints { maker in
            maker.left.right.bottom.top.equalTo(colorView).inset(0.001)
        }
    }
    
    func createColorView() {
        colorView.backgroundColor = .clear
        colorView.layer.cornerRadius = 10
        view.addSubview(colorView)
        colorView.snp.makeConstraints { maker in
            maker.top.equalTo(gameView.snp.bottom).inset(-10)
            maker.bottom.equalToSuperview().inset(30)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.15)
        }
    }
    
    func createUI() {
        guard let firstColor = colorMass.first else { return }
        selectedColor = firstColor
        
        panelControlCreated()
        gameViewCreated()
        
        createColorView()
        createColorStackView()
        createStackViewWithColorButton()
    }
    
    // MARK: Выход и правила
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func rulesTapped() {
     let rulesVC = CurrentRulesViewController(game: viewModel.game)
        rulesVC.modalPresentationStyle = .formSheet
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
            maker.edges.equalTo(gameView).inset(5)
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
        
        guard chekPartGame == (true, true)  else {
            return
        }
        for index in colorMassiveButton {
            index.layer.borderColor = .none
            index.layer.borderWidth = 0
        }
            
            selectedColor = colorMass[sender.tag]
            
            let currentColor = cells[0][0].backgroundColor
            
            if currentColor != selectedColor {
                viewModel.countStep += 1
                fillCell(row: 0, col: 0, color: selectedColor, currentColor: currentColor!)
            }

        if checkResult() {
            stopwatch.invalidate()
   
            showAlertAboutFinishGame(title: "End game".localize(), message: "congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: seconds))")

            let resultGame = WhiteBoardModel(nameGame: "flood_fill", resultGame: "win", countStep: "\(viewModel.gameResult())", timerGame:  seconds)
            RealmManager.shared.saveResult(result: resultGame)
            CheckTaskManager.shared.checkPlayGame(game: 3)
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
            startNewGame()
        } else if chekPartGame == (true, true) {
            pauseGame()
            showAlertAboutFinishGame()
        } else {
            continueGame()
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
    
    func endGame() {
        self.dismiss(animated: true)
    }
    
    func startConditions() {
        levelButton.isEnabled = false
        isStartGame = true
        isContinuePlaying = true
    }
    
    func finishConditions() {
        levelButton.isEnabled = true
        isStartGame = false
        isContinuePlaying = false
    }
    
    func startNewGame() {
        let size = levelButton.titleLabel?.text ?? ""
        gridSize = Int(size)!
        createGamePlace(sizePlace: gridSize)
        seconds = 0
        createTimer()
        startConditions()
        playButton.setImage(Icons.pauseFill, for: .normal)
    }
    
    func continueGame() {
        gameView.isUserInteractionEnabled = true
        colorView.isUserInteractionEnabled = true
        createTimer()
        playButton.setImage(Icons.pauseFill, for: .normal)
        isContinuePlaying = true
    }
    
    func pauseGame() {
        colorView.isUserInteractionEnabled = false
        stopwatch.invalidate()
        playButton.setImage(Icons.playFill, for: .normal)
        navigationItem.title = "PAUSE"
        isContinuePlaying = false
    }
    
    func restartGame() {
        for view in contentViewStackView.arrangedSubviews {
            contentViewStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        pauseGame()
        resetElementsGame()
        finishConditions()
    }
    
    func resetElementsGame() {
        viewModel.countStep = 0
        timerLabel.text = "0"
        indexTag = 0
        contentViewStackView.removeFromSuperview()
        massLayer.removeAll()
        cells.removeAll()
    }
    
    func exitGame() {
        self.dismiss(animated: true)
    }
    
    @objc func selectMaxSizeTapped(_ sender: UIButton) {
        sender.setTitle(String(gameLevel.getLevel(currentLevel: Int(sender.titleLabel!.text!)!, step: 5, curentGame: CurentGame.floodFillGame)), for: .normal)
    }
}
