import UIKit
import SnapKit

class NumberCollectionView: UIView, UICollectionViewDelegate {
    weak var delegate: FinishGameDelegate?
    private var messegeView: UserMistakeView!
    var collectionView: UICollectionView!
    var numberMassive = [String]()
    var firstCellForCheck: UICollectionViewCell?
    var secondCellForCheck: UICollectionViewCell?
    var highlightedCells: [IndexPath] = []
    var selectedCells: [IndexPath] = []
    var allCells: [IndexPath] = []
    var allCellsMassive: [Bool] = []
    var firstLabel = String()
    var secondLabel = String()
    var counter = 0
    var posibleMove: [IndexPath] = []
    var isshowMessageAlert = false
    
    func setupView(massive: [String]) {
        numberMassive = massive
        
        for i in 0..<numberMassive.count {
            allCells.append(IndexPath(row: i, section: 0))
            allCellsMassive.append(true)
        }
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = layout
        collectionView.register(NumbersCollectionViewCell.self, forCellWithReuseIdentifier: "NumbersCollectionViewCell")
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension NumberCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumbersCollectionViewCell", for: indexPath) as? NumbersCollectionViewCell else {
            fatalError("Unable to dequeue NumbersCollectionViewCell")
        }
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: NumbersCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.setupLabel()
        cell.numberLabel.text = numberMassive[indexPath.row]
        cell.backgroundColor = .systemGray
        
        if !allCellsMassive[indexPath.row] {
            cell.hide()
            cell.isUserInteractionEnabled = false
        } else if posibleMove.contains(indexPath) {
            cell.isUserInteractionEnabled = true
            cell.helpSelected()
        } else {
            cell.isUserInteractionEnabled = true
            cell.deselect()
        }
        
//        if selectedCells.contains(indexPath) {
//            cell.hide()
//            cell.numberLabel.textColor = .lightGray
//            cell.isUserInteractionEnabled = false
//        } else if posibleMove.contains(indexPath) {
//            cell.isUserInteractionEnabled = true
//            cell.helpSelected()
//        } else {
//            cell.isUserInteractionEnabled = true
//            cell.deselect()
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell else {
            return
        }

        guard highlightedCells.count <= 2 else {
            let firstCell = collectionView.cellForItem(at: highlightedCells[0]) as? NumbersCollectionViewCell
            let secondCell = collectionView.cellForItem(at: highlightedCells[1]) as? NumbersCollectionViewCell
            firstCell?.deselect()
            secondCell?.deselect()
            highlightedCells.removeAll()
            return
        }
        
        if let index = highlightedCells.firstIndex(of: indexPath) {
            highlightedCells.remove(at: index)
            cell.deselect()
        } else {
            cell.select()
            highlightedCells.append(indexPath)
            print("Массив выделеных ячеек: \(highlightedCells)")
        }
        
        if highlightedCells.count == 2 {
            checkSelectedCells(highlightedCells[0], highlightedCells[1])
        }
    }
    
    func checkSelectedCells(_ firstIndexPath: IndexPath, _ secondIndexPath: IndexPath) {
        let firstCell = collectionView.cellForItem(at: firstIndexPath) as? NumbersCollectionViewCell
        let secondCell = collectionView.cellForItem(at: secondIndexPath) as? NumbersCollectionViewCell

        guard firstCell != secondCell else {
            return
        }
        
        guard comparisonСell(firstCell: getIndexAllCell(indexPath: firstIndexPath), secondCell: getIndexAllCell(indexPath: secondIndexPath))  else {
            firstCell?.deselect()
            secondCell?.deselect()
            highlightedCells.removeAll()
            return
        }
        
        guard let firstText = firstCell?.numberLabel.text,
              let firstNumber = Int(firstText),
              let secondText = secondCell?.numberLabel.text,
              let secondNumber = Int(secondText) else {
            return
        }

        let sum = firstNumber + secondNumber
        
        if checkingSumEqualityConditions(sum: sum, first: firstNumber, second: secondNumber),
           let firstCell = firstCell,
           let secondCell = secondCell {
            firstCell.hide()
            secondCell.hide()
            firstCell.isUserInteractionEnabled = false
            secondCell.isUserInteractionEnabled = false
            
            if !selectedCells.contains(firstIndexPath) {
                allCellsMassive[firstIndexPath.row] = false
                selectedCells.append(firstIndexPath)
            }
            
            if !selectedCells.contains(secondIndexPath) {
                selectedCells.append(secondIndexPath)
                allCellsMassive[secondIndexPath.row] = false
            }
            
//            for i in selectedCells {
//                if let cell = collectionView.cellForItem(at: i) as? NumbersCollectionViewCell {
//                    cell.hide()
//                    cell.numberLabel.textColor = .lightGray
//                    cell.isSelected = true
//                }
//            }
            
            if checkFinishGame() {
                delegate?.alertResult()
            }
        } else {
            firstCell?.deselect()
        }
        
        highlightedCells.removeAll()
        posibleMove.removeAll()
        
        if !findEmptyRanges().isEmpty {
            deleteEmptyRanges(findEmptyRanges())
        }
        
    }
    
    func getIndexAllCell(indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<allCells.count {
            if allCells[i] == indexPath {
                index = i
            }
        }
        
        return index
    }
    
    func checkSelectedCell() {
        for i in allCells {
            if let cell = collectionView.cellForItem(at: i) as? NumbersCollectionViewCell,
               cell.isUserInteractionEnabled,
               selectedCells.contains(i) {
                var updatedSelectedCells = selectedCells
                updatedSelectedCells.removeAll { $0 == i }
                selectedCells = updatedSelectedCells
            }
        }
    }
    
    func getSelectedCells() -> [IndexPath] {
        selectedCells.removeAll()
        var newSelectedCell = [IndexPath]()
        for i in 0..<allCellsMassive.count {
            if !allCellsMassive[i] {
                newSelectedCell.append(allCells[i])
            }
        }
        return newSelectedCell
    }
    
    func getNumberCell(indexPath: IndexPath) -> Int? {
        if let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell {
            if let numberText = cell.numberLabel.text {
                return Int(numberText)
            }
        }
        return nil
    }

    func findEmptyRanges() -> [ClosedRange<Int>] {
        let step = 9
        var firstIndex = 0
        var lastIndex = 8
        var emptyRanges: [ClosedRange<Int>] = []
        
        while lastIndex < allCells.count {
            let range = firstIndex...lastIndex
            let cellsInRange = allCells[range]
            
            if cellsInRange.allSatisfy({ selectedCells.contains($0) }) {
                emptyRanges.append(range)
            }
            
            firstIndex += step
            lastIndex += step
        }
        
        return emptyRanges
    }
    
    func deleteEmptyRanges(_ emptyRanges: [ClosedRange<Int>]) {
        emptyRanges.reversed().forEach { range in
            numberMassive.removeSubrange(range)
            allCells.removeSubrange(range)
            allCellsMassive.removeSubrange(range)
            
            let indexPathsToRemove = range.map { IndexPath(item: $0, section: 0) }
            collectionView.deleteItems(at: indexPathsToRemove)
        }
//
        allCells = getAllCellIndexPaths()
        selectedCells = getSelectedCells()
//        collectionView.reloadData()
    }

    func newAllCells() -> [IndexPath] {
        allCells.removeAll()
        var newCellsMassive = [IndexPath]()
        for i in 0..<allCellsMassive.count {
            newCellsMassive.append(IndexPath(index: i))
        }
        return newCellsMassive
    }
    
    func getAllCellIndexPaths() -> [IndexPath] {
        guard let collectionView = collectionView else {
            return []
        }
        
        var allIndexPaths: [IndexPath] = []
        
        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                allIndexPaths.append(indexPath)
            }
        }
        
        return allIndexPaths.sorted { $0.row < $1.row }
    }


    
    func checkingSumEqualityConditions (sum: Int, first: Int, second: Int) -> Bool {
        if sum == 10 || first == second {
            return true
        } else {
            return false
        }
    }

    func comparisonСell(firstCell: Int, secondCell: Int) -> Bool {
        let maxTag = max(firstCell, secondCell)
        let minTag = min(firstCell, secondCell)
        let differenceNumbers = maxTag - minTag
        
//        else if differenceNumbers % 10 == 0 {
//            return testingIncrementsTen(min: minTag, max: maxTag)
//        } else if differenceNumbers % 8 == 0 {
//            return testingIncrementsEight(min: minTag, max: maxTag)
//        }
        
        if differenceNumbers == 1 {
            return true
        } else if differenceNumbers % 9 == 0 {
            return checkMassiveRow(min: minTag, max: maxTag)
        } else {
            return checkMassiveString(min: minTag, max: maxTag)
        }
    }
    
    func checkMassiveString(min: Int, max: Int) -> Bool {
            for i in min + 1..<max where !selectedCells.contains(allCells[i]) {
                return false
            }
            return true
        }
    
    func checkMassiveRow(min: Int, max: Int) -> Bool {
        for index in stride(from: min + 9, to: max - 1, by: 9) {
            if !selectedCells.contains(allCells[index]) {
                return false
            }
        }
        return true
    }

//    func testingIncrementsEight(min: Int, max: Int) -> Bool {
//        for index in stride(from: min + 8, to: max - 1, by: 8) {
//            if !selectedCells.contains(allCells[index])  {
//                return false
//            }
//        }
//        return true
//    }
//    
//    func testingIncrementsTen(min: Int, max: Int) -> Bool {
//        
//        for index in stride(from: min + 10, to: max - 1, by: 10) {
//            if !selectedCells.contains(allCells[index]) {
//                return false
//            }
//        }
//        return true
//    }
    
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
        var newIndexPaths: [IndexPath] = []
        
        for i in allCells {
            if !selectedCells.contains(i) {
                let newNumber = numberMassive[i.row]
                numberMassive.append(newNumber)
                let newIndexPath = IndexPath(row: numberMassive.count - 1, section: 0)
                newIndexPaths.append(newIndexPath)
                allCellsMassive.append(true)
            }
            
        }
        
        allCells.append(contentsOf: newIndexPaths)
        collectionView.reloadData()
    }

    func showPossibleMoveWhenPossibleMoveWasTapped() {
        for i in 0..<allCells.count {
            for j in 0..<allCells.count {
                guard i != j, !selectedCells.contains(allCells[i]), !selectedCells.contains(allCells[j]) else {
                    continue
                }
                
                if comparisonСell(firstCell: i, secondCell: j) {
                    if let firstNumber = getNumberCell(indexPath: allCells[i]),
                       let secondNumber = getNumberCell(indexPath: allCells[j]),
                       checkingSumEqualityConditions(sum: firstNumber + secondNumber, first: firstNumber, second: secondNumber) {
                        
                        if let firstCell = collectionView.cellForItem(at: allCells[i]) as? NumbersCollectionViewCell,
                           let secondCell = collectionView.cellForItem(at: allCells[j]) as? NumbersCollectionViewCell {

                            firstCell.helpSelected()
                            secondCell.helpSelected()
                            posibleMove.append(allCells[i])
                            posibleMove.append(allCells[j])
                            
                            print(posibleMove)
                        }
                        return
                    }
                }
            }
        }

        if posibleMove.isEmpty {
            print(allCells.count)
            posibleMove.removeAll()
            createAlertMessage()
        }
    }

    func checkFinishGame() -> Bool {
        return !allCellsMassive.contains(true)
    }
    
    func clearCollectionView() {
        numberMassive.removeAll()
        allCells.removeAll()
        selectedCells.removeAll()
        collectionView.reloadData()
    }
}

extension NumberCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth * 0.10
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension NumberCollectionView {
    func createAlertMessage() {
        guard messegeView == nil else {
            return
        }
        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topPadding = window?.safeAreaInsets.top ?? 0
        let alertViewWidth: CGFloat = self.frame.size.width / 1.1
        let alertViewHeight: CGFloat = self.frame.size.width * 0.2
        
        messegeView.createUI(messages: "Нет возможных ходов для удаления из поля")
        messegeView.frame = CGRect(x: (window!.frame.width - alertViewWidth) / 2,
                                   y: -alertViewHeight,
                                   width: alertViewWidth,
                                   height: alertViewHeight)
        
        messegeView.layer.cornerRadius = 10
        messegeView.layer.shadowOpacity = 0.2
        messegeView.layer.shadowRadius = 5
        messegeView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        UIApplication.shared.keyWindow?.addSubview(messegeView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.messegeView.frame.origin.y = topPadding // конечное положение
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {
                self.messegeView.frame.origin.y = -alertViewHeight // начальное положение
            }, completion: { _ in
                self.messegeView.removeFromSuperview()
                self.isshowMessageAlert = false
                self.messegeView = nil
            })
        }
    }
}
