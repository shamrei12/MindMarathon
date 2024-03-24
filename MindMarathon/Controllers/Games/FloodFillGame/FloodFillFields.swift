//
//  FloodFillFields.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 9.03.24.
//

import SwiftUI

struct FloodFillFields: View {
    @ObservedObject var viewModel: FloodFillViewModel
    
    var colorMass = [UIColor(hex: 0xdeecf2, alpha: 1), UIColor(hex: 0xeba967, alpha: 1), UIColor(hex: 0xdd6480, alpha: 1), UIColor(hex: 0x7bb39d, alpha: 1), UIColor(hex: 0x5a96c3, alpha: 1), UIColor(hex: 0x2f5f8f, alpha: 1)]
    
    func createMassive(line: Int, row: Int) {
        let random = Int.random(in: 0..<6)
        viewModel.field[line][row] = random
    }
    
    var body: some View {
        if viewModel.isStartGame {
            VStack(spacing: 1) {
                ForEach(0..<viewModel.sizeField, id: \.self) { line in
                    HStack(spacing: 1) {
                        ForEach(0..<viewModel.sizeField, id: \.self) { row in
                            ZStack {
                                FloodFillField()
                                    .frame(maxWidth: UIScreen.main.bounds.width / CGFloat(viewModel.sizeField), maxHeight: UIScreen.main.bounds.width / CGFloat(viewModel.sizeField))
                                    .background(viewModel.field.isEmpty ? .clear : Color(colorMass[viewModel.field[line][row]]))
                                    .clipped()
                                    .cornerRadius(CGFloat((viewModel.sizeField / 5) + 3))
                                VStack {
                                    Color(UIColor.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 5)
                                        .opacity(0.2)
                                        .clipped()
                                        
                                    Spacer()
                                }
                                VStack {
                                    Spacer()
                                    Color(UIColor.black)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 10)
                                        .opacity(0.1)
                                        .clipped()
                                }
                            }
                        }
                    }
                }
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.99, height: UIScreen.main.bounds.width * 0.99)
            .background(viewModel.isStartGame ? .black : .clear)
            .cornerRadius(5)
            .background(Color(UIColor(hex: 0x759ab2, alpha: 1)))
        }
    }
}

struct FloodFillField: View {
    var body: some View {
        VStack {
            
        }
        
    }
}

#Preview {
    FloodFillFields(viewModel: FloodFillViewModel(), colorMass: [UIColor(hex: 0xdeecf2, alpha: 1), UIColor(hex: 0xeba967, alpha: 1), UIColor(hex: 0xdd6480, alpha: 1), UIColor(hex: 0x7bb39d, alpha: 1), UIColor(hex: 0x5a96c3, alpha: 1), UIColor(hex: 0x2f5f8f, alpha: 1)])
}
