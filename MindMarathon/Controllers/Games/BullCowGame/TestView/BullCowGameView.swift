//
//  BullCowGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct BullCowGameView: View {
    @ObservedObject private var viewModel = BullCowViewModelNew()
    @State private var sizeDigit: Int = 2
    @State private var timeRemaining = 0
    @State private var secretDigit: [Int] = [Int]()
    @State private var showAlert: Bool = false
    @State private var time = 0
    
    func restartGame() {
        
    }
    
    

    var body: some View {
            VStack {
                TopViewGameView(viewModel: viewModel, time: $time)
                    .padding(.horizontal, 20)
                GameControlBullCowView(viewModel: viewModel, sizeDigit: $sizeDigit, secretDigit: $secretDigit)
                    .padding(.top, 5)
                GuesHistoryStepsBullCowView(viewModel: viewModel)
                    .background(.clear)
                Spacer()
                KeyboardBullCowView(viewModel: viewModel, sizeDigit: $sizeDigit, secretDigits: $secretDigit)
            }
            .alert(isPresented: $viewModel.isFinishGame) {
                Alert(title: Text("text"), dismissButton: .cancel(Text("Очистить массив"), action: {
                    viewModel.historyGame.removeAll()
                    restartGame()
                }))
            }
    }
}

struct TopViewGameView: View {
    var viewModel: BullCowViewModelNew
    @Binding var time: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    
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

#Preview {
    BullCowGameView()
}

