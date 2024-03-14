//
//  FloodFillGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 9.03.24.
//

import SwiftUI

struct FloodFillGameView: View {
    @ObservedObject private var viewModel = FloodFillViewModel()
    @Environment(\.dismiss) private var dismiss
    func saveResult() {
        let resultGame = WhiteBoardModel(nameGame: "flood_fill", resultGame: "win", countStep: "\(viewModel.countStep)", timerGame: viewModel.time)
        RealmManager.shared.saveResult(result: resultGame)
        CheckTaskManager.shared.checkPlayGame(game: 5)
        
    }
    var body: some View {
        VStack {
            TopViewFloodFillGameView(viewModel: viewModel)
                .padding(.horizontal, 20)
            GameControlFloodFillGameView(viewModel: viewModel, sizeField: $viewModel.sizeField)
                .padding(.top, 20)
            Spacer()
            FloodFillFields(viewModel: viewModel)
                .background(.gray)
                .padding(.top, 50)
                .padding(.horizontal, 5)
            Spacer()
            ButtonsColorFloodFillGameView(viewModel: viewModel)
                .padding(.bottom, 20)
        }
        .alert("End game".localize(), isPresented: $viewModel.isFinishGame) {
            Button("Сыграть еще раз", role: .cancel) {
                saveResult()
                viewModel.field.removeAll()
                viewModel.isFinishGame = false
                viewModel.countStep = 0
                viewModel.time = 0
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

struct ButtonsColorFloodFillGameView: View {
    @ObservedObject var viewModel: FloodFillViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { button in
                    ButtonColorFloodFillGameView(color: $viewModel.colorMass[button], viewModel: viewModel, tag: button)
                }
                
            }
        }
    }
}

struct ButtonColorFloodFillGameView: View {
    @Binding var color: UIColor
    @ObservedObject var viewModel: FloodFillViewModel
    var tag: Int
    var body: some View {
        Color(color)
            .frame(maxWidth: UIScreen.main.bounds.height * 0.065, maxHeight: UIScreen.main.bounds.height * 0.065)
            .cornerRadius(5)
            .onTapGesture {
                
                if viewModel.isStartGame {
                    viewModel.fillCell(row: 0, col: 0, color: tag, currentColor: viewModel.field[0][0])
                    viewModel.countStep += 1
                }
                
                if viewModel.checkFinishGame() {
                    viewModel.isFinishGame = true
                    viewModel.isStartGame = false
                }
            }
    }
}

#Preview {
    FloodFillGameView()
}
