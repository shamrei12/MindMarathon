//
//  GameControlBinarioGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 10.03.24.
//

import SwiftUI

struct GameControlBinarioGameView: View {
    @ObservedObject var viewModel: BinarioViewModel
    @Binding var sizeField: Int
    var body: some View {
        HStack {
            SteperView(level: $sizeField, max: 8, min: 4, step: 2)
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05)
                .background(.gray)
                .cornerRadius(25)
                .disabled(viewModel.isStartGame)
                .onTapGesture {
//                    viewModel.makeField(size: viewModel.size)
                }
            Spacer()
            Button(action: {
                viewModel.isStartGame.toggle()
                viewModel.isStartGame ? viewModel.makeLockMassiveButton() : viewModel.massiveButtons.removeAll()
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

//#Preview {
//    GameControlBinarioGameView()
//}
