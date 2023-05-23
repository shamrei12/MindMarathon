//
//  userMistakeView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 21.05.23.
//

import UIKit
import SnapKit

class UserMistakeView: UIView {
    
   
    
    override func awakeFromNib() {
        createUI()
    }
    
    func createUI() {
        let message = UILabel()
        let contentView = UIView()
        message.text = "Данного слова не существует в словаре. Проверьте написание и повторите попытку"
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        message.textColor = .label
        self.addSubview(contentView)
        self.addSubview(message)
        
        contentView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
        
        message.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalTo(contentView).inset(10)
        }
    }
}
