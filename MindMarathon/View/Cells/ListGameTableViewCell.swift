//
//  ListGameTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.06.23.
//

import UIKit
import SnapKit
class ListGameTableViewCell: UITableViewCell {
    let gameButton = UIButton()
    let createBy = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        createUI()
    }
    
    func createUI() {
        gameButton.layer.cornerRadius = 10
        gameButton.backgroundColor = .lightGray
        gameButton.tintColor = .label
        gameButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 35.0)
        gameButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.addSubview(gameButton)
        gameButton.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(10)
        }
        
        createBy.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        createBy.textAlignment = .justified
        self.addSubview(createBy)
        createBy.snp.makeConstraints { maker in
            maker.top.equalTo(gameButton.snp.bottom).inset(-10)
            maker.left.right.equalToSuperview().inset(10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
