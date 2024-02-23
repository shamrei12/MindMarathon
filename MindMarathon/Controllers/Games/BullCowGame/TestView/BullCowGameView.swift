//
//  BullCowGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct BullCowGameView: View {
    private var viewModel = BullCowModel.self
    @State var massive: [String] = [String]()
    @State var sizeDigit: Int = 2
    @State var isStartGame: Bool = false
    @State var timeRemaining = 0
    @State var time = 0


    var body: some View {
        VStack {
            TopViewGameView(isStartGame: $isStartGame, time: $time)
                .padding(.horizontal, 20)
            GameControlBullCowView(sizeDigit: $sizeDigit, isStartGame: $isStartGame)
                .padding(.top, 5)
            GuesHistoryStepsBullCowView(massiveUserStep: $massive)
                .background(.clear)
            Spacer()
            KeyboardBullCowView(sizeDigit: $sizeDigit, massive: $massive)
        }
        .background(.clear)
    }
}

struct TopViewGameView: View {
    @Binding var isStartGame: Bool
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
                               if isStartGame {
                                   time += 1
                               }
                           }
            

        }
    }
}

#Preview {
    BullCowGameView()
}

