//
//  MenuViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.viewColor.color
        setupUI()
    }
    
    func setupUI() {
        createLabelName()
        createStackButton()
        createBugButton()
    }
    
    
    func createLabelName() {
        let labelStackView = UIStackView()
        let firstLabel = UILabel()
        let secondLabel = UILabel()
        
        firstLabel.text = "MIND"
        firstLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 95.0)
        
        secondLabel.text = "MARATHON"
        secondLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 43.0)
        
        labelStackView.addArrangedSubview(firstLabel)
        labelStackView.addArrangedSubview(secondLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fill
        labelStackView.spacing = 2
        
        view.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            maker.centerX.equalToSuperview()
        }
    }
    
    func createStackButton() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(createStartButton())
        buttonStackView.addArrangedSubview(createWhiteBoardButton())
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.9)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        
    }
    
    func createStartButton() -> UIButton {
        let startMarathon = UIButton()
        startMarathon.setTitle("Список игр", for: .normal)
        startMarathon.setTitleColor(.label, for: .normal)
        startMarathon.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        startMarathon.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        startMarathon.titleLabel!.minimumScaleFactor = 0.1
        startMarathon.backgroundColor = UIColor(named: "gameElementColor")
        startMarathon.addTarget(self, action: #selector(listGameTapped), for: .touchUpInside)
        startMarathon.layer.cornerRadius = 10
        startMarathon.addShadow()
        
        return startMarathon
    }
    
    func createWhiteBoardButton() -> UIButton {
        let whiteBoardButton = UIButton()
        whiteBoardButton.setTitle("Статистика игр", for: .normal)
        whiteBoardButton.setTitleColor(.label, for: .normal)
        whiteBoardButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        whiteBoardButton.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        whiteBoardButton.titleLabel!.minimumScaleFactor = 0.1
        whiteBoardButton.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        whiteBoardButton.addShadow()
        whiteBoardButton.backgroundColor = UIColor(named: "gameElementColor")
        whiteBoardButton.layer.cornerRadius = 10

        return whiteBoardButton
    }
    
    func createBugButton() {
        let buttonHelpsForUser = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "envelope")?.withConfiguration(symbolConfiguration)
        buttonHelpsForUser.setImage(image, for: .normal)


        buttonHelpsForUser.setTitleColor(.label, for: .normal)
        buttonHelpsForUser.backgroundColor = UIColor(named: "gameElementColor")
        buttonHelpsForUser.layer.cornerRadius = 10
        buttonHelpsForUser.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        buttonHelpsForUser.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        buttonHelpsForUser.titleLabel!.minimumScaleFactor = 0.1
        buttonHelpsForUser.addTarget(self, action: #selector(userHelpTapped), for: .touchUpInside)
        buttonHelpsForUser.addShadow()
        buttonHelpsForUser.tintColor = UIColor.label
        view.addSubview(buttonHelpsForUser)
        
        buttonHelpsForUser.snp.makeConstraints { maker in
            maker.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.09)
            maker.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
    }
    
    @objc
    func listGameTapped() {
        let listGame = ListGamesViewController()
        let navigationController = UINavigationController(rootViewController: listGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func whiteBoardTapped() {
        let whiteBoard = WhiteboardViewController()
        let navigationController = UINavigationController(rootViewController: whiteBoard)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    func userHelpTapped() {
        if MFMailComposeViewController.canSendMail() {
              let mailComposer = MFMailComposeViewController()
              mailComposer.mailComposeDelegate = self
              mailComposer.setToRecipients(["mind.marathon.help@gmail.com"]) // адрес получателя
              
              // Заполнение данных письма
              mailComposer.setSubject("Сообщение об ошибке")
              mailComposer.setMessageBody("Текст сообщения", isHTML: false)
              
              present(mailComposer, animated: true, completion: nil)
          } else {
              // Обработка случая, когда почтовое приложение недоступно
              let alert = UIAlertController(title: "Ошибка", message: "Невозможно отправить письмо", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alert.addAction(okAction)
              present(alert, animated: true, completion: nil)
          }
      }
      
      // Метод делегата MFMailComposeViewControllerDelegate, вызывается после отправки или отмены письма
      func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          controller.dismiss(animated: true, completion: nil)

        }
    }
