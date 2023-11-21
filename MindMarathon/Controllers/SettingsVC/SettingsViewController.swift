//
//  FeedbackViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 13.11.23.
//

import UIKit
import SnapKit
import MessageUI

final class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Настройки"
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        return mainLabel
    }()
    
    private lazy var themeLabel: UILabel = {
        let themeLabel = UILabel()
        themeLabel.text = "Тема приложения"
        themeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 15), weight: .regular)
        themeLabel.textColor = .label
        return themeLabel
    }()
    
    private lazy var themeButtonStack: UIStackView = {
        let themeButtonStack = UIStackView()
        themeButtonStack.axis = .horizontal
        themeButtonStack.distribution = .fillEqually
        themeButtonStack.spacing = 50
        return themeButtonStack
    }()
    
    private lazy var automaticSwitchThemeView: UIView = {
       let automaticSwitchThemeView = UIView()
        automaticSwitchThemeView.backgroundColor = .clear
        return automaticSwitchThemeView
    }()
    
    private lazy var automaticSwitchTheme: UISwitch = {
        let automaticSwitchTheme = UISwitch()
        automaticSwitchTheme.onTintColor = .purple
        automaticSwitchTheme.isOn = false
        automaticSwitchTheme.addTarget(self, action: #selector(switchTheme), for: .touchUpInside)
        return automaticSwitchTheme
    }()
    
    private lazy var automaticSwitchThemeLabel: UILabel = {
        let automaticSwitchThemeLabel = UILabel()
        automaticSwitchThemeLabel.text = "Автоматическая тема"
        automaticSwitchThemeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 15), weight: .bold)
        return automaticSwitchThemeLabel
    }()
    
    private lazy var descriptionAutomaticSwitchThemeLabel: UILabel = {
        let descriptionAutomaticSwitchThemeLabel = UILabel()
        descriptionAutomaticSwitchThemeLabel.text = "Из настроек системы"
        descriptionAutomaticSwitchThemeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 13), weight: .light)
        return descriptionAutomaticSwitchThemeLabel
    }()
    
    private lazy var lightThemeView: UIView = {
        let lightThemeView = UIView()
        return lightThemeView
    }()
    
    private lazy var darkThemeView: UIView = {
        let darkThemeView = UIView()
        return darkThemeView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        createStackView()
        setupUI()
        makeConstaints()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        self.view.addSubview(mainLabel)
        self.view.addSubview(themeLabel)
        self.view.addSubview(themeButtonStack)
        self.view.addSubview(automaticSwitchThemeView)
        automaticSwitchThemeView.addSubview(automaticSwitchTheme)
        automaticSwitchThemeView.addSubview(automaticSwitchThemeLabel)
        automaticSwitchThemeView.addSubview(descriptionAutomaticSwitchThemeLabel)
    }
    
    func makeConstaints() {
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        themeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-15)
            maker.left.equalTo(self.view.safeAreaLayoutGuide).inset(25)
        }
        
        themeButtonStack.snp.makeConstraints { maker in
            maker.top.equalTo(themeLabel.snp.bottom).inset(-10)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.8)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.15)
        }
        
        automaticSwitchThemeView.snp.makeConstraints { maker in
            maker.top.equalTo(themeButtonStack.snp.bottom).inset(-20)
            maker.left.right.equalToSuperview()
        }
        
        automaticSwitchThemeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(automaticSwitchThemeView).inset(5)
            maker.left.equalTo(self.view.safeAreaLayoutGuide ).inset(25)
        }
        
        descriptionAutomaticSwitchThemeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(automaticSwitchThemeLabel.snp.bottom).inset(-4)
            maker.left.equalTo(self.view.safeAreaLayoutGuide ).inset(25)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        automaticSwitchTheme.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().inset(20)
        }
        
    }
    
    func createStackView() {
        themeButtonStack.addArrangedSubview(createThemeButton(text: "Светлая", image: UIImage(named: "telegram"), tag: 0))
        themeButtonStack.addArrangedSubview(createThemeButton(text: "Темная", image: UIImage(named: "telegram"), tag: 1))
    }
    
    func createThemeButton(text: String, image: UIImage?, tag: Int) -> UIView {
        var customView = UIView()
        
        if tag == 0 {
            customView = lightThemeView
        } else {
            customView = darkThemeView
        }
        
        customView.tag = tag
        customView.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTheme))
        customView.addGestureRecognizer(tapGesture)
        customView.isUserInteractionEnabled = true
        
        let label = UILabel()
        label.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 12), weight: .bold)
        label.text = text
        label.textAlignment = .center
        customView.addSubview(label)
        
        if tag == 0 {
            customView.backgroundColor = UIColor(hex: 0xffffff)
            label.textColor = .black
        } else {
            customView.backgroundColor = UIColor(hex: 0x313131)
            label.textColor = .white
        }
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        customView.addSubview(imageView)
        

        
        imageView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview().inset(5)
            maker.height.equalTo(customView.snp.height).multipliedBy(0.7)
        }
        
        label.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom)
            maker.left.bottom.right.equalToSuperview()
        }
        
        return customView
    }
    
    @objc func changeTheme(sender: UIGestureRecognizer) {
        if let view = sender.view {
            view.layer.borderColor = UIColor.purple.cgColor
            view.layer.borderWidth = 2
            
            if view.tag == 0 {
                if #available(iOS 13.0, *) {
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                        darkThemeView.layer.borderColor = UIColor.clear.cgColor
                        darkThemeView.layer.borderWidth = 0
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            } else {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    lightThemeView.layer.borderColor =  UIColor.clear.cgColor
                    lightThemeView.layer.borderWidth = 0
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
    @objc func switchTheme(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
            if sender.isOn {
                // Использовать тему в зависимости от системы
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    lightThemeView.layer.borderColor =  UIColor.clear.cgColor
                    lightThemeView.layer.borderWidth = 0
                    darkThemeView.layer.borderColor = UIColor.clear.cgColor
                    darkThemeView.layer.borderWidth = 0
                    
                    window.overrideUserInterfaceStyle = .unspecified
                }
            } else {
                // Использовать текущую тему
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    if window.traitCollection.userInterfaceStyle == .dark {
                        darkThemeView.layer.borderColor = UIColor.purple.cgColor
                        darkThemeView.layer.borderWidth = 2
                        window.overrideUserInterfaceStyle = .dark
                    } else {
                        lightThemeView.layer.borderColor = UIColor.purple.cgColor
                        lightThemeView.layer.borderWidth = 2
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
    }
      
    
    //
    //    @objc
    //    func userHelpTapped() {
    //        if MFMailComposeViewController.canSendMail() {
    //              let mailComposer = MFMailComposeViewController()
    //              mailComposer.mailComposeDelegate = self
    //              mailComposer.setToRecipients(["mind.marathon.help@gmail.com"])
    //
    //              mailComposer.setSubject("Сообщение об ошибке")
    //              mailComposer.setMessageBody("Текст сообщения", isHTML: false)
    //
    //              present(mailComposer, animated: true, completion: nil)
    //          } else {
    //              let alert = UIAlertController(title: "Ошибка", message: "Невозможно отправить письмо", preferredStyle: .alert)
    //              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //              alert.addAction(okAction)
    //              present(alert, animated: true, completion: nil)
    //          }
    //      }
    
}
