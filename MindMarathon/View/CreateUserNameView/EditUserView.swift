//
//  CreateUserView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 8.01.24.
//

import UIKit
import SnapKit

class EditUserView: UIView, UITextFieldDelegate {
    
    private var choiceCountryButton = CountryDropdownButton()
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(named: "viewColor")
        mainView.layer.cornerRadius = 12
        return mainView
    }()
    
    private lazy var closeViewButton: UIButton = {
        let closeViewButton = UIButton()
        closeViewButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeViewButton.backgroundColor = UIColor.systemRed
        closeViewButton.tintColor = .white
        closeViewButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        closeViewButton.configuration?.cornerStyle = .dynamic
        closeViewButton.clipsToBounds = true

        return closeViewButton
    }()
    
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 20), weight: .bold)
        return usernameLabel
    }()
    
    private lazy var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.placeholder = "Username"
        userNameTextField.backgroundColor = CustomColor.gameElement.color
        userNameTextField.layer.cornerRadius = 12
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: userNameTextField.frame.height))
        userNameTextField.leftView = leftPaddingView
        userNameTextField.leftViewMode = .always

        return userNameTextField
    }()
    
    private lazy var countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.text = "editCountry".localized()
        countryLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 20), weight: .bold)
        return countryLabel
    }()

    private lazy var acceptButton: UIButton = {
        let acceptButton = UIButton()
        acceptButton.backgroundColor = .systemGreen
        acceptButton.layer.cornerRadius = 12
        acceptButton.setTitle("acceptButton".localized(), for: .normal)
        acceptButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return acceptButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.hideKeyboardWhenTappedAround()
        userNameTextField.delegate = self
        acceptButton.backgroundColor = .systemGray
        acceptButton.isEnabled = false
        self.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        self.mainView.addSubview(closeViewButton)
//        CustomTabBarController().enableTabBar()
        self.addSubview(mainView)
        self.mainView.addSubview(usernameLabel)
        self.mainView.addSubview(userNameTextField)
        self.mainView.addSubview(countryLabel)
        choiceCountryButton.gameList = CountryManager().country
        choiceCountryButton.backgroundColor = .white
        choiceCountryButton.titleLabel?.textColor = .label
        choiceCountryButton.layer.cornerRadius = 12
        self.addSubview(choiceCountryButton)
        self.mainView.addSubview(acceptButton)
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.right.equalToSuperview().inset(10)
        }
        
        closeViewButton.snp.makeConstraints { maker in
            maker.top.right.equalToSuperview().inset(10)
            maker.height.width.equalTo(35)
        }

        closeViewButton.layoutIfNeeded()

        closeViewButton.layer.cornerRadius = closeViewButton.bounds.width / 2
        closeViewButton.layer.masksToBounds = true

        usernameLabel.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(20)
        }
        
        userNameTextField.snp.makeConstraints { maker in
            maker.top.equalTo(usernameLabel.snp.bottom).inset(-20)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.15)
        }
        
        countryLabel.snp.makeConstraints { maker in
            maker.top.equalTo(userNameTextField.snp.bottom).inset(-20)
            maker.left.right.equalToSuperview().inset(20)
        }
        
        choiceCountryButton.snp.makeConstraints { maker in
            maker.top.equalTo(countryLabel.snp.bottom).inset(-20)
            maker.left.right.equalTo(mainView).inset(10)
            maker.height.equalTo(mainView.snp.height).multipliedBy(0.15)
        }
        
        acceptButton.snp.makeConstraints { maker in
            maker.top.equalTo(choiceCountryButton.snp.bottom).inset(-25)
            maker.left.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    func updateView() {
        usernameLabel.text = "editNickname".localized()
        countryLabel.text = "editCountry".localized()
        acceptButton.setTitle("acceptButton".localized(), for: .normal)
    }
    @objc
    func exit() {
        if userNameTextField.text!.count > 1 {
            let newUserName = userNameTextField.text
            RealmManager.shared.changeUsername(name: newUserName ?? "")
        }
        
        if let country = choiceCountryButton.titleLabel!.text {
            var userID = ""
            for i in CountryManager().country {
                if i[1] == country {
                    userID = i.first ?? ""
                }
            }
            RealmManager.shared.changeUserNationality(country: userID)
        }
        
        self.removeFromSuperview()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if userNameTextField.text!.count > 1 {
            acceptButton.backgroundColor = .systemGreen
            acceptButton.isEnabled = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if userNameTextField.text!.count > 1 {
            acceptButton.backgroundColor = .systemGreen
            acceptButton.isEnabled = true
        } else {
            acceptButton.backgroundColor = .systemGray
            acceptButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }
    
    @objc
    func closeVC() {
        
        self.removeFromSuperview()
    }
}
