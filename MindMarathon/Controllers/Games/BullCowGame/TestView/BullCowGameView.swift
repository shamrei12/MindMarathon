//
//  BullCowGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct BullCowGameView: View {
    @State var dismissAction: (()->Void)
    @ObservedObject private var viewModel = BullCowViewModelNew()
    @State private var sizeDigit: Int = 2
    @State private var timeRemaining = 0
    @State private var secretDigit: [Int] = [Int]()
    @State private var showAlert: Bool = false
    @State private var time = 0
    
    func saveResults() {
        let resultGame = WhiteBoardModel(nameGame: "bullcow", resultGame: "win", countStep: "\(viewModel.historyGame.count)", timerGame: time)
            RealmManager.shared.saveResult(result: resultGame)
            CheckTaskManager.shared.checkPlayGame(game: 5)
    }
    
    var body: some View {
        VStack {
            TopViewGameView(dismissAction: dismissAction, viewModel: viewModel, time: $time)
                .padding(.horizontal, 20)
            GameControlBullCowView(viewModel: viewModel, sizeDigit: $sizeDigit, secretDigit: $secretDigit)
                .padding(.top, 5)
            GuesHistoryStepsBullCowView(viewModel: viewModel)
                .background(.clear)
            Spacer()
            KeyboardBullCowView(viewModel: viewModel, sizeDigit: $sizeDigit, secretDigits: $secretDigit)
        }
        .alert("Конец игры", isPresented: $viewModel.isFinishGame, actions: {
            Button("Сыграть еще раз", role: .cancel, action: {
                saveResults()
                viewModel.statusStarGame()
                time = 0
                secretDigit = viewModel.makeNumber(maxLenght: sizeDigit)
            })
            
            Button("Выйти из игры", role: .destructive, action: {
                saveResults()
                dismissAction()
            })
        }, message: {
            Text("Тебе конец! Я тебе дам шанс сыграть еще раз:)")
        })
        
    }
}

struct TopViewGameView: View {
    @State var dismissAction: (()->Void)
    var viewModel: BullCowViewModelNew
    @Binding var time: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(Color(UIColor.systemGray))
                }
                Spacer()
            }
            Text(TimeManager.shared.convertToMinutes(seconds: time))
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                .onReceive(timer) { _ in
                    if viewModel.isStartGame  {
                        time += 1
                    }
                }
        }
    }
}

//#Preview {
//    BullCowGameView(dismissAction:)
//}

