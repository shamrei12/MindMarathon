//
//  FeedbackViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 13.11.23.
//

import UIKit
import SnapKit
import MessageUI
import StoreKit
import SwiftUI

final class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "settingLabel".localized()
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        return mainLabel
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var themeView: UIView = {
        let themeView = UIView()
        themeView.layer.cornerRadius = 12
        themeView.backgroundColor = UIColor(named: "gameElementColor")
        return themeView
    }()
    
    private lazy var themeLabel: UILabel = {
        let themeLabel = UILabel()
        themeLabel.text = "themeLabel".localized()
        themeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 15), weight: .semiBold)
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
    
    private lazy var lightThemeView: UIView = {
        let lightThemeView = UIView()
        lightThemeView.backgroundColor = UIColor.clear
        return lightThemeView
    }()
    
    private lazy var darkThemeView: UIView = {
        let darkThemeView = UIView()
        darkThemeView.backgroundColor = UIColor.clear
        return darkThemeView
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
        automaticSwitchThemeLabel.text = "autoLabel".localized()
        automaticSwitchThemeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 15), weight: .bold)
        return automaticSwitchThemeLabel
    }()
    
    private lazy var descriptionAutomaticSwitchThemeLabel: UILabel = {
        let descriptionAutomaticSwitchThemeLabel = UILabel()
        descriptionAutomaticSwitchThemeLabel.text = "descriptionAutoLabel".localized()
        descriptionAutomaticSwitchThemeLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 13), weight: .light)
        return descriptionAutomaticSwitchThemeLabel
    }()
    
    private lazy var languagesView: UIView = {
        let languagesView = UIView()
        languagesView.layer.cornerRadius = 12
        languagesView.backgroundColor = UIColor(named: "gameElementColor")
        return languagesView
        
    }()
    
    private lazy var languagesLabel: UILabel = {
        let languagesLabel = UILabel()
        languagesLabel.text = "appLang".localized()
        languagesLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 15), weight: .semiBold)
        languagesLabel.textColor = .label
        return languagesLabel
    }()
    
    private lazy var engLanguageButton: UIButton = {
        let engLanguageButton = UIButton()
        engLanguageButton.tag = 0
        engLanguageButton.layer.cornerRadius = 6
        engLanguageButton.backgroundColor = UIColor(named: "viewColor")
        engLanguageButton.titleLabel?.font = UIFont.sfProText(ofSize: 15, weight: .medium)
        engLanguageButton.setTitleColor(.label, for: .normal)
        engLanguageButton.setImage(PFAssets.americanFlag.image, for: .normal)
        engLanguageButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        engLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        return engLanguageButton
    }()
    
    private lazy var rusLanguageButton: UIButton = {
        let rusLanguageButton = UIButton()
        rusLanguageButton.tag = 1
        rusLanguageButton.layer.cornerRadius = 6
        rusLanguageButton.backgroundColor = UIColor(named: "viewColor")
        rusLanguageButton.titleLabel?.font = UIFont.sfProText(ofSize: 15, weight: .medium)
        rusLanguageButton.setTitleColor(.label, for: .normal)
        rusLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        rusLanguageButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        rusLanguageButton.setImage(UIImage(named: "russianFlag"), for: .normal)
        return rusLanguageButton
    }()
    
    private lazy var rateGame: UIButton = {
        let rateGame = UIButton()
        rateGame.layer.cornerRadius = 12
        rateGame.backgroundColor = UIColor(named: "gameElementColor")
        rateGame.setTitle("rateApp".localized(), for: .normal)
        rateGame.setTitleColor(.label, for: .normal)
        rateGame.titleLabel?.font = UIFont.sfProText(ofSize: 15, weight: .semiBold)
        rateGame.contentHorizontalAlignment = .left
        rateGame.setImage(UIImage(named: "arrowUP"), for: .normal)
        rateGame.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        rateGame.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
        rateGame.addTarget(self, action: #selector(openAppStoreForRating), for: .touchUpInside)
        return rateGame
    }()
    
    private lazy var sendDeveloper: UIButton = {
        let sendDeveloper = UIButton()
        sendDeveloper.layer.cornerRadius = 12
        sendDeveloper.backgroundColor = UIColor(named: "gameElementColor")
        sendDeveloper.setTitle("writeSupport".localized(), for: .normal)
        sendDeveloper.setTitleColor(.label, for: .normal)
        sendDeveloper.titleLabel?.font = UIFont.sfProText(ofSize: 15, weight: .semiBold)
        sendDeveloper.contentHorizontalAlignment = .left
        sendDeveloper.titleEdgeInsets.left = 5
        sendDeveloper.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
        sendDeveloper.setImage(UIImage(named: "message"), for: .normal)
        sendDeveloper.addTarget(self, action: #selector(userHelpTapped), for: .touchUpInside)

        return sendDeveloper
    }()
    
    private lazy var changeCountry: UIButton = {
        let changeCountry = UIButton()
        changeCountry.layer.cornerRadius = 12
        changeCountry.backgroundColor = UIColor(named: "gameElementColor")
        changeCountry.setTitle("changeCountry".localized(), for: .normal)
        changeCountry.setTitleColor(.label, for: .normal)
        changeCountry.titleLabel?.font = UIFont.sfProText(ofSize: 15, weight: .semiBold)
        changeCountry.contentHorizontalAlignment = .left
        changeCountry.titleEdgeInsets.left = 5
        changeCountry.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
        changeCountry.setImage(UIImage(named: "globe"), for: .normal)
        changeCountry.addTarget(self, action: #selector(addCountryView), for: .touchUpInside)

        return changeCountry
    }()
    
    private lazy var appInfo: UITextView = {
        let appInfo = UITextView()
        appInfo.isScrollEnabled = false
        appInfo.isEditable = false
        appInfo.isSelectable = false
        appInfo.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 14), weight: .regular)
        appInfo.textColor = .label
        appInfo.backgroundColor = .clear
        return appInfo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
        setupLanguage()
    }
    
    func setup() {
        setupUI()
        makeConstaints()
        createTextAppInfo()
        setupText()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        self.view.addSubview(mainLabel)
        self.view.addSubview(scrollView)
        
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(themeView)
        themeView.addSubview(themeLabel)
        themeView.addSubview(themeButtonStack)
        themeView.addSubview(automaticSwitchThemeView)
        automaticSwitchThemeView.addSubview(automaticSwitchTheme)
        automaticSwitchThemeView.addSubview(automaticSwitchThemeLabel)
        automaticSwitchThemeView.addSubview(descriptionAutomaticSwitchThemeLabel)
        
        self.contentView.addSubview(languagesView)
        languagesView.addSubview(languagesLabel)
        languagesView.addSubview(engLanguageButton)
        languagesView.addSubview(rusLanguageButton)
        
        self.contentView.addSubview(rateGame)
        self.contentView.addSubview(sendDeveloper)
        self.contentView.addSubview(changeCountry)
        
        self.contentView.addSubview(appInfo)

    }
    
    func setupText() {
        mainLabel.text = "settingLabel".localized()
        themeLabel.text = "themeLabel".localized()
        automaticSwitchThemeLabel.text = "autoLabel".localized()
        descriptionAutomaticSwitchThemeLabel.text = "descriptionAutoLabel".localized()
        languagesLabel.text = "appLang".localized()
        rateGame.setTitle("rateApp".localized(), for: .normal)
        sendDeveloper.setTitle("writeSupport".localized(), for: .normal)
        changeCountry.setTitle("changeCountry".localized(), for: .normal)
        createTextAppInfo()
        createStackView()
    }
    
    func setupLanguage() {
        let currentLanguage = UserDefaultsManager.shared.getLanguage()
        if currentLanguage == "en" {
            selectButton(button: engLanguageButton)
            unselectButton(button: rusLanguageButton)
            
        } else if currentLanguage == "ru" {
            selectButton(button: rusLanguageButton)
            unselectButton(button: engLanguageButton)
        }
    }

    func setupTheme() {
        let currentTheme = UserDefaultsManager.shared.getTheme()
        switch currentTheme {
        case "light":
            selectView(view: lightThemeView)
            unselectView(view: darkThemeView)
        case "dark":
            selectView(view: darkThemeView)
            unselectView(view: lightThemeView)
        default:
            automaticSwitchTheme.isOn = true
            unselectView(view: lightThemeView)
            unselectView(view: darkThemeView)
        }
    }
    
    func makeConstaints() {
        
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        scrollView.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-5)
            maker.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalTo(scrollView)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(1.1)
        }
        
        themeView.snp.makeConstraints { maker in
            maker.top.equalTo(contentView).inset(5)
            maker.left.right.equalToSuperview().inset(5)
        }
        
        themeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(themeView).inset(15)
            maker.left.equalTo(themeView).inset(25)
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
            maker.bottom.equalTo(themeView).inset(10)
        }
        
        automaticSwitchThemeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(automaticSwitchThemeView).inset(5)
            maker.left.equalTo(self.view.safeAreaLayoutGuide ).inset(25)
        }
        
        descriptionAutomaticSwitchThemeLabel.snp.makeConstraints { maker in
            maker.top.equalTo(automaticSwitchThemeLabel.snp.bottom).inset(-4)
            maker.left.equalTo(self.view.safeAreaLayoutGuide).inset(25)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        automaticSwitchTheme.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().inset(20)
        }
        
        languagesView.snp.makeConstraints { maker in
            maker.top.equalTo(themeView.snp.bottom).inset(-10)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
        languagesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(languagesView).inset(10)
            maker.left.equalTo(languagesView).inset(25)
        }

        engLanguageButton.snp.makeConstraints { maker in
            maker.top.equalTo(languagesLabel.snp.bottom).inset(-10)
            maker.left.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        rusLanguageButton.snp.makeConstraints { maker in
            maker.top.equalTo(languagesLabel.snp.bottom).inset(-10)
            maker.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(10)
        }
        
        rateGame.snp.makeConstraints { maker in
            maker.top.equalTo(languagesView.snp.bottom).inset(-10)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
        sendDeveloper.snp.makeConstraints { maker in
            maker.top.equalTo(rateGame.snp.bottom).inset(-10)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
        changeCountry.snp.makeConstraints { maker in
            maker.top.equalTo(sendDeveloper.snp.bottom).inset(-10)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
        appInfo.snp.makeConstraints { maker in
            maker.top.equalTo(changeCountry.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func createStackView() {
        for view in themeButtonStack.arrangedSubviews {
              for subview in view.subviews {
                  subview.removeFromSuperview()
              }
              view.removeFromSuperview()
          }
        
        themeButtonStack.addArrangedSubview(createThemeButton(text: "tightLabel".localized()!, image: UIImage(named: "icon_light"), tag: 0))
        themeButtonStack.addArrangedSubview(createThemeButton(text: "darkLabel".localized()!, image: UIImage(named: "icon_dark"), tag: 1))
    }
    
    func createThemeButton(text: String, image: UIImage?, tag: Int) -> UIView {
        let customView = tag == 0 ? lightThemeView : darkThemeView
        customView.tag = tag
        customView.layer.cornerRadius = 12

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTheme))
        customView.addGestureRecognizer(tapGesture)
        customView.isUserInteractionEnabled = true

        let label = UILabel()
        label.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 12), weight: .semiBold)
        label.text = text
        label.textAlignment = .center
        label.textColor = tag == 0 ? .black : .white
        customView.addSubview(label)

        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        customView.addSubview(imageView)
        
        if tag == 0 {
            customView.backgroundColor = UIColor(hex: 0xffffff)
            label.textColor = .black
        } else {
            customView.backgroundColor = UIColor(hex: 0x313131)
            label.textColor = .white
        }

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
                        automaticSwitchTheme.isOn = false
                        UserDefaultsManager.shared.setCurrentTheme(theme: "light")
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            } else {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    lightThemeView.layer.borderColor =  UIColor.clear.cgColor
                    lightThemeView.layer.borderWidth = 0
                    automaticSwitchTheme.isOn = false
                    UserDefaultsManager.shared.setCurrentTheme(theme: "dark")
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
                    UserDefaultsManager.shared.setCurrentTheme(theme: "auto")
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
                        UserDefaultsManager.shared.setCurrentTheme(theme: "dark")
                        window.overrideUserInterfaceStyle = .dark
                    } else {
                        lightThemeView.layer.borderColor = UIColor.purple.cgColor
                        lightThemeView.layer.borderWidth = 2
                        UserDefaultsManager.shared.setCurrentTheme(theme: "light")
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
    }
        
    @objc func changeLanguage(sender: UIButton) {
        if sender.tag == 0 {
            selectButton(button: engLanguageButton)
            unselectButton(button: rusLanguageButton)
            UserDefaultsManager.shared.setCurrentLanguage(lang: "en")
        } else {
            selectButton(button: rusLanguageButton)
            unselectButton(button: engLanguageButton)
            UserDefaultsManager.shared.setCurrentLanguage(lang: "ru")
        }
        
        UserDefaultsManager.shared.synchronize()
        setupText()
//        UIApplication.shared.reloadRootViewController()
    }

    func selectButton(button: UIButton) {
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
    }
    
    func unselectButton(button: UIButton) {
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0.5
    }
    
    func selectView(view: UIView) {
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.borderWidth = 2
    }
    
    func unselectView(view: UIView) {
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0
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
    
   @objc func openAppStoreForRating() {
       guard let appId = "6449543793" as String? else {
           print("Failed to get the app ID")
           return
       }
       
       let appStoreUrl = "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review"
       
       if let url = URL(string: appStoreUrl), UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       } else {
           print("Failed to open the App Store")
       }
   }
    
    func createTextAppInfo() {
        var version = ""
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            version = appVersion
        } else {
           version = "no info"
        }

        let id = RealmManager.shared.getUserId()
        let systemVersion = UIDevice.current.systemVersion
        let versionApp = "versionApp".localized()! + ": " + version + "\n"
        let userID = "IDuser".localized()! + ": \n" + "\(id)\n"
        let iosVersion = "iosVersion".localized()! + ": " + "\(systemVersion)\n"

        let appVersion = versionApp + userID  + iosVersion

        appInfo.text = appVersion
    }
    
    @objc func  addCountryView() {
        let view = ChangeCountryView(dismisAction: {
            self.dismiss(animated: true)
        })
        let hostingController = UIHostingController(rootView: view)
        self.present(hostingController, animated: true)
    }
}
