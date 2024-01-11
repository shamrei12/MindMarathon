//
//  RatingTableView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 6.01.24.
//

import UIKit


class RatingTableView: UITableView {
    let firebase = FirebaseData()
    var userLists = [ProfileManager]()
    private let massiveLabel = ["Приюты для животных", "Ветклиники", "Магазины"]

    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        getUserList()
        setup()
        self.register(RatingTableViewCell.self, forCellReuseIdentifier: "RatingTableViewCell")
    }
    
    func setup() {
        self.dataSource = self
//        self.delegate = self
        self.separatorStyle = .none
        self.backgroundColor = .clear
    }
    
    func getUserList() {
        firebase.getUserProfiles { profile in
            DispatchQueue.global().async {
                DispatchQueue.main.sync {
                    self.userLists = profile
                    self.userLists.sort {$0.userScore > $1.userScore}
                    self.reloadData()
                }
            }
        }
    }
}

extension RatingTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RatingTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as? RatingTableViewCell {
                 cell = reuseCell
             } else {
                 cell = RatingTableViewCell()
             }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: RatingTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        cell.setupCell(data: userLists[indexPath.row], rating: indexPath.row + 1)
        return cell
    }
}

//extension RatingTableView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("ldfjof")
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 227
//    }
//}
