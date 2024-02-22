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
//        mainView.backgroundColor = UIColor.red
//        mainView.addShadowView()
        mainView.layer.cornerRadius = 12
        
        return mainView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coin")
        return imageView
    }()
    
    private lazy var dataText: UILabel = {
        let labelText = UILabel()
        labelText.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 20), weight: .bold)
        labelText.textAlignment = .left
        labelText.textColor = .label
        labelText.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        labelText.minimumScaleFactor = 0.1
        labelText.numberOfLines = 0
        return labelText
    }()
    
    private lazy var descriptionText: UILabel = {
        let labelText = UILabel()
        labelText.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 12), weight: .light)
        labelText.textAlignment = .justified
        labelText.textColor = .label
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
        mainView.addSubview(imageView)
        mainView.addSubview(dataText)
        mainView.addSubview(descriptionText)
    }
    
    private func makeConstaints() {
        mainView.snp.makeConstraints { maker in
            maker.top.right.bottom.equalToSuperview().inset(1)
            maker.left.equalToSuperview().inset(10)
        }
        
        dataText.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(5)
            maker.left.equalToSuperview().inset(5)
            maker.right.equalToSuperview().inset(1)
            maker.height.equalToSuperview().multipliedBy(0.6)
        }
         
        descriptionText.snp.makeConstraints { maker in
            maker.top.equalTo(dataText.snp.bottom).inset(-1)
            maker.left.equalToSuperview().inset(5)
            maker.bottom.equalToSuperview().inset(5)
        }
    }
}
