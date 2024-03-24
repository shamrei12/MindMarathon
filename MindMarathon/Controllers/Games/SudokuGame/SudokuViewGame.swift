//
//  SudokuViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.03.24.
//

import SwiftUI

struct SudokuViewGame: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = SudokuViewModel()
    
    func saveResult() {
        
    }
    var body: some View {
        VStack {
            TopViewSudokuGameView(viewModel: viewModel)
                .padding(.horizontal, 20)
            GameControlSudokuGameView(viewModel: viewModel)
                .padding(.top, 20)
            Spacer()
            FieldSudokuViewGame(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                .padding(4)
                .background(.black)
            ButtonsSudokuViewGame(viewModel: viewModel)
            Spacer()
            NumbersGamePadSudokuViewGame(viewModel: viewModel)
                .padding(.bottom, 10)
                .padding(.horizontal, 5)
        }
        .alert("End game".localize(), isPresented: $viewModel.isFinishGame) {
            Button("Сыграть еще раз", role: .cancel) {
//                saveResult()
//                viewModel.newGame()
                viewModel.time = 0
                viewModel.isStartGame = true
            }
            Button("Выйти из игры", role: .destructive) {
                saveResult()
                dismiss()
            }
        } message: {
            Text("congratulations_message".localize() + "time_message".localize() + "\(TimeManager.shared.convertToMinutes(seconds: viewModel.time))")

        }
    }
}

struct ButtonsSudokuViewGame: View {
    @ObservedObject var viewModel: SudokuViewModel
    var body: some View {
        HStack {
            Button(action: {
                viewModel.clearElementField()
            }) {
                VStack {
                    Image(uiImage: PFAssets.clearSudoku.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .tint(.white)
                    Text("Очистить")
                        .font(.init(PFFontFamily.SFProText.regular.swiftUIFont(size: 14)))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    SudokuViewGame()
}
