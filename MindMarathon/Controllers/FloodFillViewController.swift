//
//  FloodFillViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.05.23.
//

import UIKit

class FloodFillViewController: UIViewController, AlertDelegate {
    var gridButton = UIButton()
    let timerLabel = UILabel()
    let gameView = UIView()
    let colorView = UIView()
    
    let contentViewStackView = UIStackView()
    var massLayer = [UIStackView]()
    private var gridSize = 5
    private let cellSize: CGFloat = 40 // Размер ячейки
    private var stopwatch = Timer()
    private var seconds = 0
    private var alertView: ResultAlertView!
    private var messegeView: UserMistakeView!
    private var cells = [[UIView]]()
    private var row = [UIView]()
    private var startGame: Bool = false
    private var continuePlaying: Bool = false
    private var colorMassiveButton = [UIButton]()
    var colorMass = [UIColor.blue, UIColor.cyan, UIColor.green]
    private var index = 0
    private var currentColor = UIColor()
    private var selectedColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        createUI()
    }
    
    func createUI() {
        selectedColor = .systemBlue
        let playButton = UIButton()
        let panelControllView = UIView()
        let panelControllStackView = UIStackView()
        
        playButton.addTarget(self, action: #selector(startGameButton), for: .touchUpInside)
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .systemBackground
        view.addSubview(panelControllView)
        
        gridButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        gridButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gridButton.setTitle("5", for: .normal)
        gridButton.tintColor = UIColor.label
        gridButton.backgroundColor = UIColor.tertiaryLabel
        gridButton.layer.cornerRadius = 10
        gridButton.addTarget(self, action: #selector(selectMaxSizeTapped), for: .touchUpInside)
        view.addSubview(gridButton)
        
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.addSubview(playButton)
        
        timerLabel.text = "0"
        timerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        panelControllStackView.addArrangedSubview(gridButton)
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
        
        gameView.layer.cornerRadius = 10
        gameView.backgroundColor = .systemBackground
        view.addSubview(gameView)
        
        gameView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        let colorStackView = UIStackView()
        
        colorView.backgroundColor = .systemBackground
        view.addSubview(colorView)
        view.addSubview(colorStackView)
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fillEqually
        colorStackView.spacing = 50
        
        for i in 0..<colorMass.count {
            let colorButton = UIButton()
            colorButton.backgroundColor = UIColor(cgColor: colorMass[i].cgColor)
            colorButton.layer.cornerRadius = 10
            colorButton.tag = i
            if i == 0 {
                colorButton.layer.borderColor = UIColor.black.cgColor
                colorButton.layer.borderWidth = 3
            }
            colorButton.addTarget(self, action: #selector(selectedColorTapped), for: .touchUpInside)
            view.addSubview(colorButton)
            colorStackView.addArrangedSubview(colorButton)
            colorMassiveButton.append(colorButton)
        }
        
        colorView.snp.makeConstraints { maker in
            maker.top.equalTo(gameView.snp.bottom).inset(-10)
            maker.left.right.bottom.equalToSuperview().inset(10)
            maker.height.equalTo(100)
            
        }
        
        colorStackView.snp.makeConstraints { maker in
            maker.left.right.bottom.top.equalTo(colorView).inset(10)
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
        rulesVC.rulesGame(numberGame: 3)
        present(rulesVC, animated: true)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let chekPartGame = (startGame, continuePlaying)
        if chekPartGame == (true, true) {
            guard let selectedCell = recognizer.view else {
                return
            }
            // Получаем текущий цвет ячейки
            let currentColor = selectedCell.backgroundColor ?? UIColor.clear
            
            // Вызываем функцию fillCell для закрашивания ячеек
            fillCell(row: selectedCell.tag / gridSize, col: selectedCell.tag % gridSize, color: selectedColor, currentColor: currentColor)
            FloodFillViewModel.shared.countStep += 1
            // Проверяем, достигнута ли цель
            if checkResult() {
                stopwatch.invalidate()
                createAlertMessage(description: "Поздравляем. Вы полностью закрасили поле за \(TimeManager.shared.convertToMinutes(seconds: seconds)) и \(FloodFillViewModel.shared.countStep) ходов.")
            }
        }
    }
    
    func createGamePlace(sizePlace: Int) {
        
        for i in 0..<gridSize {
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
        
        coloringView()
    }
    
    func coloringView() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let color = colorMass[Int.random(in: 0...2)]
                cells[i][j].backgroundColor = UIColor(cgColor: color.cgColor)
            }
        }
    }
    
    @objc func selectedColorTapped(sender: UIButton) {
        let chekPartGame = (startGame, continuePlaying)
        if chekPartGame == (true, true) {
            for i in colorMassiveButton {
                i.layer.borderColor = .none
                i.layer.borderWidth = 0
            }
            if sender.tag == 0 {
                selectedColor = colorMass[0]
            } else if sender.tag == 1 {
                selectedColor = colorMass[1]
            } else if sender.tag == 2 {
                selectedColor = colorMass[2]
            }
            sender.layer.borderColor = UIColor.black.cgColor
            sender.layer.borderWidth = 3
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
        timerLabel.text = TimeManager.shared.convertToMinutes(seconds: seconds)
    }
    
    @objc func startGameButton(_ sender: UIButton) {
        
        let chekPartGame = (startGame, continuePlaying)
        
        if chekPartGame == (false, false) {
            startGame = true
            continuePlaying = true
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startNewGame()
        } else if chekPartGame == (true, true) {
            continuePlaying = false
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pauseGame()
        } else {
            continuePlaying = true
            continueGame()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    func startNewGame() {
        let size = gridButton.titleLabel?.text ?? ""
        gridSize = Int(size) ?? 5
        createGamePlace(sizePlace: gridSize)
        gameView.isUserInteractionEnabled = false
        colorView.isUserInteractionEnabled = false
        seconds = 0
        createTimer()
    }
    
    func continueGame() {
        gameView.isUserInteractionEnabled = true
        colorView.isUserInteractionEnabled = true
        createTimer()
    }
    
    func pauseGame() {
        gameView.isUserInteractionEnabled = false
        colorView.isUserInteractionEnabled = false
        stopwatch.invalidate()
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
        alertView.removeFromSuperview()
        FloodFillViewModel.shared.countStep = 0
        coloringView()
        seconds = 0
        createTimer()
    }
    
    func exitGame() {
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    @objc func selectMaxSizeTapped(_ sender: UIButton) {
        sender.setTitle( FloodFillViewModel.shared.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""), for: .normal)
    }
}
