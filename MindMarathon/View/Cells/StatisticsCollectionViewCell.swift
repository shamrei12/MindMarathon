//
//  StatisticsCollectionViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit
import SnapKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(hex: 0xffffff, alpha: 1)
        mainView.addShadowView()
        mainView.layer.cornerRadius = 12
        
        return mainView
    }()
    
    private lazy var dataText: UILabel = {
        let labelText = UILabel()
        labelText.font = UIFont.sfProText(ofSize: 22, weight: .bold)
        labelText.textAlignment = .center
        labelText.textColor = .black
        labelText.numberOfLines = 0
        return labelText
    }()
    
    private lazy var descriptionText: UILabel = {
        let labelText = UILabel()
        labelText.font = UIFont.sfProText(ofSize: 14, weight: .light)
        labelText.textAlignment = .center
        labelText.textColor = .black
        return labelText
    }()
    
    func setup(data: String, description: String) {
        dataText.text = data
        descriptionText.text = description
        setupUI()
        makeConstaints()
    }
    
    private func setupUI() {
        self.addSubview(mainView)
        mainView.addSubview(dataText)
        mainView.addSubview(descriptionText)
    }
    
    private func makeConstaints() {
        mainView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(1)
        }
        
        dataText.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(5)
            maker.left.right.equalToSuperview().inset(1)
        }
        
        descriptionText.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.left.right.bottom.equalToSuperview().inset(5)
        }
    }
}
