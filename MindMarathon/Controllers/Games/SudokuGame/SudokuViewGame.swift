//
//  SudokuViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.03.24.
//

import SwiftUI

struct SudokuViewGame: View {
    @ObservedObject private var viewModel = SudokuViewModel()
    var body: some View {
        VStack{
            Spacer()
            FieldSudokuViewGame(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                .onAppear {
                    viewModel.makeSudokuField()
                }
            Spacer()
            NumbersGamePadSudokuViewGame(viewModel: viewModel)
                .padding(.bottom, 10)
                .padding(.horizontal, 5)
        }

    }
}

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
            if !(viewModel.selectedElement.0 == nil) ||  !(viewModel.selectedElement.0 == nil) {
                viewModel.field[viewModel.selectedElement.0!][viewModel.selectedElement.1!] = number
                viewModel.isActivefield[viewModel.selectedElement.0!][viewModel.selectedElement.1!] = false
                viewModel.selectedElement = (nil, nil)
            }
        }) {
            Text("\(number)")
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 30)))
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SudokuViewGame()
}
