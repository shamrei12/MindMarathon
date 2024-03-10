////
////  ZeroOneViewController.swift
////  MindMarathon
////
////  Created by Алексей Шамрей on 2.07.23.
////
//
//import UIKit
//
//class BinarioViewController: UIViewController {
//    private var messegeView: UserMistakeView!
//    private var viewModel: BinarioViewModel
//    private var gameLevel: GameLevel!
//    private let checkResultButton = UIButton()
//    private let panelControllView = UIView()
//    private let panelControllStackView = UIStackView()
//    private let sendClearStackView = UIStackView()
//    private let clearMoves = UIButton()
//    private var massLayer = [UIStackView]()
//    private var cells = [[UIView]]()
//    private var row = [UIView]()
//    private var stopwatch = Timer()
//    private let playButton = UIButton()
//    private let levelButton = UIButton()
//    private let containerView = UIView()
//    private let contentStackView = UIStackView()
//    private var gridSize = 4
//    private var index: Int = .zero
//    private var seconds: Int = .zero
//
//    private var colorMass = [UIColor(hex: 0xb5b5b5), UIColor(hex: 0xff2b66), UIColor(hex: 0x006fc5)]
//    private var isstartGame = false
//    private var iscontinuePlaying = false
//    
//    init(viewModel: BinarioViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(named: "viewColor")
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rules".localize(), style: .plain, target: self, action: #selector(rulesTapped))
//        createUI()
//        gameLevel = GameLevel()
//    }
//    
//    func levelButtonCreated() {
//        levelButton.addTarget(self, action: #selector(selectMaxLenghtTapped), for: .touchUpInside)
//        levelButton.setTitle("4", for: .normal)
//        levelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
//        levelButton.titleLabel?.adjustsFontSizeToFitWidth = true // автоматическая настройка размера шрифта
//        levelButton.titleLabel?.minimumScaleFactor = 0.5
//        levelButton.tintColor = UIColor.label
//        levelButton.backgroundColor = UIColor.lightGray
//        levelButton.layer.cornerRadius = 10
//        levelButton.addShadow()
//        view.addSubview(levelButton)
//    }
//    
//    func playButtonCreated() {
//        playButton.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        playButton.imageView?.contentMode = .scaleAspectFit
//        playButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
//        playButton.backgroundColor = .systemBlue
//        playButton.layer.cornerRadius = 10
//        playButton.tintColor = UIColor.white
//        playButton.addShadow()
//        view.addSubview(playButton)
//    }
//    
//    func checkResultButtonCreated() {
//        checkResultButton.layer.cornerRadius = 10
//        checkResultButton.backgroundColor = .systemGreen
//        checkResultButton.setTitle("Проверить".localize(), for: .normal)
//        checkResultButton.setTitleColor(.white, for: .normal)
//        checkResultButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
//        checkResultButton.addTarget(self, action: #selector(checkResultTapped), for: .touchUpInside)
//        checkResultButton.titleLabel!.adjustsFontSizeToFitWidth = true
//        checkResultButton.titleLabel!.minimumScaleFactor = 0.1
//        checkResultButton.addShadow()
//        view.addSubview(checkResultButton)
//    }
//    
//    func clearMovesCreated() {
//        clearMoves.layer.cornerRadius = 10
//        clearMoves.backgroundColor = .systemRed
//        clearMoves.setTitle("Очистить".localize(), for: .normal)
//        clearMoves.setTitleColor(.white, for: .normal)
//        clearMoves.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
//        clearMoves.titleLabel!.adjustsFontSizeToFitWidth = true
//        clearMoves.titleLabel!.minimumScaleFactor = 0.1
//        clearMoves.addTarget(self, action: #selector(clearColor), for: .touchUpInside)
//        clearMoves.addShadow()
//        view.addSubview(clearMoves)
//    }
//    
//    func sendClearStackViewCreated() {
//        sendClearStackView.axis = .horizontal
//        sendClearStackView.alignment = .fill
//        sendClearStackView.distribution = .fillEqually
//        sendClearStackView.spacing = 10
//        
//        sendClearStackView.addArrangedSubview(clearMoves)
//        sendClearStackView.addArrangedSubview(checkResultButton)
//        view.addSubview(sendClearStackView)
//        
//        sendClearStackView.snp.makeConstraints { maker in
//            maker.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(10)
//            maker.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(10)
//            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
//            maker.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.08)
//        }
//    }
//    
//    func containerCreated() {
//        // GameZone
//        containerView.backgroundColor = .clear
//        containerView.layer.cornerRadius = 10
//        containerView.isUserInteractionEnabled = false
//        
//        view.addSubview(containerView)
//        
//        containerView.snp.makeConstraints { maker in
//            maker.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.95)
//            maker.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.95)
//            maker.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
//            maker.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
//        }
//    }
//    
//    func panelControllStackViewCreated() {
//        panelControllView.layer.cornerRadius = 10
//        panelControllView.backgroundColor = .clear
//        view.addSubview(panelControllView)
//        
//        panelControllStackView.addArrangedSubview(levelButton)
//        panelControllStackView.addArrangedSubview(playButton)
//        panelControllStackView.axis = .horizontal
//        panelControllStackView.spacing = 10
//        panelControllStackView.distribution = .fillEqually
//        view.addSubview(panelControllStackView)
//        
//        panelControllView.snp.makeConstraints { maker in
//            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0.1)
//            maker.left.right.equalToSuperview().inset(10)
//            maker.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.095)
//        }
//        
//        panelControllStackView.snp.makeConstraints { maker in
//            maker.left.top.right.bottom.equalTo(panelControllView).inset(10)
//        }
//    }
//    
//    func createUI() {
//        levelButtonCreated()
//        playButtonCreated()
//        panelControllStackViewCreated()
//        containerCreated()
//        checkResultButtonCreated()
//        clearMovesCreated()
//        sendClearStackViewCreated()
//    }
//    
//    func createStackViewForMassLayer() {
//        for _ in 0..<gridSize {
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.distribution = .fillEqually
//            stackView.spacing = 5
//            massLayer.append(stackView)
//        }
//    }
//    func createViewForContainerView() -> UIView {
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        let cell = UIView()
//        cell.addGestureRecognizer(tapRecognizer)
//        cell.backgroundColor = UIColor.tertiaryLabel
//        return cell
//    }
//    func createGamePlace(size: Int) {
//        createStackViewForMassLayer()
//        
//        for i in 0..<gridSize {
//            for _ in 0..<gridSize {
//                let cell = createViewForContainerView()
//                massLayer[i].addArrangedSubview(cell)
//                row.append(cell)
//            }
//            view.addSubview(massLayer[i])
//            contentStackView.addArrangedSubview(massLayer[i])
//            cells.append(row)
//            row.removeAll()
//        }
//        
//        view.addSubview(contentStackView)
//        contentStackView.axis = .vertical
//        contentStackView.distribution = .fillEqually
//        contentStackView.spacing = 5
//        
//        contentStackView.snp.makeConstraints { maker in
//            maker.edges.equalTo(containerView).inset(5)
//        }
//        
//        createGameElement()
//    }
//
//    func createGameElement() {
//        for i in 0..<gridSize {
//            for j in 0..<gridSize {
//                cells[i][j].tag = 0
//                cells[i][j].isUserInteractionEnabled = true
//                cells[i][j].layer.cornerRadius = 5
//            }
//        }
//        
//        let tagMassive = [1, 2, 1, 2, 1, 2, 1, 2]
//        for index in 0..<gridSize {
//            let random = viewModel.makeRandomDiggit(min: 1, max: gridSize - 1)
//            cells[index][random].tag = tagMassive[index]
//            cells[index][random].isUserInteractionEnabled = false
//            let imageBlock = UIImageView()
//            imageBlock.image = UIImage(named: "padlock")
//            imageBlock.alpha = 0.15
//            cells[index][random].addSubview(imageBlock)
//            
//            imageBlock.snp.makeConstraints { maker in
//                maker.centerX.centerY.equalToSuperview()
//                maker.width.height.equalToSuperview().multipliedBy(0.5)
//            }
//
//        }
//        coloringView()
//    }
//    
//    func createTimer() {
//        stopwatch = Timer.scheduledTimer(timeInterval: 1,
//                                         target: self,
//                                         selector: #selector(updateTimer),
//                                         userInfo: nil,
//                                         repeats: true)
//    }
//    
//    @objc func updateTimer() {
//        seconds += 1
//        navigationItem.title = TimeManager.shared.convertToMinutes(seconds: seconds)
//    }
//    
//    @objc
//    func selectMaxLenghtTapped(sender: UIButton) {
//        sender.setTitle(String(gameLevel.getLevel(currentLevel: Int(sender.titleLabel!.text!)!, step: 2, curentGame: CurentGame.binarioGame)), for: .normal)
//    }
//    
//    // MARK: управление статусом игры
//    func startNewGame() {
//        seconds = 0
//        createTimer()
//        gridSize = Int((levelButton.titleLabel?.text)!)!
//        levelButton.isEnabled = false
//        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        createGamePlace(size: gridSize)
//        viewModel.size = gridSize
//        viewModel.isStartGame = true
//        viewModel.isContinueGame = true
//    }
//    
//    func continueGame() {
//        createTimer()
//        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        viewModel.isContinueGame = true
//
//    }
//    
//    func pauseGame() {
//        stopwatch.invalidate()
//        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        navigationItem.title = "PAUSE"
//        viewModel.isContinueGame = false
//    }
//    
//    func endGame() {
//        self.dismiss(animated: true)
//    }
//    
//    @objc func startGameTapped(_ sender: UIButton) {
//        let chekPartGame = (viewModel.isStartGame, viewModel.isContinueGame)
//        
//        if chekPartGame == (false, false) {
//            startNewGame()
//        } else if chekPartGame == (true, true) {
//            showAlertAboutFinishGame()
//            pauseGame()
//        } else {
//            continueGame()
//        }
//    }
//    
//    func showAlertAboutFinishGame() {
//        let alertController = UIAlertController(title: "Attention!".localize(), message: "Do you really want to finish the game?".localize(), preferredStyle: .alert)
//        let continueAction = UIAlertAction(title: "Continue".localize(), style: .default) { _ in
//            self.continueGame() // Вызов функции 1 при нажатии кнопки "Продолжить"
//        }
//        alertController.addAction(continueAction)
//        
//        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
//            self.restartGame()
//        }
//        alertController.addAction(endAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    func showAlertAboutFinishGame(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let continueAction = UIAlertAction(title: "New game".localize(), style: .default) { _ in
//            self.restartGame()
//        }
//        alertController.addAction(continueAction)
//        
//        let endAction = UIAlertAction(title: "Finish the game".localize(), style: .destructive) { _ in
//            self.exitGame()
//        }
//        alertController.addAction(endAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    // Раскраская каждого view в зависимости от tag
//    func coloringView() {
//        for i in 0..<gridSize {
//            for j in 0..<gridSize {
//                makeColor(viewElement: cells[i][j])
//            }
//        }
//    }
//    
//    // Функция раскраски view
//    func makeColor(viewElement: UIView) {
//        switch viewElement.tag {
//        case 1:
//            viewElement.backgroundColor = UIColor(cgColor: colorMass[1].cgColor)
//            viewElement.layer.shadowColor = UIColor.black.cgColor
//            viewElement.layer.shadowOpacity = 0.8
//            viewElement.layer.shadowOffset = CGSize(width: 1, height: 1)
//            viewElement.layer.shadowRadius = 5
//        case 2:
//            viewElement.backgroundColor = UIColor(cgColor: colorMass[2].cgColor)
//            viewElement.layer.shadowColor = UIColor.black.cgColor
//            viewElement.layer.shadowOpacity = 0.8
//            viewElement.layer.shadowOffset = CGSize(width: 1, height: 1)
//            viewElement.layer.shadowRadius = 5
//        default:
//            viewElement.backgroundColor = UIColor(cgColor: colorMass[0].cgColor)
//            viewElement.layer.shadowColor = UIColor.clear.cgColor
//
//        }
//    }
//    
//    @objc
//    func cancelTapped() {
//        self.dismiss(animated: true)
//    }
//    
//    @objc
//    func rulesTapped() {
//        let rulesVC = CurrentRulesViewController(game: viewModel.game)
//        rulesVC.modalPresentationStyle = .formSheet
//        present(rulesVC, animated: true)
//    }
//    
//    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
//        
//        guard let selectedCell = recognizer.view else {
//            return
//        }
//        guard viewModel.isContinueGame == true else {
//            return
//        }
//        
//        guard selectedCell.isUserInteractionEnabled else {
//            return
//        }
//        
//        selectedCell.tag + 1 > 2 ? (selectedCell.tag = 0) : (selectedCell.tag += 1)
//
//        makeColor(viewElement: selectedCell)
//    }
//    
//    @objc
//    func checkResultTapped() {
//        if viewModel.isStartGame && viewModel.isContinueGame {
//            let mass = createMassiveTag()
//            guard !viewModel.checkForZero(array: mass) else {
//                return
//            }
//            if makeAnswer(mass: mass) {
//                stopwatch.invalidate()
//                showAlertAboutFinishGame(title: "End game".localize(), message: "congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: seconds))")
//                let resultGame = WhiteBoardModel(nameGame: "binario", resultGame: "win", countStep: "-", timerGame: seconds)
//                CheckTaskManager.shared.checkPlayGame(game: 5)
//                RealmManager.shared.saveResult(result: resultGame)
//            }
//        }
//    }
//    
//    func makeAnswer(mass: [[Int]]) -> Bool {
//        guard viewModel.uniqueLines(line: mass) else {
//            createMistakeMessage(messages: "В одной из строк у Вас ошибка. Проверьте и повторите попытку")
//            return false
//        }
//        
//        guard viewModel.uniqueRows(mass: mass) else {
//            createMistakeMessage(messages: "В одном из столбцов у Вас ошибка. Проверьте и повторите попытку")
//            return false
//        }
//        
//        return true
//    }
//    
//    func createMassiveTag() -> [[Int]] {
//        var resultMass = [[Int]]()
//        for i in 0..<gridSize {
//            var row = [Int]() // Создаем новую строку
//            for j in 0..<gridSize {
//                row.append(cells[i][j].tag) // Добавляем значение в строку
//            }
//            resultMass.append(row) // Добавляем строку в результат
//        }
//        return resultMass
//    }
//    
//    @objc
//    func clearColor() {
//        if viewModel.isStartGame && viewModel.isContinueGame {
//            for i in 0..<gridSize {
//                for j in 0..<gridSize {
//                    if cells[i][j].isUserInteractionEnabled {
//                        cells[i][j].tag = 0
//                        makeColor(viewElement: cells[i][j])
//                    }
//                }
//            }
//        }
//    }
//    
//    func createMistakeMessage(messages: String) {
//        guard messegeView == nil else {
//            return
//        }
//        messegeView = UserMistakeView.loadFromNib() as? UserMistakeView
//        
//        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//        let topPadding = window?.safeAreaInsets.top ?? 0
//        let alertViewWidth: CGFloat = self.view.frame.size.width / 1.1
//        let alertViewHeight: CGFloat = 90
//        
//        messegeView.createUI(messages: messages)
//        messegeView.frame = CGRect(x: (window!.frame.width - alertViewWidth) / 2,
//                                   y: -alertViewHeight,
//                                   width: alertViewWidth,
//                                   height: alertViewHeight)
//        
//        messegeView.layer.cornerRadius = 10
//        messegeView.layer.shadowOpacity = 0.2
//        messegeView.layer.shadowRadius = 5
//        messegeView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        
//        UIApplication.shared.keyWindow?.addSubview(messegeView)
//        
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//            self.messegeView.frame.origin.y = topPadding // конечное положение
//        }) { _ in
//            UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {
//                self.messegeView.frame.origin.y = -alertViewHeight // начальное положение
//            }, completion: { _ in
//                self.messegeView.removeFromSuperview()
//                self.messegeView = nil
//            })
//        }
//    }
//    
//    func restartGame() {
//        UIView.animate(withDuration: 0.1) {
//            self.view.alpha = 1.0
//            self.view.isUserInteractionEnabled = true
//        }
//        pauseGame()
//        levelButton.isEnabled = true
//        viewModel.isContinueGame = false
//        viewModel.isStartGame = false
//        stopwatch.invalidate()
//        seconds = 0
//        clearGame()
//    }
//    
//    func clearGame() {
//        for view in contentStackView.arrangedSubviews {
//            contentStackView.removeArrangedSubview(view)
//            view.removeFromSuperview()
//        }
//        
//        contentStackView.removeFromSuperview()
//        cells.removeAll()
//        row.removeAll()
//        massLayer.removeAll()
//    }
//    
//    func exitGame() {
//        self.dismiss(animated: true)
//    }
//}
