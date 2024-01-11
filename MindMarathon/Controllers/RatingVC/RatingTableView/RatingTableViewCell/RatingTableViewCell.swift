//
//  RatingTableViewCell.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 6.01.24.
//

import UIKit
import SnapKit

class RatingTableViewCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.layer.cornerRadius = 20
        mainView.backgroundColor = UIColor(named: "gameElementColor")
        mainView.addShadowView()
        return mainView
    }()
    
    private lazy var insertView: UIView = {
        let insertView = UIView()
        insertView.backgroundColor = .clear
        return insertView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.text = "1."
        ratingLabel.font = UIFont.sfProText(ofSize: 17, weight: .regular)
        ratingLabel.textColor = .label
        return ratingLabel
    }()
    
    private lazy var coutryLabel: UILabel = {
        let coutryLabel = UILabel()
        coutryLabel.text = "BLR"
        coutryLabel.font = UIFont.sfProText(ofSize: 17, weight: .regular)
        return coutryLabel
    }()
    
    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.image = UIImage(named: "userImage")
        userImage.clipsToBounds = true
        return userImage
    }()
    
    private lazy var username: UILabel = {
        let username = UILabel()
        username.text = "Batonkmn"
        username.font = UIFont.sfProText(ofSize: 17, weight: .bold)
        username.textColor = .label
        return username
    }()
    
    private lazy var scoreUser: UILabel = {
        let scoreUser = UILabel()
        scoreUser.text = "1200 exp"
        scoreUser.font = UIFont.sfProText(ofSize: 17, weight: .regular)
        scoreUser.textColor = .label
        return scoreUser
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(data: ProfileManager, rating: Int) {
        setup()
        makeConstraints()
        coutryLabel.text = "\(data.nationality)"
        username.text = "\(data.username)"
        userImage.image = UIImage(named: data.userImage)
        scoreUser.text = "\(data.userScore)"
        ratingLabel.text = "#\(rating)"
        
    }
    
    func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.addSubview(insertView)
        self.addSubview(mainView)
        self.mainView.addSubview(ratingLabel)
        self.mainView.addSubview(coutryLabel)
        self.mainView.addSubview(userImage)
        self.mainView.addSubview(username)
        self.mainView.addSubview(scoreUser)
    }
    
    func makeConstraints() {
        insertView.snp.makeConstraints { maker in
            maker.bottom.right.equalToSuperview()
            maker.height.equalTo(5)
        }
        
        mainView.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview().inset(10)
            maker.bottom.equalTo(insertView.snp.top).inset(-5)
        }
        
        ratingLabel.snp.makeConstraints { maker in
            maker.top.left.bottom.equalToSuperview().inset(10)
        }
        
        coutryLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.left.equalTo(ratingLabel.snp.right).inset(-10)
        }
        
        userImage.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.left.equalTo(coutryLabel.snp.right).inset(-10)
            maker.width.height.equalTo(mainView.snp.height).multipliedBy(0.7)
        }
        
        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        
        username.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.left.equalTo(userImage.snp.right).inset(-15)
        }
        
        scoreUser.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.right.equalToSuperview().inset(10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
