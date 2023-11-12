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
    
    private lazy var firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.text = "MIND"
        firstLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 80), weight: .bold)
        return firstLabel
    }()
    
    private lazy var secondLabel: UILabel = {
      let secondLabel = UILabel()
        secondLabel.text = "MARATHON"
        secondLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 36), weight: .bold)
        return secondLabel
    }()
    
    private lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fill
        labelStackView.spacing = 1
        return labelStackView
    }()
    
    private lazy var startMarathon: UIButton = {
        let startMarathon = UIButton()
        startMarathon.setTitle("Game list".localize(), for: .normal)
        startMarathon.setTitleColor(.white, for: .normal)
        startMarathon.titleLabel?.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        startMarathon.backgroundColor = UIColor(hex: 0x786BC0)
        startMarathon.addTarget(self, action: #selector(listGameTapped), for: .touchUpInside)
        startMarathon.layer.cornerRadius = 10
        startMarathon.addShadow()
        return startMarathon
    }()
    
    private lazy var whiteBoardButton: UIButton = {
        let whiteBoardButton = UIButton()
        whiteBoardButton.setTitle("Game stats".localize(), for: .normal)
        whiteBoardButton.setTitleColor(.label, for: .normal)
        whiteBoardButton.titleLabel?.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 18), weight: .bold)
        whiteBoardButton.titleLabel!.adjustsFontSizeToFitWidth = true
        whiteBoardButton.titleLabel!.minimumScaleFactor = 0.1
        whiteBoardButton.addTarget(self, action: #selector(whiteBoardTapped), for: .touchUpInside)
        whiteBoardButton.layer.borderColor = UIColor(hex: 0x786BC0).cgColor
        whiteBoardButton.layer.borderWidth = 2
        whiteBoardButton.backgroundColor = CustomColor.viewColor.color
        whiteBoardButton.layer.cornerRadius = 10

        return whiteBoardButton
    }()
    
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
        
        labelStackView.addArrangedSubview(firstLabel)
        labelStackView.addArrangedSubview(secondLabel)
   
        view.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            maker.centerX.equalToSuperview()
        }
    }
    
    func createStackButton() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 26
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(startMarathon)
        buttonStackView.addArrangedSubview(whiteBoardButton)
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.9)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        
    }

    func createBugButton() {
        let buttonHelpsForUser = UIButton()
        let image = UIImage(named: "letter")
        buttonHelpsForUser.setImage(image, for: .normal)
        buttonHelpsForUser.setTitleColor(.label, for: .normal)
        buttonHelpsForUser.layer.cornerRadius = 10
        buttonHelpsForUser.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        buttonHelpsForUser.titleLabel!.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        buttonHelpsForUser.titleLabel!.minimumScaleFactor = 0.1
        buttonHelpsForUser.addTarget(self, action: #selector(userHelpTapped), for: .touchUpInside)
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
              mailComposer.setToRecipients(["mind.marathon.help@gmail.com"])
              
              mailComposer.setSubject("Сообщение об ошибке")
              mailComposer.setMessageBody("Текст сообщения", isHTML: false)
              
              present(mailComposer, animated: true, completion: nil)
          } else {
              let alert = UIAlertController(title: "Ошибка", message: "Невозможно отправить письмо", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alert.addAction(okAction)
              present(alert, animated: true, completion: nil)
          }
      }
      
      func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          controller.dismiss(animated: true, completion: nil)

        }
    }
