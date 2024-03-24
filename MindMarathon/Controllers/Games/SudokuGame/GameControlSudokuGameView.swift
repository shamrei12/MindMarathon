//
//  GameControlSudokuGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.03.24.
//

import SwiftUI

struct GameControlSudokuGameView: View {
    @ObservedObject var viewModel: SudokuViewModel
    var body: some View {
        HStack {
            Button(action: {
                viewModel.isStartGame.toggle()
                viewModel.isStartGame ? viewModel.makeSudokuField() : viewModel.resetField()
            }) {
                Image(systemName: viewModel.isStartGame ? "pause.fill" : "play.fill")
                    .tint(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.05)
            .background(Color(UIColor(hex: 0x3d678b, alpha: 1)))
            .cornerRadius(25)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
