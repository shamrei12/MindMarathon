//
//  StatiscticsCollectionView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class StatiscticsCollectionView: UICollectionView {
    
    var dataMassive = ["", "", ""]
    private let descriptionMassive = ["в игре", "Любимая игра", "Серия побед"]
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: bounds.width / 3.2, height: bounds.height) // Размер элемента
        }
    }
    
    private func commonInit() {
        setup()
        self.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: "StatisticsCollectionViewCell")
    }
    
    func setup() {
        self.dataSource = self
        //        self.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.collectionViewLayout = layout
        self.backgroundColor = .clear
    }
}

// Расширение для реализации методов UICollectionViewDataSource
extension StatiscticsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataMassive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as? StatisticsCollectionViewCell else {
            fatalError("Unable to dequeue AnimalCollectionViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: StatisticsCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {

        cell.setup(data: dataMassive[indexPath.row], description: descriptionMassive[indexPath.row])

        return cell
    }
}



extension StatiscticsCollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 60)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            return UIEdgeInsets.zero
        }
    }
}
