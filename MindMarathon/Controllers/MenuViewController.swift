//
//  MenuViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatingUI()
    }
    
    func creatingUI() {
        let labelFirst = UILabel()
        labelFirst.text = "MIND"
        labelFirst.font = UIFont(name: "HelveticaNeue-Bold", size: 55.0)
        labelFirst.numberOfLines = 0
        labelFirst.textAlignment = .center
        view.addSubview(labelFirst)
        
        let labelSecond = UILabel()
        labelSecond.text = "MARATHON"
        labelSecond.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        labelSecond.numberOfLines = 0
        labelSecond.textAlignment = .center
        view.addSubview(labelSecond)
        
        let startMarathon = UIButton()
        startMarathon.setTitle("Начать марафон", for: .normal)
        startMarathon.tintColor = UIColor.label
        startMarathon.backgroundColor = UIColor.tertiaryLabel
        startMarathon.layer.cornerRadius = 10
//        startMarathon.addTarget(self, action: #selector(startMarathonTapped), for: .touchUpInside)
        view.addSubview(startMarathon)
        
        let bullCowGame = UIButton()
        bullCowGame.setTitle("Быки и Коровы", for: .normal)
        bullCowGame.tintColor = UIColor.label
        bullCowGame.backgroundColor = UIColor.tertiaryLabel
        bullCowGame.layer.cornerRadius = 10
        bullCowGame.addTarget(self, action: #selector(bullCowGameTapped), for: .touchUpInside)
        view.addSubview(bullCowGame)
    
        labelFirst.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(100)
            maker.left.right.equalToSuperview().inset(100)
        }
        
        labelSecond.snp.makeConstraints { maker in
            maker.bottom.equalTo(labelFirst).inset(60)
            maker.left.right.equalToSuperview().inset(100)
        }
        startMarathon.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(10)
            maker.top.equalTo(labelSecond).inset(250)
            maker.height.equalTo(50)
        }
        
        bullCowGame.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(10)
            maker.top.equalTo(startMarathon).inset(70)
            maker.height.equalTo(50)
        }
    }
    
    @objc
    func bullCowGameTapped () {
        let bullCowGame = BullCowViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: bullCowGame)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
