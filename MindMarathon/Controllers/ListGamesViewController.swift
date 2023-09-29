//
//  ListGamesViewController.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 18.05.23.
//

import UIKit
import SnapKit

class ListGamesViewController: UIViewController {
    let tableView = UITableView()

//    let gameList: [Game] = (gameName: "Быки и Коровы", createdBy: "Aliaksei Shamrei", aboutGame: "Ваша цель угадать секретное число за минимальное количество ходов", imageName: "BullCow"), ListGameModel(gameName: "Словус", createdBy: "Aliaksei Shamrei", aboutGame: "В данной игре Вам необходимо угадать секретное слово за 6 попыток", imageName: "Game"), ListGameModel(gameName: "Заливка", createdBy: "Aliaksei Shamrei", aboutGame: "Ваша цель закрасить поле в один цвет за минимальное количество ходов", imageName: "Game"), ListGameModel(gameName: "Крестики Нолики", createdBy: "Nikita Shakalov", aboutGame: "Ваша задача быстрее соперника выстроить свои символы (крестики) в линию", imageName: "Game"), ListGameModel(gameName: "Бинарио", createdBy: "Aliaksei Shamrei", aboutGame: "Правильно расставьте синие и красные блоки в сетке, удовлетворяя условиям", imageName: "Game")]
    let gameList: [Game] = ListGamesViewController.createGames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Список игр".localize()
        tableView.register(UINib(nibName: "ListGameTableViewCell", bundle: nil), forCellReuseIdentifier: "ListGameTableViewCell")
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = UIColor(named: "viewColor")
        tableView.backgroundColor = UIColor.clear
        createUI()
    }
    
    static func createGames() -> [Game] {
        return [BullCowGame(title: "Быки и Коровы".localize(), createdBy: "Aliaksei Shamrei", descripton: "Your goal is to guess the secret number in as few moves as possible".localize(), rules: "1. Вы выбираете количество цифр в загаданном числе и нажимаете кнопку \"Play\". Игру можно поставить на паузу.\n\n2. Вам предстоит угадать число, выбранное компьютером. Число может начинаться с нуля.\n\n3. Вы делаете попытку, вводя число.\n\n4. Компьютер сообщает вам, сколько цифр в вашей попытке совпадают с загаданным числом и находятся на том же месте (такие цифры называются \"быками\"), а также сколько цифр совпадают с загаданным числом, но находятся на другом месте (такие цифры называются \"коровами\").\n\n5. Вы используете эту информацию для следующей попытки, и так далее, пока не угадаете число.\n\n6. Игра продолжается, пока вы не угадаете загаданное число.\n\n7. Вы можете начать новую игру после окончания предыдущей.".localize(), gameImage: "BullCow"), SlovusGame(title: "Словус".localize(), createdBy: "Aliaksei Shamrei", descripton: "В данной игре Вам необходимо угадать секретное слово за 6 попыток".localize(), rules: "1. Вы должны угадать загаданное компьютером слово. Слово может содержать повторяющиеся буквы. Вы делаете попытку, вводя слово.\n\n2. Компьютер проверяет каждую букву в вашей попытке и выделяет ее цветом:\n- Если буква выделена зеленым, то это значит, что буква есть в слове и стоит на своем месте.\n- Если буква выделена желтым, то это значит, что буква есть в слове, но не на своем месте.\n\n3. Вы получаете обратную связь от компьютера и используете эту информацию, чтобы сделать следующую попытку.\n\n4. Вы можете сделать до 6 попыток, чтобы угадать слово.\n\n5. Если вы угадали слово за меньшее количество попыток, то вы победили.\n6. Если вы не угадали слово за 6 попыток, то игра завершается.\n\n7. Вы можете начать новую игру после окончания предыдущей.".localize(), gameImage: "slovusImage"), FloodFillGame(title: "Заливка".localize(), createdBy: "Aliaksei Shamrei", descripton: "Ваша цель закрасить поле в один цвет за минимальное количество ходов".localize(), rules: "1. На доске есть ячейки разных цветов. Цвета могут повторяться.\n2. Игрок начинает с верхнего левого угла и прогрессирует построчно, выбирая один из цветных квадратов в нижней части экрана.\n\n3. Когда игрок изменяет текущий цвет области, каждый соседний квадрат того же цвета также изменяет цвет.\n4. Цель игры - закрасить все ячейки на доске одним цветом.\n5. Игра заканчивается, когда все ячейки на доске станут одного цвета.\n6. Игрок должен закрашивать ячейки таким образом, чтобы он мог закрасить все ячейки на доске.\n".localize(), gameImage: "floodFillImage"), TicTakToeGame(title: "Крестики Нолики".localize(), createdBy: "Nikita Shakalov", descripton: "Ваша задача быстрее соперника выстроить свои символы (крестики) в линию".localize(), rules: "1. На доске есть квадрат из 3x3 клеток.\n\n2. Игрок играет против компьютера. Игрок играет крестиками, компьютер - ноликами.\n\n3. Цель игры - собрать три своих символа в ряд (по горизонтали, вертикали или диагонали).\n\n4. Игроки ходят по очереди, ставя свой символ на пустую клетку.\n\n5. Игрок может ставить свой символ только на пустую клетку.\n\n6. Игра заканчивается, когда один из игроков собрал три своих символа в ряд или когда все клетки заполнены, и ни один игрок не собрал три своих символа в ряд.\n\n7. Если игрок собрал три своих символа в ряд, то он побеждает, если же ни один игрок не собрал три своих символа в ряд, то игра заканчивается вничью.".localize(), gameImage: "tikTakToeImage"), BinarioGame(title: "Бинарио".localize(), createdBy: "Aliaksei Shamrei", descripton: "Правильно расставьте синие и красные блоки в сетке, удовлетворяя условиям".localize(), rules: "1. В сетке есть клетки разных цветов: красные, синие и пустые клетки.\n\n2. Цель игры - заполнить всю сетку так, чтобы выполнились следующие условия:\n- Ни одна строка или столбец не должны содержать повторяющиеся цвета.\n- Каждая строка и столбец должны содержать одинаковое количество красных и синих клеток.\n\n3. Игрок может заполнять сетку, нажимая на клетки, чтобы изменить их цвет.\n\n4. Если все правила выполняются и сетка полностью заполнена, игрок побеждает.\n\n".localize(), gameImage: "binarioImage"), NumbersGame(title: "Цифры", createdBy: "Aliaksei Shamrei", descripton: "Разработка игры", rules: "Простой играй", gameImage: "slovusImage")]
    }
    
    func createUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.95)
            maker.height.equalToSuperview()
        }
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

extension ListGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ListGameTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "ListGameTableViewCell") as? ListGameTableViewCell {
            cell = reuseCell
        } else {
            cell = ListGameTableViewCell()
        }
        
        return configure(cell: cell, for: indexPath)
    }
    
    private func configure(cell: ListGameTableViewCell, for indexPath: IndexPath) -> UITableViewCell {
        cell.gameNameLabel.text = gameList[indexPath.row].title
        cell.createdByLabel.text = "by \(gameList[indexPath.row].createdBy)"
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
        default: return UIImage(named: "bull")!
        }
    }
}

extension ListGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewWidth = tableView.frame.width
        let height = tableViewWidth / 4
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = gameList[indexPath.row]
        selected(game: game)
    }
}
