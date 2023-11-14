//
//  FeedbackViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 13.11.23.
//

import UIKit
import SnapKit
import MessageUI

class FeedbackViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private lazy var feedbackButtons: UIStackView = {
        let feedbackButtons = UIStackView()
        feedbackButtons.axis = .vertical
        feedbackButtons.distribution = .fillEqually
        feedbackButtons.spacing = 15
//        feedbackButtons.alignment = .center
        return feedbackButtons
    }()
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Found a bug in the game? Contact us."
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 28), weight: .bold)
        mainLabel.numberOfLines = 0
        return mainLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFeedbackButtons()
        makeConstraints()
    }

    func setupUI() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(mainLabel)
        self.view.addSubview(feedbackButtons)
    }
    
    func setupFeedbackButtons() {
        feedbackButtons.addArrangedSubview(createButton(idButton: 1))
        feedbackButtons.addArrangedSubview(createButton(idButton: 2))
        feedbackButtons.addArrangedSubview(createButton(idButton: 3))
    }
    
    func createButton(idButton: Int) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 16), weight: .semiBold)
        button.titleLabel?.textColor = UIColor(hex: 0xffffff)
        button.addShadow()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        switch idButton {
        case 1:
            button.addTarget(self, action: #selector(userHelpTapped), for: .touchUpInside)
            button.setTitle("Contact by mail", for: .normal)
            let image = UIImage(named: "gmail")
            button.setImage(image, for: .normal)
            button.backgroundColor = .systemGreen
        case 2:
            button.setTitle("Write in Telegram", for: .normal)
            button.backgroundColor = UIColor(hex: 0x2AABEA, alpha: 1)
            let image = UIImage(named: "telegram")
            button.setImage(image, for: .normal)
        case 3:
            button.setTitle("Write on Facebook", for: .normal)
            button.backgroundColor = UIColor(hex: 0x0866FF, alpha: 1)
            let image = UIImage(named: "facebook")
            button.setImage(image, for: .normal)
        default:
            button.setTitle("", for: .normal)
            button.backgroundColor = .clear
        }
        
        button.snp.makeConstraints { maker in
            let safeAreaheight = self.view.safeAreaLayoutGuide.layoutFrame.height
            maker.height.equalTo(safeAreaheight * 0.08)
        }
        
        button.layer.cornerRadius = 20
        
        return button
    }
    
    func makeConstraints() {
        
        mainLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        feedbackButtons.snp.makeConstraints { maker in
            let safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.width
            maker.left.equalTo(self.view.safeAreaLayoutGuide).offset(safeAreaWidth * 0.1)
            maker.right.equalTo(self.view.safeAreaLayoutGuide).offset(-safeAreaWidth * 0.1)
            maker.centerX.centerY.equalToSuperview()
        }
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

}
