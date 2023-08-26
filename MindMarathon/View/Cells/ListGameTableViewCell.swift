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
    let gameInfoStackView = UIStackView()
    
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
        gameNameStackView.distribution = .fillProportionally
        gameNameStackView.spacing = 1
        containerView.addSubview(gameNameStackView)
        
        gameImageView.contentMode = .scaleAspectFit
        containerView.addSubview(gameImageView)
        
        gameNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        gameNameLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        gameNameLabel.minimumScaleFactor = 0.1
        createdByLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        createdByLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        createdByLabel.minimumScaleFactor = 0.1
        
        gameNameStackView.addArrangedSubview(gameNameLabel)
        gameNameStackView.addArrangedSubview(createdByLabel)
        
        aboutGameLabel.numberOfLines = 0
        aboutGameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 40.0)
        aboutGameLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        aboutGameLabel.minimumScaleFactor = 0.2
        containerView.addSubview(aboutGameLabel)
        
        gameInfoStackView.addArrangedSubview(gameNameStackView)
        gameInfoStackView.addArrangedSubview(aboutGameLabel)
        gameInfoStackView.axis = .vertical
        gameInfoStackView.distribution = .fill
        gameInfoStackView.spacing = 10
        containerView.addSubview(gameInfoStackView)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 5))
        }
        
        gameImageView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.top.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(gameImageView.snp.height)
        }
        
        gameInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(gameImageView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
