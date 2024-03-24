//
//  NumbersGamePadSudokuViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.03.24.
//

import SwiftUI

struct NumbersGamePadSudokuViewGame: View {
    @ObservedObject var viewModel: SudokuViewModel
    var body: some View {
        HStack {
                ForEach(1..<10, id: \.self) { number in
                    ButtonGamePadSudokuViewGame(viewModel: viewModel, number: number)
                        
            }
        }
    }
}

struct ButtonGamePadSudokuViewGame: View {
    @ObservedObject var viewModel: SudokuViewModel
    @State var number: Int
    var body: some View {
        Button(action: {
            if !(viewModel.selectedElement.0 == nil) || !(viewModel.selectedElement.0 == nil) {
                viewModel.userMove(boxIndex: viewModel.selectedElement.0!, index: viewModel.selectedElement.1!, number: number)
            }
        }) {
            Text("\(number)")
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 30)))
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor(hex: 0x3d678b, alpha: 1)))
        }
        .frame(maxWidth: .infinity)
    }
}

