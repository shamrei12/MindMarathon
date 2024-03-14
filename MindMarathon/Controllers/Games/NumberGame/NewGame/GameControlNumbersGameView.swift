//
//  GameControlNumbersGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.03.24.
//

import SwiftUI
import Combine

struct GameControlNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    @State private var timer: AnyCancellable?
    var body: some View {
        HStack {
            Button(action: {
                viewModel.isStartGame.toggle()
                timer = Timer.publish(every: 1, on: .main, in: .common)
                                  .autoconnect()
                                  .sink(receiveValue: { _ in
                                      if viewModel.isStartGame {
                                          viewModel.time += 1
                                      }
                                  })
                viewModel.isStartGame ? viewModel.createArray() : viewModel.clearArray()
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
