//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit

class ListGamesViewController: UIViewController {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let gameList: [Game] = ListGamesViewController.createGames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр".localize()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        
        collectionView.register(UINib(nibName: "ListGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListGameCollectionViewCell")
        
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.95)
            maker.height.equalTo(view.safeAreaLayoutGuide)
        }
        createUI()
    }
    
    static func createGames() -> [Game] {
        return [BullCowGame(title: "Быки и Коровы".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the mystery number".localize(), rules: "1. Вы выбираете количество цифр в загаданном числе и нажимаете кнопку \"Play\". Игру можно поставить на паузу.\n\n2. Вам предстоит угадать число, выбранное компьютером. Число может начинаться с нуля.\n\n3. Вы делаете попытку, вводя число.\n\n4. Компьютер сообщает вам, сколько цифр в вашей попытке совпадают с загаданным числом и находятся на том же месте (такие цифры называются \"быками\"), а также сколько цифр совпадают с загаданным числом, но находятся на другом месте (такие цифры называются \"коровами\").\n\n5. Вы используете эту информацию для следующей попытки, и так далее, пока не угадаете число.\n\n6. Игра продолжается, пока вы не угадаете загаданное число.\n\n7. Вы можете начать новую игру после окончания предыдущей.".localize(), gameImage: "BullCow"), SlovusGame(title: "Словус".localize(), createdBy: "Aliaksei Shamrei", descripton: "Guess the word in 6 moves".localize(), rules: "1. Вы должны угадать загаданное компьютером слово. Слово может содержать повторяющиеся буквы. Вы делаете попытку, вводя слово.\n\n2. Компьютер проверяет каждую букву в вашей попытке и выделяет ее цветом:\n- Если буква выделена зеленым, то это значит, что буква есть в слове и стоит на своем месте.\n- Если буква выделена желтым, то это значит, что буква есть в слове, но не на своем месте.\n\n3. Вы получаете обратную связь от компьютера и используете эту информацию, чтобы сделать следующую попытку.\n\n4. Вы можете сделать до 6 попыток, чтобы угадать слово.\n\n5. Если вы угадали слово за меньшее количество попыток, то вы победили.\n6. Если вы не угадали слово за 6 попыток, то игра завершается.\n\n7. Вы можете начать новую игру после окончания предыдущей.".localize(), gameImage: "slovusImage"), FloodFillGame(title: "Заливка".localize(), createdBy: "Aliaksei Shamrei", descripton: "Paint the field one color".localize(), rules: "1. На доске есть ячейки разных цветов. Цвета могут повторяться.\n2. Игрок начинает с верхнего левого угла и прогрессирует построчно, выбирая один из цветных квадратов в нижней части экрана.\n\n3. Когда игрок изменяет текущий цвет области, каждый соседний квадрат того же цвета также изменяет цвет.\n4. Цель игры - закрасить все ячейки на доске одним цветом.\n5. Игра заканчивается, когда все ячейки на доске станут одного цвета.\n6. Игрок должен закрашивать ячейки таким образом, чтобы он мог закрасить все ячейки на доске.\n".localize(), gameImage: "floodFillImage"), TicTakToeGame(title: "Крестики Нолики".localize(), createdBy: "Nikita Shakalov", descripton: "Line up three identical symbols".localize(), rules: "1. На доске есть квадрат из 3x3 клеток.\n\n2. Игрок играет против компьютера. Игрок играет крестиками, компьютер - ноликами.\n\n3. Цель игры - собрать три своих символа в ряд (по горизонтали, вертикали или диагонали).\n\n4. Игроки ходят по очереди, ставя свой символ на пустую клетку.\n\n5. Игрок может ставить свой символ только на пустую клетку.\n\n6. Игра заканчивается, когда один из игроков собрал три своих символа в ряд или когда все клетки заполнены, и ни один игрок не собрал три своих символа в ряд.\n\n7. Если игрок собрал три своих символа в ряд, то он побеждает, если же ни один игрок не собрал три своих символа в ряд, то игра заканчивается вничью.".localize(), gameImage: "tikTakToeImage"), BinarioGame(title: "Бинарио".localize(), createdBy: "Aliaksei Shamrei", descripton: "Arrange the blue and red blocks".localize(), rules: "1. В сетке есть клетки разных цветов: красные, синие и пустые клетки.\n\n2. Цель игры - заполнить всю сетку так, чтобы выполнились следующие условия:\n- Ни одна строка или столбец не должны содержать повторяющиеся цвета.\n- Каждая строка и столбец должны содержать одинаковое количество красных и синих клеток.\n\n3. Игрок может заполнять сетку, нажимая на клетки, чтобы изменить их цвет.\n\n4. Если все правила выполняются и сетка полностью заполнена, игрок побеждает.\n\n".localize(), gameImage: "binarioImage"), NumbersGame(title: "Цифры".localize(), createdBy: "Aliaksei Shamrei", descripton: "Remove all the numbers from the playing field".localize(), rules: "1. На игровом поле представлена сетка, состоящая из ячеек. В каждой ячейке расположена цифра от 0 до 9.\n2. Цель игры - удалить все цифры с поля, соединяя пары цифр, сумма которых составляет 10.\n3. Игрок может соединять цифры, если они находятся рядом друг с другом горизонтально или вертикально.\n4. Для удаления цифр, игрок должен выбрать пару цифр, сумма которых равна 10, и нажать на них. После этого цифры будут удалены с поля.\n5. Игрок может соединять только соседние цифры, которые находятся рядом горизонтально или вертикально.\n6. Игрок может получить бонусные очки, если удалит несколько пар цифр подряд без промежутков.".localize(), gameImage: "numbersImage")]
    }

    func createUI() {
        self.view.backgroundColor = UIColor(named: "viewColor")
    }
    
    @objc
    func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    func selected(game: Game) {
        let viewController: UIViewController
        switch game.title {
        case "Быки и Коровы".localize():
            let viewModel = BullCowViewModel(game: game)
            viewController = BullCowViewController(viewModel: viewModel)
        case "Словус".localize():
            let viewModel = SlovusViewModel(game: game)
            viewController = SlovusGameViewController(viewModel: viewModel)
        case "Заливка".localize():
            let viewModel = FloodFillViewModel(game: game)
            viewController = FloodFillViewController(viewModel: viewModel)
        case "Крестики Нолики".localize():
            let viewModel = TicTacToeViewModel(game: game)
            viewController = TicTacToeViewController(viewModel: viewModel)
        case "Бинарио".localize():
            let viewModel = BinarioViewModel(game: game)
            viewController = BinarioViewController(viewModel: viewModel)
        default:
            let viewModel = NumbersViewModel(game: game)
            viewController = NumbersViewController(viewModel: viewModel)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ListGamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ListGameCollectionViewCell
        if let reuseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListGameCollectionViewCell", for: indexPath) as? ListGameCollectionViewCell {
            cell = reuseCell
        } else {
            cell = ListGameCollectionViewCell()
        }
        
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: ListGameCollectionViewCell, for indexPath: IndexPath) -> UICollectionViewCell {
        cell.gameNameLabel.text = gameList[indexPath.row].title
        cell.aboutGameLabel.text = gameList[indexPath.row].descripton
        cell.gameImageView.image = getImage(index: indexPath.row)
        return cell
    }
    
    func getImage(index: Int) -> UIImage {
        switch index {
        case 0: return UIImage(named: "bullCowImage")!
        case 1: return UIImage(named: "slovusImage")!
        case 2: return UIImage(named: "floodFillImage")!
        case 3: return UIImage(named: "tikTakToeImage")!
        case 4: return UIImage(named: "binarioImage")!
        default: return UIImage(named: "numbersImage")!
        }
    }
}

extension ListGamesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth * 0.49 // 10% от ширины collectionView
        let itemHeight = itemWidth * 1.45 // Предполагаем, что ячейка квадратная
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let collectionViewWidth = collectionView.bounds.width
        let interitemSpacing = collectionViewWidth * 0.000000005 // 5% ширины коллекции
        
        return interitemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = gameList[indexPath.row]
           selected(game: game)
    }
}

