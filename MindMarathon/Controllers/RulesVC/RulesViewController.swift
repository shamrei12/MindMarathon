//
//  RulesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 25.11.23.
//

import UIKit

class RulesViewController: UIViewController, GameButtonDelegate {

    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Rules".localize()
        mainLabel.font = UIFont.sfProText(ofSize: FontAdaptation.addaptationFont(sizeFont: 25), weight: .bold)
        mainLabel.textColor = .label
        
        return mainLabel
    }()
    
    private lazy var dropdownButton: DropdownButton = {
        let dropdownButton = DropdownButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        dropdownButton.backgroundColor = UIColor(named: "gameElementColor" )
        dropdownButton.layer.cornerRadius = 12
        
        dropdownButton.setTitle("chooseGame".localize(), for: .normal)
        dropdownButton.setTitleColor(.label, for: .normal)
        dropdownButton.gameList = ["chooseGame".localize(), "bullcow".localize(), "slovus".localize(), "flood_fill".localize(), "tictactoe".localize(), "binario".localize(), "Numbers".localize()]
        
        return dropdownButton
    }()
    
    private lazy var rulesView: UIView = {
        let rulesView = UIView()
        rulesView.backgroundColor = UIColor(named: "gameElementColor")
        rulesView.layer.cornerRadius = 12
        
        return rulesView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.sfProText(ofSize: 20, weight: .regular)
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = UIColor(named: "gameElementColor")
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        dropdownButton.delegate = self
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(named: "viewColor")
        self.view.addSubview(mainLabel)
        self.view.addSubview(dropdownButton)
        self.view.addSubview(rulesView)
        self.rulesView.addSubview(textView)
    }
    
    func makeConstraints() {
        mainLabel.snp.makeConstraints { maker in
            maker.left.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        dropdownButton.snp.makeConstraints { maker in
            maker.top.equalTo(mainLabel.snp.bottom).inset(-25)
            maker.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)
            maker.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        rulesView.snp.makeConstraints { maker in
            maker.top.equalTo(dropdownButton.snp.bottom).inset(-10)
            maker.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        textView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(5)
        }
    }
    
    func gameButtonDidTap(game: String) {
            switch game {
            case "bullcow".localize():
                textView.text = "bullCow_rules".localize()
            case "slovus".localize():
                textView.text = "slovus_rules".localize()
            case "flood_fill".localize():
                textView.text = "floodFill_rules".localize()
            case "tictactoe".localize():
                textView.text = "tictactoe_rules".localize()
            case "binario".localize():
                textView.text = "binario_rules".localize()
            case "Numbers".localize():
                textView.text = "numbers_rules".localize()
            default:
                textView.text = ""
            }
    }
    
}
