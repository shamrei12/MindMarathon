//
//  FieldNumbersGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 12.03.24.
//

import SwiftUI

struct FieldNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 9)
    var body: some View {
        if !viewModel.numberArray.isEmpty {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<viewModel.numberArray.count, id: \.self) { number in
                        ElementFieldNumbersGameView(viewModel: viewModel, index: number, number: $viewModel.numberArray[number].0)
                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                            .onTapGesture {
                                viewModel.gameMove(index: number)
                            }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

struct ElementFieldNumbersGameView: View {
    @ObservedObject var viewModel: NumbersViewModel
    @State var index: Int
    @Binding var number: Int
    
    func backgroundColor(index: Int) -> Color {
        if viewModel.hintArray.contains(index) {
            return Color(UIColor(hex: 0x19e67f))
        } else {
            let color = viewModel.selectArray.contains(index) ? Color(UIColor(hex: 0x5a5d5f)) : Color(UIColor(hex: 0xbcc4c8))
            return color
        }
    }
    var body: some View {
        VStack {
            VStack {
                Text("\(number)")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 25)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor(index: index))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
        .disabled(index < viewModel.numberArray.count ? viewModel.numberArray[index].1 : true)
        .opacity(index < viewModel.numberArray.count && viewModel.numberArray[index].1 ? 1: 0.3)
    }
}
