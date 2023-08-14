import UIKit
import SnapKit

class ListGameTableViewCell: UITableViewCell {
    let containerView = UIView()
    let gameImageView = UIImageView()
    let gameNameLabel = UILabel()
    let createdByLabel = UILabel()
    let aboutGameLabel = UILabel()
    let gameNameStackView = UIStackView()
    let separationView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        setupUI()
        setupConstraints()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    func setupUI() {
        
        containerView.backgroundColor = CustomColor.gameElement.color
        contentView.addSubview(containerView)
        
        gameNameStackView.axis = .horizontal
        gameNameStackView.distribution = .fill
        gameNameStackView.spacing = 5
        containerView.addSubview(gameNameStackView)
        
        gameImageView.contentMode = .scaleAspectFit
        containerView.addSubview(gameImageView)
        
        gameNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        createdByLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 10.0)
        
        gameNameStackView.addArrangedSubview(gameNameLabel)
        gameNameStackView.addArrangedSubview(createdByLabel)
        
        aboutGameLabel.numberOfLines = 0
        aboutGameLabel.font = UIFont.systemFont(ofSize: 14)
        containerView.addSubview(aboutGameLabel)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 1))
        }
        
        gameImageView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.top.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(gameImageView.snp.height)
        }
        
        gameNameStackView.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        aboutGameLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(gameImageView.snp.trailing).offset(10)
            maker.top.equalTo(gameNameStackView.snp.bottom).offset(5)
            maker.trailing.bottom.equalToSuperview()
        }
    }
}
