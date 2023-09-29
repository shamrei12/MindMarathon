import UIKit
import SnapKit

class NumberCollectionView: UIView, UICollectionViewDelegate {
    weak var delegate: FinishGameDelegate?
    var collectionView: UICollectionView!
    var numberMassive = [String]()
    var firstCellForCheck: UICollectionViewCell?
    var secondCellForCheck: UICollectionViewCell?
    var collectionViewCellMassive = [UICollectionViewCell]()
    var firstLabel = String()
    var secondLabel = String()
    
    func setupView(elementMassive: [String]) {
        numberMassive = elementMassive
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "NumbersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NumbersCollectionViewCell")
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension NumberCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberMassive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: NumbersCollectionViewCell
        if let reuseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumbersCollectionViewCell", for: indexPath) as? NumbersCollectionViewCell {
            cell = reuseCell
        } else {
            cell = NumbersCollectionViewCell()
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: NumbersCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.numberLabel.text = numberMassive[indexPath.row]
        cell.tag = indexPath.row
        cell.backgroundColor = .systemGray
        collectionViewCellMassive.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if firstCellForCheck == nil && firstLabel == "" {
                firstCellForCheck = cell
                coloringCell(cell: (firstCellForCheck!))
                if let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell {
                    firstLabel = cell.numberLabel.text ?? ""
                }
            } else if secondCellForCheck == nil && secondLabel == "" {
                secondCellForCheck = cell
                coloringCell(cell: secondCellForCheck!)
                if let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell {
                    secondLabel = cell.numberLabel.text ?? ""
                }
                if firstCellForCheck != nil && secondCellForCheck != nil {
                    checResult(firstTag: firstCellForCheck!.tag, firstLabel: firstLabel, secondTag: secondCellForCheck!.tag, secondLabel: secondLabel)
                }
            }
        }
    }
    
    func coloringCell(cell: UICollectionViewCell) {
        cell.backgroundColor = .red
    }
    
    func clearCell(firstCell: UICollectionViewCell, secondCell: UICollectionViewCell) {
        firstCell.layer.borderWidth = 0
        firstCell.layer.borderColor = UIColor.clear.cgColor
        firstCell.backgroundColor = .systemGray
        
        secondCell.layer.borderWidth = 0
        secondCell.layer.borderColor = UIColor.clear.cgColor
        secondCell.backgroundColor = .systemGray
        
        clearSetupCell()
    }
    
    func clearSetupCell() {
        firstCellForCheck = nil
        secondCellForCheck = nil
        
        firstLabel = ""
        secondLabel = ""
    }
    
    func hidenCell(cell: UICollectionViewCell) {
        cell.backgroundColor = .systemGray.withAlphaComponent(0.2)
        cell.isUserInteractionEnabled = false
    }
    
    func checkMassiveString(min: Int, max: Int) -> Bool {
        for i in min + 1..<max {
            if collectionViewCellMassive[i].isUserInteractionEnabled == true {
                return false
            }
        }
        return true
    }
    
    func checkMassiveRow(min: Int, max: Int) -> Bool {
        if (max - min) % 9 == 0 {
            var index = 0
            for i in stride(from: min + 9, to: max - 1, by: 9) {
                if collectionViewCellMassive[i].isUserInteractionEnabled == true {
                    return false
                }
            }
        } else {
            return false
        }

        return true
    }
    
    func comparisonСell(firstCell: UICollectionViewCell, secondCell: UICollectionViewCell) -> Bool {
        
        let maxTag = max(firstCell.tag, secondCell.tag)
        let minTag = min(firstCell.tag, secondCell.tag)

        if minTag + 1 == maxTag {
            return true
        } else if minTag + 9 == maxTag {
            return true
        } else {
            if checkMassiveString(min: minTag, max: maxTag) || checkMassiveRow(min: minTag, max: maxTag) {
                return true
            }
        }
        return false
    }
    
    func createMassiveWhenAddbuttonWasTapped() {
        for i in 0..<collectionViewCellMassive.count {
            if collectionViewCellMassive[i].isUserInteractionEnabled {
                numberMassive.append(numberMassive[i])
                collectionView.insertItems(at: [IndexPath(row: numberMassive.count - 1, section: 0)])
                
            }
        }
    }
    
    func checResult(firstTag: Int, firstLabel: String, secondTag: Int, secondLabel: String) {
        let firstCell = collectionViewCellMassive[firstTag]
        let secondCell = collectionViewCellMassive[secondTag]
        
        guard firstCell != secondCell else {
            clearCell(firstCell: firstCell, secondCell: secondCell)
            return
        }
        
        if comparisonСell(firstCell: firstCell, secondCell: secondCell) {
            if firstLabel == secondLabel {
                hidenCell(cell: firstCell)
                hidenCell(cell: secondCell)
                clearSetupCell()
                if checkFinishGame() {
                    delegate?.alertResult()
                }
                
            } else if Int(firstLabel)! + Int(secondLabel)! == 10 {
                hidenCell(cell: firstCell)
                hidenCell(cell: secondCell)
                clearSetupCell()
                if checkFinishGame() {
                    delegate?.alertResult()
                }
            } else {
                clearCell(firstCell: firstCell, secondCell: secondCell)
            }
        } else {
            clearCell(firstCell: firstCell, secondCell: secondCell)
        }
    }
    
    func checkFinishGame() -> Bool {
        let containsEnabledButton = collectionViewCellMassive.contains { $0.isUserInteractionEnabled }
        if containsEnabledButton {
            return false
        } else {
            return true
        }
    }
    
    func clearCollectionView() {
        numberMassive = []
        collectionViewCellMassive = []
        collectionView.reloadData()
    }
}

extension NumberCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth * 0.1 // 8% от ширины collectionView
        let itemHeight = itemWidth // Предполагаем, что ячейка квадратная
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
