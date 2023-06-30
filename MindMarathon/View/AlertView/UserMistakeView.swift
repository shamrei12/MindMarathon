//
//  userMistakeView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 21.05.23.
//

import UIKit
import SnapKit

class UserMistakeView: UIView {
    var message = UILabel()
    
    override func awakeFromNib() {
    }
    
    func createUI(messages: String) {
        let contentView = UIView()
        message.text = messages
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
