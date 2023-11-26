//
//  DropToDownButton.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 25.11.23.
//

import UIKit
import SnapKit

protocol GameButtonDelegate: AnyObject {
    func gameButtonDidTap(game: String)
}


class DropdownButton: UIButton {
    
    weak var delegate: GameButtonDelegate?

    var tableView: UITableView?
    var gameList: [String] = []
    var isOpen: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    }
    
    @objc func toggleDropdown() {
        isOpen = !isOpen
        if isOpen {
            showDropdown()
        } else {
            hideDropdown()
        }        
    }
    
    func showDropdown() {
        guard tableView == nil else { return }
        
        let dropdownHeight: CGFloat = 200
        let dropdownFrame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height + 5, width: frame.size.width - 10, height: dropdownHeight)
        tableView = UITableView(frame: dropdownFrame)
        
        tableView = UITableView(frame: dropdownFrame)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.layer.cornerRadius = 12
        tableView?.separatorStyle = .none
        
        superview?.addSubview(tableView!)
        // Установка текста кнопки в выбранную игру
        
        if let superview = superview {
            tableView?.center.x = superview.bounds.midX
        }
        
        setTitle(gameList.first, for: .normal)
    }
    
    func hideDropdown() {
        tableView?.removeFromSuperview()
        tableView = nil
    }
}

extension DropdownButton: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = gameList[indexPath.row]
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = gameList[indexPath.row]
        setTitle(selectedGame, for: .normal)
        delegate?.gameButtonDidTap(game: selectedGame)
        hideDropdown()
    }
}
