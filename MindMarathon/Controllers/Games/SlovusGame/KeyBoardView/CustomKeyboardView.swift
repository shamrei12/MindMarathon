//
//  CustomKeyboardView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI
import WrappingHStack

struct CustomKeyboardView: View {
    @ObservedObject var viewModel: SlovusViewModel
    @Binding var curentStep: Int
    @Binding var curentWord: String
    @Binding var size: Int
    @Binding var secretWord: String
    @Binding var resultGame: Bool
    @State var arrayButtons: [[String]] = [["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"], ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"], ["Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "delete"]]
    
        func getBackgroundColor(letter: String) -> UIColor {
            guard !viewModel.historyAnswerMove.isEmpty else {
                return .white
            }
            let historyMassive = viewModel.historyAnswerMove[0].1
            for i in 0..<viewModel.historyAnswerMove.count {
                for (key, value) in viewModel.historyAnswerMove[i].1 {
                    if key.lowercased() == letter.lowercased() {
                        switch value {
                        case 0: return .gray
                        case 1: return .systemYellow
                        case 2: return .systemGreen
                        default: return .white
                        }
                    }
                }
            }
            return .white
        }

    var body: some View {
        VStack {
            ForEach(arrayButtons, id: \.self) { array in
                HStack(spacing: 3) {
                    ForEach(array, id: \.self) { letter in
                        CustomButtonKeyboardView(viewModel: viewModel, size: $size, curentStep: $curentStep, curentWord: $curentWord, letter: letter)
                            .frame(maxWidth: .infinity)
                            .background(Color(getBackgroundColor(letter: letter)))
                            .cornerRadius(5)
                            .shadow(radius: 0.5, x: 1, y: 1)
                        
                    }
                }
            }
            Button(action: {
                if curentWord.count == size {
                    if viewModel.dictionary.contains(curentWord.lowercased()) {
                        viewModel.historyUserMove[curentStep] = curentWord
                        viewModel.userMove(puzzleWord: secretWord, userWord: curentWord.lowercased())
                        curentStep += 1
                        if secretWord == curentWord.lowercased() {
                            viewModel.isFinishGame = true
                            viewModel.isstartGame = false
                            resultGame = true
                        } else if curentStep == 6 && secretWord != curentWord.lowercased() {
                            viewModel.isFinishGame = true
                            viewModel.isstartGame = false
                            resultGame = false
                        }
                        curentWord.removeAll()
                    } else {
                        viewModel.isCorrectWord = false
                        curentWord.removeAll()
                        viewModel.historyUserMove[curentStep] = ""
                    }
                }
            }) {
                Text("ПРОВЕРИТЬ СЛОВО")
                    .foregroundColor(.black)
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 5)
            .background(.white)
            .cornerRadius(5)
            .shadow(radius: 0.5, x: 1, y: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
    }
}

struct CustomButtonKeyboardView: View {
    var viewModel: SlovusViewModel
    @Binding var size: Int
    @Binding var curentStep: Int
    @Binding var curentWord: String
    @State var letter: String
    var body: some View {
        if letter == "delete" {
            Button(action: {
                guard !curentWord.isEmpty && viewModel.isstartGame else {
                    return
                }
                viewModel.historyUserMove[curentStep].removeLast()
                curentWord.removeLast()
            }) {
                Image(systemName: "delete.left.fill")
                    .tint(.black)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .frame(height: 40)
        } else {
            Button(action: {
                if size > viewModel.historyUserMove[curentStep].count && viewModel.isstartGame {
                    curentWord += letter
                    viewModel.historyUserMove[curentStep] = curentWord
                }
            }) {
                Text(letter)
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 18)))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
        }
    }
}
