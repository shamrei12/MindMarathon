//
//  TicTacToeViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 7.03.24.
//

import SwiftUI

struct TicTacToeViewGame: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = TicTacToeViewModel()
    @State private var time = 0
    @State private var size = 3
    
    func saveResult() {
        var result: WhiteBoardModel
        if viewModel.botWin {
            result = WhiteBoardModel(nameGame: "tictactoe", resultGame: "lose", countStep: String(viewModel.step), timerGame: time)
           
        } else if viewModel.userWin {
            result = WhiteBoardModel(nameGame: "tictactoe", resultGame: "win", countStep: String(viewModel.step), timerGame: time)
            CheckTaskManager.shared.checkPlayGame(game: 5)
        } else {
            result =  WhiteBoardModel(nameGame: "tictactoe", resultGame: "draw", countStep: String(viewModel.step), timerGame: time)
        }
        RealmManager.shared.saveResult(result: result)
    }
    
    var body: some View {
        VStack {
            TopViewTicTacToeGameView(viewModel: viewModel, time: $time)
                .padding(.horizontal, 20)
            GameControlTicTacToeGameView(viewModel: viewModel)
                .padding(.top, 20)
                
            Spacer()
            TicTacToeGameFieldsView(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }
        .background(Color(UIColor(hex: 0xaacae3, alpha: 1)))
        .alert("End game".localize(), isPresented: $viewModel.finishGame) {
            Button("Сыграть еще раз", role: .cancel) {
                saveResult()
                viewModel.newGame()
                time = 0
                viewModel.isStartGame = true
                viewModel.step = 0
            }
            Button("Выйти из игры", role: .destructive) {
                saveResult()
                dismiss()
            }
        } message: {
            if viewModel.userWin {
                Text("congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: time))")
            } else if viewModel.botWin {
                Text("defeat_message".localize() + "time_message".localize() + " \(TimeManager.shared.convertToMinutes(seconds: time))")
            } else {
                Text("draw_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: time))")
            }
            
        }
    }
}

#Preview {
    TicTacToeViewGame()
}
