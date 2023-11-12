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
    var firstLabel = String()
    var secondLabel = String()
    var counter = 0
    var posibleMove: [IndexPath] = []
    var isshowMessageAlert = false
    
    func setupView(massive: [String]) {
        numberMassive = massive
        
        for i in 0..<numberMassive.count {
            allCells.append(IndexPath(row: i, section: 0))
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
        return numberMassive.count
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
        if selectedCells.contains(indexPath) {
            cell.backgroundColor = .systemGray.withAlphaComponent(0.2)
            cell.isUserInteractionEnabled = false
            return cell
        } else if posibleMove.contains(indexPath) {
            cell.helpSelected()
            cell.isUserInteractionEnabled = true
            return cell
        }
        else {
            cell.backgroundColor = .systemGray.withAlphaComponent(1)
            cell.isUserInteractionEnabled = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NumbersCollectionViewCell else {
            return
        }
        
        if let index = highlightedCells.firstIndex(of: indexPath) {
            highlightedCells.remove(at: index)
            cell.deselect()
        } else {
            cell.select()
            highlightedCells.append(indexPath)
            print("Массив выделеных ячеек: \(highlightedCells)")
            checkSelectedCells()
        }
    }
    
    func checkingSumEqualityConditions (sum: Int, first: Int, second: Int) -> Bool {
        if sum == 10 || first == second {
            return true
        } else {
            return false
        }
    }
    
    func checkSelectedCells() {
        guard highlightedCells.count == 2 else {
            return
        }
        
        let firstCell = collectionView.cellForItem(at: highlightedCells[0]) as? NumbersCollectionViewCell
        let secondCell = collectionView.cellForItem(at: highlightedCells[1]) as? NumbersCollectionViewCell
        
        guard firstCell != secondCell else {
            return
        }
        
        guard comparisonСell(firstCell: highlightedCells[0].row, secondCell: highlightedCells[1].row) else {
            firstCell?.deselect()
            secondCell?.deselect()
            highlightedCells.removeAll()
            return
        }
        
        let firstNumber = Int(numberMassive[highlightedCells[0].row]) ?? 0
        let secondNumber = Int(numberMassive[highlightedCells[1].row]) ?? 0
        
        let sum = Int(numberMassive[highlightedCells[0].row])! + Int(numberMassive[highlightedCells[1].row])!
        
        if checkingSumEqualityConditions(sum: sum, first: firstNumber, second: secondNumber) {
            firstCell?.hide()
            secondCell?.hide()
            firstCell?.isUserInteractionEnabled = false
            secondCell?.isUserInteractionEnabled = false
            
            if !selectedCells.contains(highlightedCells[0]) {
                selectedCells.append(highlightedCells[0])
            }
            
            if !selectedCells.contains(highlightedCells[1]) {
                selectedCells.append(highlightedCells[1])
            }
            
            print("Массив использованых ячеек: \(selectedCells)")
            //            сheckingEmptyLines()
            if checkFinishGame() {
                delegate?.alertResult()
            }
            
        } else {
            firstCell?.deselect()
            secondCell?.deselect()
        }
        highlightedCells.removeAll()
        posibleMove.removeAll()
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
        if (max - min) % 9 == 0 {
            for index in stride(from: min + 9, to: max - 1, by: 9) where !selectedCells.contains(allCells[index]) {
                return false
            }
            return true
        } else {
            return false
        }
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
    
    //    func сheckingEmptyLines() {
    //        for i in mass {
    //            let range = i[0]...i[1]
    //            if collectionViewCellMassive[range].contains(where: { !$0.isUserInteractionEnabled }) {
    //                var indexPathsToRemove: [IndexPath] = []
    //                for j in range {
    //                    indexPathsToRemove.append(IndexPath(row: j, section: 0))
    //                }
    //                collectionView.performBatchUpdates({
    //                    collectionView.deleteItems(at: indexPathsToRemove)
    //                }, completion: nil)
    //                break
    //            }
    //        }
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
        for i in allCells {
            if !selectedCells.contains(i) {
                numberMassive.append(numberMassive[i.row])
                let indexPath = IndexPath(row: numberMassive.count - 1, section: 0)
                allCells.append(indexPath)
                collectionView.insertItems(at: [indexPath])
            }
        }
    }
    
//    func showPossibleMoveWhenPossibleMoveWasTapped() {
//        for i in allCells {
//            if !selectedCells.contains(i) {
//                for j in allCells where i != j {
//                    if comparisonСell(firstCell: i.row, secondCell: j.row),
//                       let firstNumber = Int(numberMassive[i.row]),
//                       let secondNumber = Int(numberMassive[j.row]),
//                       checkingSumEqualityConditions(sum: firstNumber + secondNumber, first: firstNumber, second: secondNumber) {
//                        
//                        if let firsCell = collectionView.cellForItem(at: i) as? NumbersCollectionViewCell,
//                           let secondCell = collectionView.cellForItem(at: j) as? NumbersCollectionViewCell {
//                            firsCell.helpSelected()
//                            secondCell.helpSelected()
//                        }
//                        return // Прекращение работы функции
//                    }
//                }
//            }
//        }
//    }
    
    func showPossibleMoveWhenPossibleMoveWasTapped() {
        for i in allCells {
            for j in allCells {
                guard i != j, !selectedCells.contains(i), !selectedCells.contains(j) else {
                    continue
                }
                
                if comparisonСell(firstCell: i.row, secondCell: j.row),
                   let firstNumber = Int(numberMassive[i.row]),
                   let secondNumber = Int(numberMassive[j.row]),
                   checkingSumEqualityConditions(sum: firstNumber + secondNumber, first: firstNumber, second: secondNumber) {
                    
                    if let firsCell = collectionView.cellForItem(at: i) as? NumbersCollectionViewCell,
                       let secondCell = collectionView.cellForItem(at: j) as? NumbersCollectionViewCell {
                        firsCell.helpSelected()
                        secondCell.helpSelected()
                        posibleMove.append(i)
                        posibleMove.append(j)
                    }
                    return // Прекращение работы функции
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
        return allCells.count == selectedCells.count
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
        let itemWidth = collectionViewWidth * 0.10 // 10% от ширины collectionView
        let itemHeight = itemWidth // Предполагаем, что ячейка квадратная
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