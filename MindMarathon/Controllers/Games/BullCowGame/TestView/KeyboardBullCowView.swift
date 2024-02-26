//
//  KeyBoardBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct KeyboardBullCowView: View {
    var viewModel: BullCowViewModelNew
    @Binding var sizeDigit: Int
//    @Binding var massive: [String]
    @Binding var secretDigits: [Int]
    @State var number: String = ""
    var massiveNumbers: [Int] = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

    var body: some View {
        VStack {
            InputGusesNumberBullCowView(number: $number)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(25)
                .padding(.horizontal, 5)
            VStack(spacing: 15) {
                HStack {
                    ForEach(0..<5, id: \.self) { number in
                        ButtonKeyboardBullCowView(sizeDigit: $sizeDigit, number: massiveNumbers[number], guesNumber: $number )
                    }
                }
                HStack {
                    ForEach(5..<10, id: \.self) { number in
                        ButtonKeyboardBullCowView(sizeDigit: $sizeDigit, number: massiveNumbers[number], guesNumber: $number)
                    }
                }
                
                Button(action: {
                    viewModel.nextuserMove(userDigits: number, secretDiggits: secretDigits)
//                    massive.append(number)
                    number = ""
                }) {
                    Text("Отправить")
                        .foregroundColor(.white)
                        .font(.init(PFFontFamily.SFProText.semibold.swiftUIFont(size: 25)))
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .background(.gray)
                .cornerRadius(25)
                .padding(.horizontal, 5)
                
            }
        }
        .background(.clear)
        .padding(.horizontal, 10)
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
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 35)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: UIScreen.main.bounds.height * 0.06)
        .frame(maxWidth: .infinity)
        .background(.gray)
        .cornerRadius(10)
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
                    Image(systemName: "delete.left.fill")
                        .resizable()
                        .frame(width: 40, height: 35)
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
