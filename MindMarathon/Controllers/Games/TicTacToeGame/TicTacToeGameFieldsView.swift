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
        ZStack {
            VStack(spacing: 11) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 11) {
                        ForEach(0..<3, id: \.self) { column in
                            TicTacToeGameFieldView(viewModel: viewModel, row: row, column: column)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(UIColor(hex: 0xf6f4f8, alpha: 1)))
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
            .background(Color(UIColor(hex: 0xf6f4f8, alpha: 1)))
            .cornerRadius(10)
            .shadow(color: Color(UIColor(hex: 0xfbfcf8, alpha: 1)), radius: 1, x: -1, y: -1)
            .shadow(color: Color(UIColor(hex: 0xf7ffff, alpha: 1)), radius: 1, x: -1, y: -1)
            .shadow(color: Color(UIColor(hex: 0xd1d5df, alpha: 1)), radius: 1, x: 1, y: 1)
            .shadow(color: Color(UIColor(hex: 0xd2d6e0, alpha: 1)), radius: 1, x: 1, y: 1)
            .shadow(color: Color(UIColor(hex: 0x9ea5b2, alpha: 1)), radius: 1, x: 1, y: 1)
            .shadow(color: Color(UIColor(hex: 0x8f98a7, alpha: 1)), radius: 1, x: 1, y: 1)
            
            HStack {
                Spacer()
                LineVStackTicTacToeGame()
                Spacer()
                LineVStackTicTacToeGame()
                Spacer()
            }
            .padding(.vertical, 10)
            
            VStack {
                Spacer()
                LineHStackTicTacToeGame()
                Spacer()
                LineHStackTicTacToeGame()
                Spacer()
            }
            .padding(.horizontal, 10)
            
        }
    }
}

struct LineVStackTicTacToeGame: View {
    var body: some View {
        VStack {
            
        }
        .frame(width: 10)
        .frame(maxHeight: .infinity)
        .background(Color(UIColor(hex: 0x3d678b, alpha: 1)))
        .clipShape(.capsule)
    }
}

struct LineHStackTicTacToeGame: View {
    var body: some View {
        HStack {
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 10)
        .background(Color(UIColor(hex: 0x3d678b, alpha: 1)))
        .clipShape(.capsule)
        
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
