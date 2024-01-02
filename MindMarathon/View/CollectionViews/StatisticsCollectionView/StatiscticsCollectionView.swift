//
//  StatiscticsCollectionView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.11.23.
//

import UIKit

class StatiscticsCollectionView: UICollectionView {
    
    var dataMassive = [String]()
    var descriptionMassive = [String]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = CGSize(width: bounds.width / 2, height: bounds.height / 1)
//            layout.minimumLineSpacing = 5
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            
//        }
//    }
    
    private func commonInit() {
        setup()
        self.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: "StatisticsCollectionViewCell")
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor(named: "gameElementColor")
        self.layer.cornerRadius = 12
        self.scrollsToTop = false
        self.isScrollEnabled = false
    }
}

extension StatiscticsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataMassive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as? StatisticsCollectionViewCell else {
            fatalError("Unable to dequeue StatisticsCollectionViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: StatisticsCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.setup(data: dataMassive[indexPath.row], description: descriptionMassive[indexPath.row])
        return cell
    }
}

extension StatiscticsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        let height = collectionView.bounds.height / 2.2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
