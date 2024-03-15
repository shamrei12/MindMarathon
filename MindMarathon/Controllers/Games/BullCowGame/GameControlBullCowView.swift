//
//  TopViewBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct GameControlBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @State var isStartGame: Bool = false
    @Binding var secretDigit: [Int]
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(viewModel.isStartGame ? "END" : "PLAY")
                    .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                    .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 35))))
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
            .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
            .clipShape(.capsule)
            .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 11 ? 1 : 5)
            .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 11 ? 1 : 5)
            .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 11 ? 1 : 5)
            .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    viewModel.selectedItem = 11
                }
                .onEnded { _ in
                    viewModel.selectedItem = nil
                    viewModel.isStartGame.toggle()
                    viewModel.isStartGame ? viewModel.statusStarGame() : viewModel.statusFinishGame()
                    secretDigit = viewModel.makeNumber(maxLenght: viewModel.sizeDigits)
                }
            )            
        }
    }
}

//#Preview {
//    GameControlBullCowView(sizeDigit: .constant(2), isStartGame: 12)
//}
