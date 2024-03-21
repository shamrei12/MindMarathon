//
//  FieldBinarioGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 10.03.24.
//

import SwiftUI

struct FieldBinarioGameView: View {
    @ObservedObject var viewModel: BinarioViewModel
    
    func backgroundColor(row: Int, column: Int) -> UIColor {
        guard !viewModel.massiveButtons.isEmpty else {
            return viewModel.colorMassive[0]
        }
        let index = viewModel.massiveButtons[row][column]
        if index >= 10 {
            return viewModel.colorMassive[index - 10]
        } else if index == 0 ||  index == 1 || index == 2 {
            return viewModel.colorMassive[index]
        } else {
            return viewModel.colorMassive[0]
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                ForEach(0..<viewModel.size, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<viewModel.size, id: \.self) { column in
                            ZStack {
                                ElementFieldBinarioGameView(viewModel: viewModel, row: row, column: column)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color(backgroundColor(row: row, column: column)))
                                    .cornerRadius(10)
                            }
                            .onTapGesture {
                                if viewModel.isStartGame {
                                    if column == viewModel.disableButtons[row] {
                                        viewModel.showLock.toggle()
                                    } else {
                                        viewModel.changeTypeButton(row: row, column: column)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
        .background(Color(UIColor(hex: 0x2b3544, alpha: 1)))
        .cornerRadius(15)
    }
}

struct ElementFieldBinarioGameView: View {
    @ObservedObject var viewModel: BinarioViewModel
    @State var row: Int
    @State var column: Int
    
    var body: some View {
        VStack {
            if viewModel.showLock && viewModel.disableButtons[row] == column {
                Image(uiImage: PFAssets.padlock.image)
                    .resizable()
                    .padding(10)
                    .opacity(0.4)
            }
        }
    }
}

#Preview {
    FieldBinarioGameView(viewModel: BinarioViewModel())
}
