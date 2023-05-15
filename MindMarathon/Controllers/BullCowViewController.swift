//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit

class BullCowViewController: UIViewController, AlertDelegate {
    
    @IBOutlet weak var maxLenghtButton: UIButton!
    @IBOutlet weak var userDiggitLabel: UILabel!
    @IBOutlet weak var dashBoardTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var diggitsPudView: UIView!
    
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
        diggitsPudView.isUserInteractionEnabled = false
        game = BullCowViewModel()
        dashBoardTextView.isEditable = false
        dashBoardTextView.isSelectable = false
        dashBoardTextView.text = "Для начала игры выберите размер загаданного числа и нажмите СТАРТ \n"
        userDiggitLabel.text = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        navigationItem.title = "Быки и Коровы"
    }
    
    @IBAction func selectMaxLenghtTapped(_ sender: UIButton) {
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
    
    @IBAction func diggitsTapped(_ sender: UIButton) {
        if startGame {
            if (userDiggitLabel.text?.count)! < maxLenght {
                userDiggitLabel.text! += "\(sender.tag)"
            }
        }
    }
    
    @IBAction func deleteLastTapped(_ sender: UIButton) {
        if !userDiggitLabel.text!.isEmpty {
            userDiggitLabel.text = String(userDiggitLabel.text!.dropLast())
        }
    }
    
    
    func statGame() {
            seconds = 0
            createTimer()
            diggitsPudView.isUserInteractionEnabled = true
            dashBoardTextView.text = ""
            maxLenght = Int((maxLenghtButton.titleLabel?.text)!)!
            maxLenghtButton.isEnabled = false
            computerDiggit = game.makeNumber(maxLenght: maxLenght)
    }
    
    func continueGame() {
        createTimer()
        diggitsPudView.isUserInteractionEnabled = true
        makeResultText(partGame: "Игра возобновлена \n")
        
    }
    
    func pauseGame() {
        stopwatch.invalidate()
        diggitsPudView.isUserInteractionEnabled = false
        makeResultText(partGame: "Игра приостановлена\n")
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        
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
    
    @IBAction func sendDiggitTapped(_ sender: UIButton) {
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
