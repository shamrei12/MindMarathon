//
//  GameControlFloodFillGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 9.03.24.
//

import SwiftUI
import Combine

struct GameControlFloodFillGameView: View {
    @ObservedObject var viewModel: FloodFillViewModel
    @Binding var sizeField: Int
    @State private var timer: AnyCancellable?

    var body: some View {
        HStack {
            SteperView(level: $sizeField, max: 25, min: 5, step: 5)
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05)
                .background(.gray)
                .cornerRadius(25)
                .disabled(viewModel.isStartGame)
                .onTapGesture {
                    viewModel.makeField(size: viewModel.sizeField)
                }
            Spacer()
            Button(action: {
                viewModel.isStartGame.toggle()
                viewModel.makeField(size: viewModel.sizeField)
                if !viewModel.isStartGame {
                    viewModel.field.removeAll()
                }
            timer = Timer.publish(every: 1, on: .main, in: .common)
                              .autoconnect()
                              .sink(receiveValue: { _ in
                                  if viewModel.isStartGame {
                                      viewModel.time += 1
                                  }
                              })
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
