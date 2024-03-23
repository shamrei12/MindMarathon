//
//  FieldSudokuViewGame.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.03.24.
//

import SwiftUI

struct FieldSudokuViewGame: View {
    @ObservedObject var viewModel: SudokuViewModel
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    var body: some View {
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(Array(viewModel.field.enumerated()), id: \.offset) { (squares, _) in
                        VStack {
                            LazyVGrid(columns: columns, spacing: 0) {
                                ForEach(Array(viewModel.field[squares].enumerated()), id: \.offset) { (element, _) in
                                    ElementFieldSudokuView(viewModel: viewModel, square: squares, element: element, number: $viewModel.field[squares][element])
                                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                                        .border(Color(uiColor: .systemGray5))
                                        .background(viewModel.isActivefield[squares][element] == true ? .blue : .clear)
                                        .onTapGesture {
                                        
                                        }
                                }
                            }
                        }
                        .border(.black)
                    }
                }
            }
            .border(.black)
    }
}
    
    struct ElementFieldSudokuView: View {
        @ObservedObject var viewModel: SudokuViewModel
        @State var square: Int
        @State var element: Int
        @Binding var number: Int
        var body: some View {
            Button(action: {
                viewModel.isActivefield[square][element].toggle()
                viewModel.selectedElement = (square, element)
                   }) {
                       Text(number == 0 ? "" : "\(number)")
                           .foregroundColor(.black)
                           .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 30)))
                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                   }
        }
    }

//#Preview {
//    FieldSudokuViewGame()
//}
