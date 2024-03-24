//
//  ButtonsCheckClearBinarioGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 10.03.24.
//

import SwiftUI

struct ButtonsCheckClearBinarioGameView: View {
    @ObservedObject var viewModel: BinarioViewModel
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                if viewModel.isStartGame {
                    viewModel.clearBoard()
                }
            }) {
                Text("ОЧИСТИТЬ")
                    .foregroundColor(.white)
                    .padding()
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor(hex: 0xa2afbe, alpha: 1)))
            .cornerRadius(10)
            Button(action: {
                if viewModel.isStartGame {
                    viewModel.checkResultGame()
                }
            }) {
                Text("ПРОВЕРИТЬ")
                    .foregroundColor(.white)
                    .padding()
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))

            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor(hex: 0x6ed16e, alpha: 1)))
            .cornerRadius(10)
        }
    }
}
