//
//  BullCowViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit

class BullCowViewController: UIViewController {
    
    @IBOutlet weak var maxLenghtButton: UIButton!
    @IBOutlet weak var userDiggitLabel: UILabel!
    @IBOutlet weak var dashBoardTextView: UITextView!
    
    private var startGame: Bool = false
    private var game: BullCowViewModel!
    private var computerDiggit = [Int]()
    private var maxLenght: Int = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        game = BullCowViewModel()
        dashBoardTextView.isEditable = false
        dashBoardTextView.isSelectable = false
        dashBoardTextView.text = "Для начала игры выберите размер загаданного числа и нажмите СТАРТ \n"
        userDiggitLabel.text = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Правила", style: .plain, target: self, action: #selector(rulesTapped))
        navigationItem.title = "Быки и Коровы"
    }
    
    @IBAction func diggitsTapped(_ sender: UIButton) {
        if startGame {
            if (userDiggitLabel.text?.count)! <= maxLenght {
                userDiggitLabel.text! += "\(sender.tag)"
            }
        }
    }
    
    @IBAction func deleteLastTapped(_ sender: UIButton) {
        if !userDiggitLabel.text!.isEmpty {
            userDiggitLabel.text = String(userDiggitLabel.text!.dropLast())
        }
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        startGame = true
        dashBoardTextView.text = ""
        maxLenght = Int((maxLenghtButton.titleLabel?.text)!)!
        maxLenghtButton.isEnabled = false
        computerDiggit = game.makeNumber(maxLenght: maxLenght)
    }
    
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendDiggitTapped(_ sender: UIButton) {
        if startGame && userDiggitLabel.text?.count == maxLenght {
            let (bull, cow) = game.comparisonNumber( game.createMassive(userDiggit: userDiggitLabel.text!), computerDiggit)
            makeResultText(result: (bull, cow), userMove: userDiggitLabel.text!)
            userDiggitLabel.text = ""
        }
        
    }
    @objc
    func rulesTapped() {
        
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
