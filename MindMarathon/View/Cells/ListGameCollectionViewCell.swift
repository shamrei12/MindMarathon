import UIKit
import SnapKit

class ListGameCollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    let gameImageView = UIImageView()
    let gameNameLabel = UILabel()
    let aboutGameLabel = UILabel()
    let gameNameStackView = UIStackView()
    let gameInfoStackView = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        setupUI()
        setupConstraints()
        self.backgroundColor = .clear
    }
    
    func setupUI() {
        containerView.backgroundColor = CustomColor.gameElement.color
        containerView.addShadowView()
        contentView.addSubview(containerView)
        
        gameNameStackView.axis = .horizontal
        gameNameStackView.distribution = .fillEqually
        gameNameStackView.spacing = 1
        containerView.addSubview(gameNameStackView)
        
        gameImageView.contentMode = .scaleAspectFit
        containerView.addSubview(gameImageView)
        
        gameNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        gameNameLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        gameNameLabel.minimumScaleFactor = 0.1

        gameNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        gameNameStackView.addArrangedSubview(gameNameLabel)
        
        aboutGameLabel.numberOfLines = 0
        aboutGameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        aboutGameLabel.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
        aboutGameLabel.minimumScaleFactor = 0.1
        containerView.addSubview(aboutGameLabel)
        
        gameInfoStackView.addArrangedSubview(gameNameStackView)
        gameInfoStackView.addArrangedSubview(aboutGameLabel)
        gameInfoStackView.axis = .vertical
        gameInfoStackView.distribution = .fill
        gameInfoStackView.spacing = 5
        containerView.addSubview(gameInfoStackView)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: -5, left: 1, bottom: 1, right: 1))
        }
        
        gameImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(1)
            maker.left.right.equalToSuperview().inset(5)
            maker.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            maker.centerY.equalToSuperview()
        }
        
        gameInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).inset(5)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(7)
        }
    }

}
