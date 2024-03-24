//
//  NumbersGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.03.24.
//

import SwiftUI

struct NumbersGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = NumbersViewModel()
    
    func saveResult() {
        let resultGame = WhiteBoardModel(nameGame: "Numbers", resultGame: "win", countStep: "-", timerGame: viewModel.time)
        RealmManager.shared.saveResult(result: resultGame)
        CheckTaskManager.shared.checkPlayGame(game: 5)
    }
    
    var body: some View {
        VStack {
            TopViewNumbersGameView(viewModel: viewModel)
                .padding(.horizontal, 20)
            GameControlNumbersGameView(viewModel: viewModel)
                .padding(.top, 20)
            FieldNumbersGameView(viewModel: viewModel)
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.horizontal, 1)
            Spacer()
            ButtonsNumbersGameView(viewModel: viewModel)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .background(Color(UIColor(hex: 0x9bc6ce, alpha: 1)))
        .alert("End game".localize(), isPresented: $viewModel.isFinishGame) {
            Button("Сыграть еще раз", role: .cancel) {
                saveResult()
                viewModel.time = 0
                viewModel.isStartGame = false
                viewModel.isFinishGame = false
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

struct ButtonsNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    var body: some View {
        HStack {
            Spacer()
            ButtonAddNumbersGameView(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
            Spacer()
            ButtonHintNumbersGameView(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
                .cornerRadius(10)
            Spacer()
        }
    }
}

struct ButtonAddNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    var body: some View {
        ZStack {
            Button(action: {
                if viewModel.typeGame {
                    viewModel.addNewDigit()
                } else {
                    if viewModel.addCount > 0 {
                        viewModel.addNewDigit()
                        viewModel.addCount -= 1
                    }
                }
            }) {
                Image(uiImage: PFAssets.plusNumbers.image)
                    .resizable()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(5)
            VStack {
                if !viewModel.typeGame {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(viewModel.addCount)")
                                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 1)
                                .background(.gray)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
            }
       
        }
    }
}

struct ButtonHintNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    var body: some View {
        ZStack {
            Button(action: {
                if viewModel.hintCount > 0 {
                    viewModel.showHintMove()
                    viewModel.hintCount -= 1
                }
                
            }) {
                Image(uiImage: PFAssets.bulbNumbers.image)
                    .resizable()
                    .colorMultiply(.blue)
            }
            VStack {
                HStack {
                    Spacer()
                    Text("\(viewModel.hintCount)")
                        .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(.gray)
                        .clipShape(Circle())
                }
                Spacer()
            }
        }
    }
}

#Preview {
    NumbersGameView()
}
