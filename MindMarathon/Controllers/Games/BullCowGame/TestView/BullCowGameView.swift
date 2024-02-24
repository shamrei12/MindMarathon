//
//  BullCowGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct BullCowGameView: View {
    @State private var viewModel = BullCowViewModelNew()
    @State var massive: [String] = [String]()
    @State var sizeDigit: Int = 2
    @State var timeRemaining = 0
    @State var secretDigit: [Int] = [Int]()
    @State var time = 0


    var body: some View {
        VStack {
            TopViewGameView(viewModel: $viewModel, time: $time)
                .padding(.horizontal, 20)
            GameControlBullCowView(viewModel: $viewModel, sizeDigit: $sizeDigit, secretDigit: $secretDigit)
                .padding(.top, 5)
            GuesHistoryStepsBullCowView(viewModel: viewModel, massiveUserStep: $massive)
                .background(.clear)
            Spacer()
            KeyboardBullCowView(viewModel: $viewModel, sizeDigit: $sizeDigit, massive: $massive, secretDigits: $secretDigit)
        }
        .background(.clear)
    }
}

struct TopViewGameView: View {
    @Binding var viewModel: BullCowViewModelNew
    @Binding var time: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(Color(UIColor.systemGray))
            }
                Spacer()
            }
            Text(TimeManager.shared.convertToMinutes(seconds: time))
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                .onReceive(timer) { _ in
                    if viewModel.isStartGame {
                                   time += 1
                               }
                           }
            

        }
    }
}

#Preview {
    BullCowGameView()
}

