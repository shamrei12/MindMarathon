//
//  SlovusGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI

struct SlovusGameView: View {
    @State var dismissAction: (() -> Void)
    @ObservedObject private var viewModel = SlovusViewModel()
    @State var secretWord: String = ""
    @State private var time = 0
    @State private var size = 5
    @State var curentStep: Int = 0
    @State var curentWord: String = ""
    @State var resultGame: Bool = false
    
    func saveResults() {
        if resultGame {
            let resultGame = WhiteBoardModel(nameGame: "slovus", resultGame: "win", countStep: "\(curentStep)", timerGame: time)
            RealmManager.shared.saveResult(result: resultGame)
            CheckTaskManager.shared.checkPlayGame(game: 5)
        } else {
            let resultGame = WhiteBoardModel(nameGame: "slovus", resultGame: "lose", countStep: "\(curentStep)", timerGame: time)
            RealmManager.shared.saveResult(result: resultGame)
            CheckTaskManager.shared.checkPlayGame(game: 0)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopViewSlovusGameView(dismissAction: dismissAction, viewModel: viewModel, time: $time)
                    .padding(.horizontal, 20)
                
                GameControlSlovusGameView(viewModel: viewModel, sizeDigit: $size, secretWord: $secretWord)
                GameFieldSlovusGameView(viewModel: viewModel, curentWord: $curentWord, size: $size)
                    .padding(5)
                Spacer()
                CustomKeyboardView(viewModel: viewModel, curentStep: $curentStep, curentWord: $curentWord, size: $size, secretWord: $secretWord, resultGame: $resultGame)
            }
            .alert("Конец игры", isPresented: $viewModel.isFinishGame) {
                Button("Сыграть еще раз", role: .cancel) {
                    saveResults()
                    viewModel.isstartGame = true
                    viewModel.isFinishGame = false
                    time = 0
                    secretWord = viewModel.choiceRandomWord(size: size)
                    viewModel.historyUserMove = ["", "", "", "", "", ""]
                    viewModel.historyAnswerMove.removeAll()
                    curentStep = 0
                }
                
                Button("Выйти из игры", role: .destructive) {
                    saveResults()
                    dismissAction()
                }
            } message: {
                Text(resultGame ? "congratulations_message".localize() + "puzzleWord_message".localize() + "\(secretWord). " + "time_message".localize() + "\(time)" : "The moves are over! We made a word \(secretWord). Will you try again?")
            }
            
            VStack {
                if !viewModel.isCorrectWord {
                    AlertView(viewModel: viewModel)
                    
                }
                Spacer()
            }
            
        }
    }
}

struct AlertView: View {
    @ObservedObject var viewModel: SlovusViewModel
    var body: some View {
        VStack {
            Text("Данного слова нет в нашем словаре. Измените слово и повторите попытку")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.opacity)
                .onAppear {
                    // Start a timer to hide the view after 3 seconds
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        viewModel.isCorrectWord = true
                    }
                }
        }
    }
}

struct GameFieldSlovusGameView: View {
    @ObservedObject var viewModel: SlovusViewModel
    @Binding var curentWord: String
    @Binding var size: Int
    @State var text: String = ""
    
    func getChar(row: Int, column: Int) -> String {
        let char: String
        if row < viewModel.historyUserMove.count && column < viewModel.historyUserMove[row].count {
            let charIndex = viewModel.historyUserMove[row].index(viewModel.historyUserMove[row].startIndex, offsetBy: column)
            char = String(viewModel.historyUserMove[row][charIndex])
        } else {
            char = ""
        }
        return char
    }
    
    func getColorBackground(row: Int, column: Int) -> UIColor {
        guard !viewModel.historyAnswerMove.isEmpty else {
            return UIColor.systemGray3
        }
        
        if row >= viewModel.historyAnswerMove.count {
            return UIColor.systemGray3
        }
        
        let massiveColor = viewModel.historyAnswerMove[row].0
        return colorForMassiveColor(massiveColor, at: column)
    }
    
    private func colorForMassiveColor(_ massiveColor: [Int], at column: Int) -> UIColor {
        switch massiveColor[column] {
        case 0:
            return UIColor.gray
        case 1:
            return UIColor.systemYellow
        default:
            return UIColor.systemGreen
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<viewModel.historyUserMove.count, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<size, id: \.self) { column in
                        Text(getChar(row: row, column: column))
                            .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 45)))
                            .foregroundColor(.white)
                        //                            .frame(width: UIScreen.main.bounds.width / CGFloat(size + 1), alignment: .center)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .background(Color(getColorBackground(row: row, column: column)))
                            .cornerRadius(5)
                        
                    }
                }
            }
        }
    }
}
