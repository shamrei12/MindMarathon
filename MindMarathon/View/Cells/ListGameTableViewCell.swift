//
//  ListGameTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.06.23.
//

import UIKit
import SnapKit
class ListGameTableViewCell: UITableViewCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
