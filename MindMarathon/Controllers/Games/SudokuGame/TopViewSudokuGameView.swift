//
//  TopViewSudokuGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.03.24.
//

import SwiftUI

struct TopViewSudokuGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SudokuViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(.black)
                }
                Spacer()
            }
            Text(TimeManager.shared.convertToMinutes(seconds: viewModel.time))
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                .onReceive(timer) { _ in
                    if viewModel.isStartGame {
                        viewModel.time += 1
                    }
                }
        }
    }
}

//#Preview {
//    TopViewSudokuGameView()
//}
