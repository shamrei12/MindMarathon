//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit


class ListGamesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр"
        createUI()
    }
    
    func createUI() {
        
        let bullCowButton = UIButton()
        let bullCowStackView = UIStackView()
        
        bullCowButton.setTitle("Быки и Коровы", for: .normal)
        bullCowButton.titleLabel?.font = UIFont (name: "HelveticaNeue-Bold", size: 20.0)
        bullCowButton.backgroundColor = UIColor.tertiaryLabel
        bullCowButton.layer.cornerRadius = 10
        bullCowButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bullCowButton.addTarget(self, action: #selector(bullCowButtonTapped), for: .touchUpInside)
        view.addSubview(bullCowButton)
        
        bullCowStackView.addArrangedSubview(bullCowButton)
        bullCowStackView.distribution = .fill
        bullCowStackView.axis = .vertical
        bullCowStackView.spacing = 5
        view.addSubview(bullCowStackView)
        
        bullCowStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.right.equalToSuperview().inset(10)
        }
        
        let slovusButton = UIButton()
        let slovusStackView = UIStackView()
        
        
        slovusButton.setTitle("Словус", for: .normal)
        slovusButton.titleLabel?.font = UIFont (name: "HelveticaNeue-Bold", size: 20.0)
        slovusButton.backgroundColor = UIColor.tertiaryLabel
        slovusButton.layer.cornerRadius = 10
        slovusButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        slovusButton.addTarget(self, action: #selector(slovusButtonTapped), for: .touchUpInside)
        view.addSubview(slovusButton)
        
        slovusStackView.addArrangedSubview(slovusButton)
        slovusStackView.distribution = .fill
        slovusStackView.axis = .vertical
        slovusStackView.spacing = 5
        
        view.addSubview(slovusStackView)
        
        slovusStackView.snp.makeConstraints { maker in
            maker.top.equalTo(bullCowStackView).inset(70)
            maker.left.right.equalToSuperview().inset(10)
        }
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    func bullCowButtonTapped() {
        let bullCowGame = BullCowViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: bullCowGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func slovusButtonTapped() {
        let slovusGame = SlovusGameViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: slovusGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
}
