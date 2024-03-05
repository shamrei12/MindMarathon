//
//  GameControlSlovusGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI

struct GameControlSlovusGameView: View {
    @ObservedObject var viewModel: SlovusViewModel
    @Binding var sizeDigit: Int
    @State var isStartGame: Bool = false
    @Binding var secretWord: String
    var body: some View {
        HStack {
            SteperView(level: $sizeDigit)
                .frame(width: UIScreen.main.bounds.width * 0.25)
                .background(.gray)
                .cornerRadius(25)
                .disabled(viewModel.isstartGame)
            Spacer()
            Button(action: {
                viewModel.loadDictionary()
                viewModel.isstartGame.toggle()
                secretWord = viewModel.choiceRandomWord(size: sizeDigit)
            }) {
                Image(systemName: viewModel.isstartGame ? "pause.fill" : "play.fill")
                    .tint(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(25)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
