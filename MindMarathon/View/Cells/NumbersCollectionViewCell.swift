//
//  NumbersCollectionViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.09.23.
//

import UIKit
import SnapKit

class NumbersCollectionViewCell: UICollectionViewCell {
    
    let numberLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    override func prepareForReuse() {
        
    }
    
    func setupLabel() {
        numberLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        
        self.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    func select() {
        self.backgroundColor = .red
    }
    
    func deselect() {
        self.backgroundColor = .systemGray
    }
    
    func hide() {
        self.backgroundColor = .systemGray.withAlphaComponent(0.2)
    }

}
