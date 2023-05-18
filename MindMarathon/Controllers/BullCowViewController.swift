//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class BullCowViewController: UIViewController, AlertDelegate {
    
    let countButton = UIButton()
    let userDiggitLabel = UILabel()
    let dashBoardTextView = UITextView()
    let timerLabel = UILabel()
    let deleteLastButton = UIButton()
    let sendDiggits = UIButton()
    
    private var stopwatch = Timer()
    private var seconds: Int = 0
    private var startGame: Bool = false
    private var continuePlaying: Bool = false
    private var game: BullCowViewModel!
    private var computerDiggit = [Int]()
    private var maxLenght: Int = 4
    private var countStep: Int = 0
    
    private var alertView: ResultAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        diggitsPudView.isUserInteractionEnabled = false
        game = BullCowViewModel()
        //        dashBoardTextView.isEditable = false
        //        dashBoardTextView.isSelectable = false
        //        userDiggitLabel.text = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        navigationItem.title = "Быки и Коровы"
        userDiggitLabel.text = ""
        userDiggitLabel.textAlignment = .center
        createUIElements()
    }
    
    func createUIElements() {
        let playButton = UIButton()
        let panelContollStackView = UIStackView()
        let panelInputContollStackView = UIStackView()
        let twiceInputLayerStackView = UIStackView()
        let firstLayerStackView = UIStackView()
        let secondLayerStackView = UIStackView()
        let panelControllView = UIView()
        let panelIntputControlView = UIView()
        let userLabelPanelStackView = UIStackView()
        
        //ButtonsDiggits
        let zeroTapped = UIButton()
        let oneTapped = UIButton()
        let twoTapped = UIButton()
        let threeTapped = UIButton()
        let fourTapped = UIButton()
        let fiveTapped = UIButton()
        let sixTapped = UIButton()
        let sevenTapped = UIButton()
        let eightTapped = UIButton()
        let nineTapped = UIButton()
        let sendDiggitsButton = UIButton()
        let massDiggit = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        let massButton = [oneTapped, twoTapped, threeTapped, fourTapped, fiveTapped, sixTapped, sevenTapped, eightTapped, nineTapped, zeroTapped]
        
        panelControllView.layer.cornerRadius = 10
        panelControllView.backgroundColor = .systemBackground
        view.addSubview(panelControllView)
        
        countButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        countButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        countButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
        countButton.setTitle("4", for: .normal)
        countButton.tintColor = UIColor.label
        countButton.backgroundColor = UIColor.tertiaryLabel
        countButton.layer.cornerRadius = 10
        countButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        view.addSubview(countButton)
        
        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(startGameButton), for: .touchUpInside)
        
        view.addSubview(countButton)
        
        timerLabel.text = "0"
        timerLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        panelContollStackView.addArrangedSubview(countButton)
        panelContollStackView.addArrangedSubview(playButton)
        panelContollStackView.addArrangedSubview(timerLabel)
        panelContollStackView.distribution = .equalCentering
        view.addSubview(panelContollStackView)
        
        dashBoardTextView.isEditable = false
        dashBoardTextView.isSelectable = false
        dashBoardTextView.backgroundColor = .systemBackground
        dashBoardTextView.layer.cornerRadius = 10
        dashBoardTextView.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        dashBoardTextView.textAlignment = .center
        dashBoardTextView.text = "Для начала игры выберите размер загаданного числа и нажмите СТАРТ \n"
        view.addSubview(dashBoardTextView)
        
        deleteLastButton.setBackgroundImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteLastButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        deleteLastButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        deleteLastButton.addTarget(self, action: #selector(deleteLastTapped), for: .touchUpInside)
        
        
        for (index, button) in massButton.enumerated() {
            button.tag = massDiggit[index] // присваиваем tag кнопке
            button.backgroundColor = .tertiaryLabel
            button.setTitle(String(massDiggit[index]), for: .normal) // присваиваем title кнопке
            button.setTitleColor(.label, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 45).isActive = true
            button.heightAnchor.constraint(equalToConstant: 45).isActive = true
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(diggitsTapped), for: .touchUpInside)
            
            if index > 4 {
                secondLayerStackView.addArrangedSubview(button)
            } else {
                firstLayerStackView.addArrangedSubview(button)
            }
        }
        userDiggitLabel.textAlignment = .right
        userDiggitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        
        userLabelPanelStackView.addArrangedSubview(userDiggitLabel)
        userLabelPanelStackView.addArrangedSubview(deleteLastButton)
        userLabelPanelStackView.distribution = .equalSpacing
        userLabelPanelStackView.axis = .horizontal
        
        
        firstLayerStackView.distribution = .equalCentering
        secondLayerStackView.distribution = .equalSpacing
        firstLayerStackView.spacing = 20
        firstLayerStackView.spacing = 20
        
        
        twiceInputLayerStackView.addArrangedSubview(firstLayerStackView)
        twiceInputLayerStackView.addArrangedSubview(secondLayerStackView)
        twiceInputLayerStackView.distribution = .equalCentering
        twiceInputLayerStackView.axis = .vertical
        twiceInputLayerStackView.spacing = 10
        
        panelInputContollStackView.addArrangedSubview(userLabelPanelStackView)
        panelInputContollStackView.addArrangedSubview(twiceInputLayerStackView)
        
        
        sendDiggitsButton.setTitle("ОТПРАВИТЬ", for: .normal)
        sendDiggitsButton.backgroundColor = .tertiaryLabel
        sendDiggitsButton.setTitleColor(.label, for: .normal)
        sendDiggitsButton.layer.cornerRadius = 10
        sendDiggitsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendDiggitsButton.addTarget(self, action: #selector(sendDiggitTapped), for: .touchUpInside)
        
        panelInputContollStackView.addArrangedSubview(sendDiggitsButton)
        
        panelInputContollStackView.axis = .vertical
        panelInputContollStackView.distribution = .equalCentering
        panelInputContollStackView.spacing = 20
        panelIntputControlView.addSubview(panelInputContollStackView)
        
        view.addSubview(panelIntputControlView)
        
        panelIntputControlView.layer.cornerRadius = 10
        panelIntputControlView.backgroundColor = .systemBackground
        view.addSubview(panelIntputControlView)
        
        panelControllView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelContollStackView.snp.makeConstraints { maker in
            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
        }
        
        dashBoardTextView.snp.makeConstraints { maker in
            maker.top.equalTo(panelControllView).inset(70)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        panelIntputControlView.snp.makeConstraints { maker in
            maker.height.equalTo(250)
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(20)
            maker.top.equalTo(dashBoardTextView.snp.bottom).offset(10) // Отступ между dashBoardTextView и panelInputControlView
        }
        
        
        panelInputContollStackView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalTo(panelIntputControlView).inset(10)
        }
        
    }
    
    @objc func selectMaxLenghtTapped(_ sender: UIButton) {
        sender.setTitle( game.selectMaxLenght(maxLenght: sender.titleLabel?.text ?? ""), for: .normal)
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
    
    @objc func diggitsTapped(_ sender: UIButton) {
        if startGame {
            if userDiggitLabel.text!.count < maxLenght {
                userDiggitLabel.text! += "\(sender.tag)"
            }
        }
    }
    
    
    @objc func deleteLastTapped(_ sender: UIButton) {
        if !userDiggitLabel.text!.isEmpty {
            userDiggitLabel.text = String(userDiggitLabel.text!.dropLast())
        }
    }
    
    func statGame() {
        seconds = 0
        createTimer()
        dashBoardTextView.text = ""
        maxLenght = Int((countButton.titleLabel?.text)!)!
        print(maxLenght)
        countButton.isEnabled = false
        computerDiggit = game.makeNumber(maxLenght: maxLenght)
    }
    
    func continueGame() {
        createTimer()
        makeResultText(partGame: "Игра возобновлена \n")
        
    }
    
    func pauseGame() {
        stopwatch.invalidate()
        makeResultText(partGame: "Игра приостановлена\n")
    }
    
    @objc func startGameButton(_ sender: UIButton) {
        
        let chekPartGame = (startGame, continuePlaying)
        
        if chekPartGame == (false, false) {
            startGame = true
            continuePlaying = true
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            statGame()
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
    
    func createAlertMessage(description: String) {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.6
            self.view.isUserInteractionEnabled = false
        }
        
        alertView = ResultAlertView.loadFromNib()
        alertView.delegate = self
        alertView.descriptionLabel.text = description
        UIApplication.shared.keyWindow?.addSubview(alertView)
        alertView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func sendDiggitTapped(_ sender: UIButton) {
        if startGame && userDiggitLabel.text?.count == maxLenght {
            countStep += 1
            let (bull, cow) = game.comparisonNumber( game.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
            makeResultText(result: (bull, cow), userMove: userDiggitLabel.text!)
            userDiggitLabel.text = ""
            
            if bull == maxLenght {
                stopwatch.invalidate()
                createAlertMessage(description: "Ура! Мы загадали число \(computerDiggit). Ваш результат \(countStep) попыток за \(TimeManager.shared.convertToMinutes(seconds: seconds)). Сыграем еще?")
            }
        }
        
    }
    
    @objc
    func rulesTapped() {
        
    }
    
    func restartGame() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        alertView.removeFromSuperview()
        statGame()
    }
    
    func exitGame() {
        
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.isUserInteractionEnabled = true
        }
        alertView.removeFromSuperview()
        self.dismiss(animated: true)
    }
    
    func makeResultText (partGame: String) {
        
        let resultString = NSMutableAttributedString(string: partGame)
        
        // Устанавливаем шрифт для атрибутов
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25)]
        resultString.addAttributes(attributes, range: NSRange(location: 0, length: resultString.length))
        
        // Создаем изменяемый NSMutableAttributedString на основе существующей атрибутированной строки
        let mutableAttributedString = NSMutableAttributedString(attributedString: dashBoardTextView.attributedText)
        // Добавляем новую атрибутированную строку к изменяемой атрибутированной строке
        mutableAttributedString.append(resultString)
        // Устанавливаем изменяемую атрибутированную строку в TextView
        dashBoardTextView.attributedText = mutableAttributedString
    }
    
    func makeResultText(result: (Int, Int), userMove: String) {
        // Создаем изображение быка и коровы
        let imageBull = UIImage(named: "bull")
        let imageCow = UIImage(named: "cow")
        
        let imageSize = CGSize(width: 25.0, height: 30.0)
        // Создаем рендерер изображения
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        // Рисуем изображение в новом размере
        let newImageBull = renderer.image { _ in
            imageBull?.draw(in: CGRect(origin: .zero, size: imageSize))
        }
        
        let newImageCow = renderer.image { _ in
            imageCow?.draw(in: CGRect(origin: .zero, size: imageSize))
        }
        
        // Создаем текстовый атрибут с изображением быка
        let bullAttachment = NSTextAttachment()
        bullAttachment.image = newImageBull
        let bullAttachmentString = NSAttributedString(attachment: bullAttachment)
        
        
        // Создаем текстовый атрибут с изображением коровы
        let cowAttachment = NSTextAttachment()
        cowAttachment.image = newImageCow
        let cowAttachmentString = NSAttributedString(attachment: cowAttachment)
        
        // Создаем атрибутированную строку с результатом
        let resultString = NSMutableAttributedString(string: "Ваш ход: \(userMove) | ")
        resultString.append(NSAttributedString(string: "\(result.0) "))
        resultString.append(bullAttachmentString)
        resultString.append(NSAttributedString(string: " - \(result.1) "))
        resultString.append(cowAttachmentString)
        resultString.append(NSAttributedString(string: "\n")) // добавляем символ перевода строки
        
        // Устанавливаем шрифт для атрибутов
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Thin", size: 25) ?? UIFont.systemFont(ofSize: 25)]
        resultString.addAttributes(attributes, range: NSRange(location: 0, length: resultString.length))
        
        // Создаем изменяемый NSMutableAttributedString на основе существующей атрибутированной строки
        let mutableAttributedString = NSMutableAttributedString(attributedString: dashBoardTextView.attributedText)
        // Добавляем новую атрибутированную строку к изменяемой атрибутированной строке
        mutableAttributedString.append(resultString)
        // Устанавливаем изменяемую атрибутированную строку в TextView
        dashBoardTextView.attributedText = mutableAttributedString
    }
    
}
