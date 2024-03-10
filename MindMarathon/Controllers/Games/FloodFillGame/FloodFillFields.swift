//
//  FloodFillFields.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 9.03.24.
//

import SwiftUI

struct FloodFillFields: View {
    @ObservedObject var viewModel: FloodFillViewModel
    
    var colorMass = [UIColor(hex: 0xff2b66), UIColor(hex: 0xfee069), UIColor(hex: 0x8ae596), UIColor(hex: 0x006fc5), UIColor(hex: 0xd596fa), UIColor(hex: 0xffb5a3)]
    
    func createMassive(line: Int, row: Int) {
        let random = Int.random(in: 0..<6)
        viewModel.field[line][row] = random
    }
    
    var body: some View {
        if !viewModel.field.isEmpty {
            VStack(spacing: 0) {
                ForEach(0..<viewModel.sizeField, id: \.self) { line in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.sizeField, id: \.self) { row in
                            FloodFillField()
                                .frame(maxWidth: UIScreen.main.bounds.width / CGFloat(viewModel.sizeField), maxHeight: UIScreen.main.bounds.width / CGFloat(viewModel.sizeField))
                                .background(Color(colorMass[viewModel.field[line][row]]))
                        }
                    }
                }
            }
        }
    }
}

struct FloodFillField: View {
    var body: some View {
        VStack {
        }
        
    }
}

