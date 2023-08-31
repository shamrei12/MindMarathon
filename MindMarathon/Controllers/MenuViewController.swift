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
        creatingUI()
    }
    
    func creatingUI() {
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
        
        let startMarathon = UIButton()
        startMarathon.setTitle("Список игр".localized(), for: .normal)
        startMarathon.setTitleColor(.label, for: .normal)
        startMarathon.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        startMarathon.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        startMarathon.titleLabel!.minimumScaleFactor = 0.1
        startMarathon.backgroundColor = UIColor(named: "gameElementColor")
        
        startMarathon.layer.cornerRadius = 10
        startMarathon.addTarget(self, action: #selector(listGameTapped), for: .touchUpInside)
        startMarathon.layer.shadowColor = UIColor.label.cgColor
        startMarathon.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        startMarathon.layer.shadowOpacity = 0.2
        startMarathon.layer.shadowRadius = 3
        view.addSubview(startMarathon)
        
        let whiteBoard = UIButton()
        whiteBoard.setTitle("Статистика игр", for: .normal)
        whiteBoard.setTitleColor(.label, for: .normal)
        whiteBoard.backgroundColor = UIColor(named: "gameElementColor")
        whiteBoard.layer.cornerRadius = 10
        whiteBoard.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        whiteBoard.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        whiteBoard.titleLabel!.minimumScaleFactor = 0.1
        whiteBoard.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        whiteBoard.layer.shadowColor = UIColor.label.cgColor
        whiteBoard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        whiteBoard.layer.shadowOpacity = 0.2
        whiteBoard.layer.shadowRadius = 3
        view.addSubview(whiteBoard)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(startMarathon)
        buttonStackView.addArrangedSubview(whiteBoard)
        view.addSubview(buttonStackView)
        
        let buttonHelpsForUser = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "envelope")?.withConfiguration(symbolConfiguration)
        buttonHelpsForUser.setImage(image, for: .normal)

//        buttonHelpsForUser.setImage(UIImage(systemName: "envelope"), for: .normal)
        buttonHelpsForUser.setTitleColor(.label, for: .normal)
        buttonHelpsForUser.backgroundColor = UIColor(named: "gameElementColor")
        buttonHelpsForUser.layer.cornerRadius = 10
        buttonHelpsForUser.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        buttonHelpsForUser.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        buttonHelpsForUser.titleLabel!.minimumScaleFactor = 0.1
        buttonHelpsForUser.addTarget(self, action: #selector(userHelpTapped), for: .touchUpInside)
        buttonHelpsForUser.layer.shadowColor = UIColor.label.cgColor
        buttonHelpsForUser.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        buttonHelpsForUser.layer.shadowOpacity = 0.2
        buttonHelpsForUser.layer.shadowRadius = 3
        view.addSubview(buttonHelpsForUser)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            maker.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.90)
            maker.height.equalToSuperview().multipliedBy(0.20)
        }
        
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
