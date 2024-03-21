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
        VStack {
            ZStack {
                VStack {
                    Text("PLAY")
                        .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 25)))
                        .foregroundColor(.white)
                }
                VStack {
                    Spacer()
                    Color(UIColor.black).opacity(0.2)
                        .frame(height: 7)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.07)
        .background(.blue)
        .cornerRadius(5)
        .padding(.horizontal, 10)
        .onTapGesture {
            viewModel.isStartGame.toggle()
            viewModel.makeField(size: viewModel.sizeField)
            viewModel.time = 0
            timer = Timer.publish(every: 1, on: .main, in: .common)
                              .autoconnect()
                              .sink(receiveValue: { _ in
                                  if viewModel.isStartGame {
                                      viewModel.time += 1
                                  }
                              })

        }
        
    }
}
