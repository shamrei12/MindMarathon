//
//  RatingViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 6.01.24.
//

import UIKit
import SnapKit

class RatingViewController: UIViewController {

    let tableview = RatingTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setup()
        makeConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.title = "leaderboard".localized()

        let attributes = [
            NSAttributedString.Key.font: UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func setup() {
        self.view.backgroundColor = CustomColor.viewColor.color
        self.view.addSubview(tableview)
    }
    
    func makeConstraints() {
        tableview.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            maker.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true)
    }

}
