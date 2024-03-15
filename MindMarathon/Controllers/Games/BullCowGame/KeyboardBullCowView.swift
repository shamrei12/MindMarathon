//
//  KeyBoardBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct KeyboardBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @Binding var secretDigits: [Int]
    @State var number: String = ""
    var massiveNumbers: [Int] = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

    var body: some View {
        VStack(spacing: 15) {
            InputGusesNumberBullCowView(number: $number)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: 5)
            VStack(spacing: 15) {
                HStack {
                    ForEach(0..<5, id: \.self) { number in
                        ButtonKeyboardBullCowView(sizeDigit: $viewModel.sizeDigits, number: massiveNumbers[number], guesNumber: $number )
                            .disabled(!viewModel.isStartGame)
                    }
                }
                .padding(.horizontal, 5)
                HStack {
                    ForEach(5..<10, id: \.self) { number in
                        ButtonKeyboardBullCowView(sizeDigit: $viewModel.sizeDigits, number: massiveNumbers[number], guesNumber: $number)
                            .disabled(!viewModel.isStartGame)
                    }
                }
                .padding(.horizontal, 5)
                
                Button(action: {
                    viewModel.nextuserMove(userDigits: number, secretDiggits: secretDigits)
                    number = ""
                }) {
                    Text("Отправить".uppercased())
                        .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                        .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 35))))
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: 5)
                .disabled(!viewModel.isStartGame)
            }
        }
        .background(.clear)
    }
}

struct ButtonKeyboardBullCowView: View {
    @Binding var sizeDigit: Int
    @State var number: Int
    @Binding var guesNumber: String
    var body: some View {
        Button(action: {
            if guesNumber.count < sizeDigit {
                guesNumber += String(number)
            }
        }) {
            Text(String(number))
                .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 35))))
                .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                .frame(maxWidth: .infinity)
        }
        .frame(height: UIScreen.main.bounds.height * 0.06)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
        .cornerRadius(10)
//        .shadow(color: Color(UIColor(hex: 0xf4f4f4, alpha: 1)), radius: 1, x: 0, y: -5)
        .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: 5)
        .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: 5)
        .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: 5)
        
    }
}

struct InputGusesNumberBullCowView: View {
    @Binding var number: String
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(number)
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 35)))
                Spacer()
                Button(action: {
                    if !number.isEmpty {
                        number.removeLast()
                    }
                }) {
                    Image(uiImage: PFAssets.backspace.image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.11)
                        .tint(.black)
                }
                .padding(.trailing, 15)
            }
        }
    }
}

//#Preview {
//    KeyboardBullCowView(massive: [])
//}
