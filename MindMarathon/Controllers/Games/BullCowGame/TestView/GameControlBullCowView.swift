//
//  TopViewBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct GameControlBullCowView: View {
    var viewModel: BullCowViewModelNew
    @Binding var sizeDigit: Int
    @State var isStartGame: Bool = false
    @Binding var secretDigit: [Int]
    var body: some View {
        HStack {
            SteperView(level: $sizeDigit)
                .frame(width: UIScreen.main.bounds.width * 0.25)
                .background(.gray)
                .cornerRadius(25)
            Spacer()
            Button(action: {
                isStartGame.toggle()
                isStartGame ? viewModel.statusStarGame() : viewModel.statusFinishGame()
                viewModel.sizeDigits = sizeDigit
                secretDigit = viewModel.makeNumber(maxLenght: viewModel.sizeDigits)
                
            }) {
                
                Image(systemName: isStartGame ? "pause.fill" : "play.fill")
                    .tint(.white)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(25)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    GameControlBullCowView(sizeDigit: .constant(2), isStartGame: 12)
//}
