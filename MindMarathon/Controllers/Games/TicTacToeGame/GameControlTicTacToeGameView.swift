//
//  GameControlTicTacToeGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 7.03.24.
//

import SwiftUI

struct GameControlTicTacToeGameView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    var body: some View {
        HStack {
            Button(action: {
                viewModel.isStartGame.toggle()
            }) {
                Image(systemName: viewModel.isStartGame ? "pause.fill" : "play.fill")
                    .tint(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.05)
            .background(.blue)
            .cornerRadius(25)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
