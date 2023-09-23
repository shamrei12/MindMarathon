//
//  KeyboardView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 16.09.23.
//

import UIKit
import SnapKit

class KeyboardView: UIView {
    weak var delegate: KeyboardDelegate?
    var massiveKeyboardButtons = [UIButton]()
    
    private func keyboardViewCreated() -> UIView {
        let keyBoardView = UIView()
        
        self.addSubview(keyBoardView)
        
        keyBoardView.snp.makeConstraints { maker in
            maker.top.equalTo(self.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalToSuperview()
        }
        
        return keyBoardView
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
    
    private func sendButtonCreated() -> UIButton {
        let sendWordsButton = UIButton()
        sendWordsButton.setTitle("ПРОВЕРИТЬ СЛОВО".localize(), for: .normal)
        sendWordsButton.setTitleColor(UIColor.label, for: .normal)
        sendWordsButton.layer.cornerRadius = 10
        sendWordsButton.backgroundColor = UIColor.systemBackground
        sendWordsButton.addShadow()
        sendWordsButton.addTarget(self, action: #selector(sendWordsTapped), for: .touchUpInside)
        
        self.addSubview(sendWordsButton)
        
        sendWordsButton.snp.makeConstraints { maker in
            maker.height.equalToSuperview().multipliedBy(1)
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
                massiveKeyboardButtons.append(keyboarButton)
            }
            keyboardRowStackView.addArrangedSubview(keyboarButton)
        }
        return keyboardRowStackView
    }
    
    func clearColorButtons() {
        for button in massiveKeyboardButtons {
            button.backgroundColor = .systemBackground
        }
    }
    
    @objc func letterinputTapped(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else { return }
        delegate?.keyPressed(key)

    }
    
    @objc func deleteLastWord() {
        delegate?.deletePressed()
    }
    
    @objc func sendWordsTapped() {
        delegate?.sendWordsTapped()
    }
}
