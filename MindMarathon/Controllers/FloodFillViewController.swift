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
    private var index = 0
    private var currentColor = UIColor()
    private var selectedColor = UIColor()
    let playButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        self.view.backgroundColor = UIColor(named: "viewColor")
        createUI()
    }
    
    func createUI() {
        guard let firstColor = colorMass.first else {return}
        selectedColor = firstColor
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .clear
        view.addSubview(panelControllView)
        
        levelButton.addTarget(self, action: #selector(selectMaxSizeTapped), for: .touchUpInside)
        levelButton.setTitle("5", for: .normal)
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
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        panelControllStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        gameView.layer.cornerRadius = 10
        gameView.backgroundColor = UIColor(named: "gameElementColor")
        view.addSubview(gameView)
        
        gameView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        let colorStackView = UIStackView()
        
        colorView.backgroundColor = UIColor(named: "gameElementColor")
        colorView.layer.cornerRadius = 10
        view.addSubview(colorView)
        view.addSubview(colorStackView)
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fillEqually
        colorStackView.spacing = 10
        
        for i in 0..<colorMass.count {
            let colorButton = UIButton()
            colorButton.backgroundColor = UIColor(cgColor: colorMass[i].cgColor)
            colorButton.layer.cornerRadius = 10
            colorButton.tag = i
            
            if i == 0 {
                colorButton.layer.borderColor = UIColor.label.cgColor
                colorButton.layer.borderWidth = 2
            }
            colorButton.addTarget(self, action: #selector(selectedColorTapped), for: .touchUpInside)
            view.addSubview(colorButton)
            colorStackView.addArrangedSubview(colorButton)
            colorMassiveButton.append(colorButton)
        }
        
        colorView.snp.makeConstraints { maker in
            maker.top.equalTo(gameView.snp.bottom).inset(-10)
            maker.bottom.equalToSuperview().inset(30)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
        }
        
        colorStackView.snp.makeConstraints { maker in
            maker.left.right.bottom.top.equalTo(colorView).inset(10)
        }
    }
    //MARK: Выход и правила
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
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let chekPartGame = (isStartGame, isContinuePlaying)
        if chekPartGame == (true, true) {
            guard let selectedCell = recognizer.view else {
                return
            }
            // Получаем текущий цвет ячейки
            let currentColor = selectedCell.backgroundColor ?? UIColor.clear
            
            // Вызываем функцию fillCell для закрашивания ячеек
            fillCell(row: selectedCell.tag / gridSize, col: selectedCell.tag % gridSize, color: selectedColor, currentColor: currentColor)
            
            if currentColor != selectedColor {
                FloodFillViewModel.shared.countStep += 1
            }
            // Проверяем, достигнута ли цель
            if checkResult() {
                stopwatch.invalidate()
                createAlertMessage(description: "Поздравляем. Вы полностью закрасили поле за \(TimeManager.shared.convertToMinutes(seconds: seconds)) и \(FloodFillViewModel.shared.countStep) ходов.")
                let resultGame = WhiteBoardModel(nameGame: "Заливка", resultGame: "Победа", countStep: "\(FloodFillViewModel.shared.countStep)", timerGame: "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
                RealmManager.shared.saveResult(result: resultGame)
            }
        }
    }
    
    //MARK: создание поля с игрой
    func createGamePlace(sizePlace: Int) {
        index = 0
        var row = [UIView]() // Инициализируем переменную row
        
        for _ in 0..<gridSize {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            massLayer.append(stackView)
        }
        
        for i in 0..<gridSize {
            for _ in 0..<gridSize {
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                let cell = UIView()
                cell.tag = index
                index += 1
                cell.addGestureRecognizer(tapRecognizer)
                cell.backgroundColor = UIColor.tertiaryLabel
                cell.layer.borderColor = UIColor.black.cgColor
                massLayer[i].addArrangedSubview(cell)
                row.append(cell)
            }
            view.addSubview(massLayer[i])
            contentViewStackView.addArrangedSubview(massLayer[i])
            cells.append(row)
            row.removeAll()
        }
        
        view.addSubview(contentViewStackView)
        contentViewStackView.axis = .vertical
        contentViewStackView.distribution = .fillEqually
        contentViewStackView.spacing = 0
        
        contentViewStackView.snp.makeConstraints { maker in
            maker.left.equalTo(gameView).inset(10)
            maker.top.equalTo(gameView).inset(10)
            maker.right.equalTo(gameView).inset(10)
            maker.bottom.equalTo(gameView).inset(10)
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
            for i in colorMassiveButton {
                i.layer.borderColor = .none
                i.layer.borderWidth = 0
            }
            
            selectedColor = colorMass[sender.tag]
            sender.layer.borderColor = UIColor.label.cgColor
            sender.layer.borderWidth = 2
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
        index = 0
        timerLabel.text = "0"
        levelButton.isEnabled = true
        isContinuePlaying = false
        isStartGame = false
        FloodFillViewModel.shared.countStep = 0
        alertView.removeFromSuperview()
    }
    
    func exitGame() {
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func selectMaxSizeTapped(_ sender: UIButton) {
        sender.setTitle( FloodFillViewModel.shared.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""), for: .normal)
    }
}
