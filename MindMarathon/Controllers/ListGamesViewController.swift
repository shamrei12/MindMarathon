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
        let infoBullCowGame = UILabel()
        let bullCowStackView = UIStackView()
        
        bullCowButton.setTitle("Быки и Коровы", for: .normal)
        bullCowButton.titleLabel?.font = UIFont (name: "HelveticaNeue-Bold", size: 20.0)
        bullCowButton.backgroundColor = UIColor.tertiaryLabel
        bullCowButton.layer.cornerRadius = 10
        bullCowButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bullCowButton.addTarget(self, action: #selector(bullCowButtonTapped), for: .touchUpInside)
        view.addSubview(bullCowButton)
        
        infoBullCowGame.text = "время: -- | кодичество ходов: --"
        infoBullCowGame.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        infoBullCowGame.textColor = .label
        infoBullCowGame.numberOfLines = 0
        infoBullCowGame.textAlignment = .center
        view.addSubview(infoBullCowGame)
        
        bullCowStackView.addArrangedSubview(bullCowButton)
        bullCowStackView.addArrangedSubview(infoBullCowGame)
        bullCowStackView.distribution = .fill
        bullCowStackView.axis = .vertical
        bullCowStackView.spacing = 5
        view.addSubview(bullCowStackView)
        
        bullCowStackView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
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
    
    @objc
    func rulesTapped() {
        print("RULES Not")
    }
}
