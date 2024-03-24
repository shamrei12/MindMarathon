//
//  FieldSudokuViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.03.24.
//

import SwiftUI

struct FieldSudokuViewGame: View {
    @ObservedObject var viewModel: SudokuViewModel
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    
    func getBackgroundColor(row: Int, column: Int) -> UIColor {
        if viewModel.uncorrectSelected == (row, column) {
            return UIColor.systemRed
        } else if viewModel.isActivefield[row][column] {
            return UIColor(hex: 0x3d678b, alpha: 1)
        } else if viewModel.isDiactive[row][column] == false {
            let color = UIColor.systemGray6.withAlphaComponent(0.6)
            return color
        } else {
            return UIColor.clear
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    ForEach(0..<9, id: \.self) { column in
                        ElementFieldSudokuView(viewModel: viewModel, square: row, element: column)
                            .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                            .border(Color(uiColor: .systemGray5))
                            .background(Color(getBackgroundColor(row: row, column: column)))
                            .overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(column == 2 || column == 5 ? .black : .clear), alignment: .trailing)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(row == 2 || row == 5 ? .black : .clear), alignment: .bottom)
                            .disabled(!viewModel.isDiactive[row][column])
                            
                    }
                }
            }
        }
        .border(.black)
        .background(.white)
    }
}


struct ElementFieldSudokuView: View {
    @ObservedObject var viewModel: SudokuViewModel
    @State var square: Int
    @State var element: Int
    var body: some View {
        Button(action: {
            viewModel.isActivefield[square][element].toggle()
            viewModel.selectedElement = (square, element)
        }) {
            Text(viewModel.field[square][element] == 0 ? "" : "\(viewModel.field[square][element])")
                .foregroundColor(.black)
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 30)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .border(Color(uiColor: .systemGray5))
    }
}

//#Preview {
//    FieldSudokuViewGame()
//}
