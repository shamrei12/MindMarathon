//
//  CreateUserView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 8.01.24.
//

import UIKit
import SnapKit

protocol UserCreateDelegate: AnyObject {
    func enableTabBar()
    func userCreate()
}

class CreateUserView: UIView, UITextFieldDelegate {
    weak var delegate: UserCreateDelegate?
    var firebase = FirebaseData()
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(named: "viewColor")
        mainView.layer.cornerRadius = 12
        return mainView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Введите ваш никнейм"
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
    
    private lazy var acceptButton: UIButton = {
        let acceptButton = UIButton()
        acceptButton.backgroundColor = .systemGreen
        acceptButton.layer.cornerRadius = 12
        acceptButton.setTitle("Подтвердить", for: .normal)
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
//        CustomTabBarController().enableTabBar()
        self.addSubview(mainView)
        self.mainView.addSubview(usernameLabel)
        self.mainView.addSubview(userNameTextField)
        self.mainView.addSubview(acceptButton)
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.3)
        }
        
        usernameLabel.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(20)
        }
        
        userNameTextField.snp.makeConstraints { maker in
            maker.top.equalTo(usernameLabel.snp.bottom).inset(-20)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        
        acceptButton.snp.makeConstraints { maker in
            maker.top.equalTo(userNameTextField.snp.bottom).inset(-25)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    @objc
    func exit() {
        if userNameTextField.text!.count > 1 {
            let userActivity: [WhiteBoardManager] = RealmManager.shared.getUserStatistics()
            RealmManager.shared.clearRealmDatabase()
            RealmManager.shared.firstCreateUserProfile(userName: userNameTextField.text ?? "")
            
            print(userActivity.count)
            print(userActivity.isEmpty)
            
            guard userActivity.isEmpty else {
                RealmManager.shared.addPremiumStatus(status: TimeManager.shared.getEndlessPremium())
                return
            }

            let realmData = RealmManager.shared.getUserProfileData()
            firebase.refGetData(from: realmData)
            delegate?.enableTabBar()
            delegate?.userCreate()
            self.removeFromSuperview()
        }
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
}
