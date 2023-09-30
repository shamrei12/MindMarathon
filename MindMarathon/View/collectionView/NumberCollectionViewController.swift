import UIKit
import SnapKit

class NumberCollectionView: UIView, UICollectionViewDelegate {
    weak var delegate: FinishGameDelegate?
    var collectionView: UICollectionView!
    var numberMassive = [String]()
    var firstCellForCheck: UICollectionViewCell?
    var secondCellForCheck: UICollectionViewCell?
    var collectionViewCellMassive = [NumbersCollectionViewCell]()
    var selectedCells: [IndexPath] = []
    var massiveSelectedCells: [IndexPath] = []
    var firstLabel = String()
    var secondLabel = String()
    var counter = 0
    
    func setupView(elementMassive: [String]) {
        numberMassive = elementMassive
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumbersCollectionViewCell", for: indexPath) as? NumbersCollectionViewCell else {
            fatalError("Unable to dequeue NumbersCollectionViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: NumbersCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.numberLabel.text = numberMassive[indexPath.row]
        cell.tag = indexPath.row
        cell.backgroundColor = .systemGray
        
        if !collectionViewCellMassive.contains(where: { $0 === cell }) {
            collectionViewCellMassive.append(cell)
        }
        
        if selectedCells.contains(indexPath) {
            cell.hide()
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell else {
            return
        }
        
        if !cell.isSelected {
            cell.deselect()
            if let index = selectedCells.firstIndex(of: indexPath) {
                selectedCells.remove(at: index)
            }
        } else {
            cell.select()
            selectedCells.append(indexPath)
            print(selectedCells)
            checkSelectedCells()
        }
    }

    func checkSelectedCells() {
        guard selectedCells.count == 2 else { return }
        
        let firstCell = collectionViewCellMassive[selectedCells[0].row]
        let secondCell = collectionViewCellMassive[selectedCells[1].row]
        
        guard firstCell != secondCell else {
            return
        }
        
        guard comparisonСell(firstCell: firstCell.tag, secondCell: secondCell.tag) else {
            firstCell.deselect()
            secondCell.deselect()
            selectedCells.removeAll()
            return
        }
        
        let firstNumber = Int(numberMassive[selectedCells[0].row]) ?? 0
        let secondNumber = Int(numberMassive[selectedCells[1].row]) ?? 0
        
            
            
        let sum = Int(numberMassive[selectedCells[0].row])! + Int(numberMassive[selectedCells[1].row])!
        
        if sum == 10 || firstNumber == secondNumber {
            firstCell.hide()
            secondCell.hide()
            firstCell.isUserInteractionEnabled = false
            secondCell.isUserInteractionEnabled = false
            massiveSelectedCells.append(selectedCells[0])
            massiveSelectedCells.append(selectedCells[1])
        } else {
            firstCell.deselect()
            secondCell.deselect()
        }
        selectedCells.removeAll()
    }
    
        func comparisonСell(firstCell: Int, secondCell: Int) -> Bool {
            let maxTag = max(firstCell, secondCell)
            let minTag = min(firstCell, secondCell)
    
            switch maxTag - minTag {
            case 1: return true
            case 9: return true
            default:
                return checkMassiveString(min: minTag, max: maxTag) || checkMassiveRow(min: minTag, max: maxTag)
            }
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
            for index in stride(from: min + 9, to: max - 1, by: 9) {
                if collectionViewCellMassive[index].isUserInteractionEnabled == true {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func coloringCell(cell: UICollectionViewCell) {
        cell.backgroundColor = .red
    }
    
    func clearCell(firstCell: UICollectionViewCell, secondCell: UICollectionViewCell) {
        firstCell.backgroundColor = .systemGray
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
    
    
    func createMassiveWhenAddbuttonWasTapped() {
        for i in 0..<collectionViewCellMassive.count {
            if collectionViewCellMassive[i].isUserInteractionEnabled {
                numberMassive.append(numberMassive[i])
                collectionView.insertItems(at: [IndexPath(row: numberMassive.count - 1, section: 0)])
            }
        }
    }
    
    func checkFinishGame() -> Bool {
        return !collectionViewCellMassive.contains { $0.isUserInteractionEnabled }
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
        let itemWidth = collectionViewWidth * 0.1 // 10% от ширины collectionView
        let itemHeight = itemWidth // Предполагаем, что ячейка квадратная
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
