//
//  SlovusGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI

struct SlovusGameView: View {
    @ObservedObject private var viewModel = BullCowViewModelNew()
    @State private var time = 0
    @State private var size = 5
    @State private var secretDigit: [Int] = [Int]()
    var body: some View {
        VStack{
            TopViewSlovusGameView(viewModel: viewModel, time: $time)
                .padding(.horizontal, 20)
            GameControlSlovusGameView(viewModel: viewModel, sizeDigit: $size, secretDigit: $secretDigit)
            GameFieldSlovusGameView(size: $size)
                .padding(5)
            Spacer()
            CustomKeyboardView()
        }
     
    }
}

struct TopViewSlovusGameView: View {
    var viewModel: BullCowViewModelNew
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

struct GameControlSlovusGameView: View {
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
                .disabled(viewModel.isStartGame)
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


struct GameFieldSlovusGameView: View {
    @Binding var size: Int
    @State var text: String = ""
    var body: some View {
        VStack {
            ForEach(0..<6, id: \.self) { line in
                HStack {
                    ForEach(0..<size, id: \.self) { index in
                        Text("A")
                            .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 45)))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width / CGFloat(size + 1), alignment: .center)
                            .frame(maxHeight: .infinity)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

#Preview {
    SlovusGameView()
}
