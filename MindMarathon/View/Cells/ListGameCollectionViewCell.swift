import UIKit
import SnapKit

class ListGameCollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    let gameImageView = UIImageView()
    let gameNameLabel = UILabel()
    let aboutGameLabel = UILabel()
    let gameInfoStackView = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        setupUI()
        setupConstraints()
        self.backgroundColor = .clear
    }
    
    func setupUI() {
        createCintainerView()
        
        createGameInfoStackView()
    
        gameImageView.contentMode = .scaleAspectFit
        containerView.addSubview(gameImageView)

    }
    
    func createCintainerView() {
        containerView.backgroundColor = CustomColor.gameElement.color
        containerView.addShadowView()
        contentView.addSubview(containerView)
    }
    
    func createGameInfoStackView() {
        gameInfoStackView.axis = .vertical
        gameInfoStackView.distribution = .fill
        gameInfoStackView.spacing = 1
        gameInfoStackView.addArrangedSubview(createGameNameLabel())
        gameInfoStackView.addArrangedSubview(createAboutGameLabel())
        containerView.addSubview(gameInfoStackView)
    }
    
    func createGameNameLabel() -> UILabel {
        if UIScreen.main.bounds.size.width <= 414 { // Для экранов iPhone с диагональю до 5.5 дюйма
            gameNameLabel.font = UIFont.sfProText(ofSize: 16, weight: .semiBold)
        } else {
            gameNameLabel.font = UIFont.sfProText(ofSize: 40, weight: .semiBold)
        }
        gameNameLabel.numberOfLines = 0
        gameNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        return gameNameLabel
    }
    
    func createAboutGameLabel() -> UILabel {
        aboutGameLabel.numberOfLines = 0
        if UIScreen.main.bounds.size.width <= 414 { // Для экранов iPhone с диагональю до 5.5 дюйма
            aboutGameLabel.font = UIFont.sfProText(ofSize: 12, weight: .light)
        } else {
            aboutGameLabel.font = UIFont.sfProText(ofSize: 32, weight: .light)
        }
        
        return aboutGameLabel
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(1)
        }
        
        gameImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(5)
            maker.left.right.equalToSuperview().inset(10)
            maker.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.7)
            maker.centerY.equalToSuperview()
        }
        
        gameInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).inset(-5)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(2)
        }
    }

}
