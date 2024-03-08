//
//  TicTacToeGameFieldsView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 7.03.24.
//

import SwiftUI

struct TicTacToeGameFieldsView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { column in
                        TicTacToeGameFieldView(viewModel: viewModel, row: row, column: column)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.white)
                            .cornerRadius(16)
                            .onTapGesture {
                                guard viewModel.isStartGame else {
                                    return
                                }
                                viewModel.step += 1
                                viewModel.imageArray[row][column] = viewModel.move ? "X" : "O"
                                if !viewModel.checkForWinner(board: viewModel.imageArray, symbol: viewModel.move ? "X" : "O") {
                                    viewModel.move.toggle()
                                    if let coputerMove = viewModel.computerMove(board: viewModel.imageArray) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            viewModel.imageArray[coputerMove.0][coputerMove.1] = viewModel.move ? "X" : "O"
                                            viewModel.move.toggle()
                                        }
                                        if viewModel.checkForWinner(board: viewModel.imageArray, symbol: viewModel.move ? "X" : "O") {
                                            viewModel.botWin = true
                                            viewModel.finishGame = true
                                            viewModel.isStartGame = false
                                        } else {
                                        }
                                    } else {
                                        viewModel.finishGame = true
                                        viewModel.isStartGame = false
                                    }
                                } else {
                                    viewModel.userWin = true
                                    viewModel.finishGame = true
                                    viewModel.isStartGame = false
                                }
                            }
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
    }
}

struct TicTacToeGameFieldView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    @State var row: Int
    @State var column: Int
    
    var body: some View {
        VStack {
            if  viewModel.imageArray[row][column] == "X" {
                Image(uiImage: PFAssets.x.image)
                    .resizable()
                    .padding(5)
            } else if viewModel.imageArray[row][column] == "O" {
                Image(uiImage: PFAssets.o.image)
                    .resizable()
                    .padding(5)
                
            } else {
                
            }
        }
    }
}
