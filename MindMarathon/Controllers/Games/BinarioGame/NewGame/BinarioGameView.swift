//
//  BinarioGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 10.03.24.
//

import SwiftUI

struct BinarioGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = BinarioViewModel()
    
    func saveResult() {
        let resultGame = WhiteBoardModel(nameGame: "binario", resultGame: "win", countStep: "-", timerGame: viewModel.time)
        RealmManager.shared.saveResult(result: resultGame)
    }
    
    var body: some View {
        ZStack {
            VStack {
                TopViewBinarioGameView(viewModel: viewModel, time: $viewModel.time)
                    .padding(.horizontal, 20)
                GameControlBinarioGameView(viewModel: viewModel, sizeField: $viewModel.size)
                Spacer()
                FieldBinarioGameView(viewModel: viewModel)
                Spacer()
                ButtonsCheckClearBinarioGameView(viewModel: viewModel)
                    .padding(.bottom, 50)
                    .padding(.horizontal, 20)
            }
            
            VStack {
                if viewModel.showAlert {
                    BinarioAlertView(viewModel: viewModel, text: "Игровое поле заполнено не правильно. Проверьте и повтороно отправьте на проверку")
                }
                Spacer()
            }
        }
        .alert("End game".localize(), isPresented: $viewModel.isFinishGame) {
            Button("Сыграть еще раз", role: .cancel) {
                viewModel.time = 0
                viewModel.isStartGame = false
                viewModel.isFinishGame = false
                viewModel.massiveButtons.removeAll()
                saveResult()
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

struct BinarioAlertView: View {
    @ObservedObject var viewModel: BinarioViewModel
    @State var text: String
    var body: some View {
        VStack {
            Text(text)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.opacity)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        viewModel.showAlert = false
                    }
                }
        }
    }
}

#Preview {
    BinarioGameView()
}
