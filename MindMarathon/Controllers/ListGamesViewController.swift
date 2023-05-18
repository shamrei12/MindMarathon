//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit

class ListGamesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр"
    }


    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }

    @objc
    func rulesTapped() {
        print("RULES Not")
    }
}
