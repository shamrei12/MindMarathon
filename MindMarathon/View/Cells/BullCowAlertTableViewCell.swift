//
//  BullCowAlertTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.06.23.
//

import UIKit
import SnapKit

class BullCowAlertTableViewCell: UITableViewCell {
    
    let alert = UILabel()
    let mainView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        createUI()
    }
    
    func createUI() {
        mainView.backgroundColor = UIColor(named: "gameElementColor")
        mainView.layer.cornerRadius = 10
        self.addSubview(mainView)
        
        mainView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview().inset(10)
        }
        
        alert.text = "Для начала игры нажмите нажмите PLAY"
        alert.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        alert.tintColor = .label
        alert.numberOfLines = 0
        alert.textAlignment = .center
        
        
        self.addSubview(alert)
        
        alert.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalTo(mainView).inset(10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
