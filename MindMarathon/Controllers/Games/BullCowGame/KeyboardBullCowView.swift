//
//  KeyBoardBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI
import AVKit
import AVFoundation

struct KeyboardBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @Binding var secretDigits: [Int]
    @State var guesNumber: String = ""
    var massiveNumbers: [Int] = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 5)
    @State private var audioPlayerUP: AVAudioPlayer?
    @State private var audioPlayerDown: AVAudioPlayer?
    
    func playUp() {
        if let soundURL = Bundle.main.url(forResource: "tapUp", withExtension: "mp3") {
            do {
                audioPlayerUP = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayerUP?.prepareToPlay()
            } catch {
                print("Ошибка при создании AVAudioPlayer: \(error)")
            }
        }
    }
    
    func playDown() {
        if let soundURL = Bundle.main.url(forResource: "tapDown", withExtension: "mp3") {
            do {
                audioPlayerDown = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayerDown?.prepareToPlay()
            } catch {
                print("Ошибка при создании AVAudioPlayer: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            InputGusesNumberBullCowView(number: $guesNumber)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: 5)
                .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: 5)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<massiveNumbers.count, id: \.self) { number in
                    ButtonKeyboardBullCowView(viewModel: viewModel, number: massiveNumbers[number])
                        .disabled(!viewModel.isStartGame)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    viewModel.selectedItem = massiveNumbers[number]
                                    audioPlayerDown?.play()
                                }
                                .onEnded { _ in
                                    audioPlayerDown?.play()
                                    audioPlayerUP?.play()
                                    viewModel.selectedItem = nil
                                    
                                    if guesNumber.count < viewModel.sizeDigits && viewModel.isStartGame {
                                        guesNumber += String(massiveNumbers[number])
                                    }
                                }
                        )
                }
            }
            ButtonSendKeyboardBullCowView(viewModel: viewModel, secretDigits: $secretDigits, guesNumber: $guesNumber)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            viewModel.selectedItem = 13
                            audioPlayerDown?.play()
                        }
                        .onEnded { _ in
                            audioPlayerDown?.stop()
                            audioPlayerUP?.play()
                            viewModel.selectedItem = nil
                            
                            if guesNumber.count == secretDigits.count && viewModel.isStartGame {
                                viewModel.nextuserMove(userDigits: guesNumber, secretDiggits: secretDigits)
                                guesNumber = ""
                            }
                            
                        }
                )
        }
        .background(.clear)
        .onAppear {
            DispatchQueue.global().async {
                playUp()
                playDown()
            }
        }
    }
}

struct ButtonSendKeyboardBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @Binding var secretDigits: [Int]
    @Binding var guesNumber: String
    var body: some View {
        VStack {
            Text("Отправить".uppercased())
                .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 35))))
                .frame(maxWidth: .infinity)
        }   .frame(maxWidth: .infinity)
            .frame(height: viewModel.selectedItem == 13 ? UIScreen.main.bounds.height * 0.059 :  UIScreen.main.bounds.height * 0.06)
            .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
            .cornerRadius(10)
            .padding(.horizontal, 5)
            .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 13 ? 3 : 5)
            .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 13 ? 3 : 5)
            .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 13 ? 3 : 5)
            .padding(.top, viewModel.selectedItem == 13 ? UIScreen.main.bounds.height * 0.06 -  UIScreen.main.bounds.height * 0.059 : 0)
    }
}

struct ButtonKeyboardBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @State var number: Int
    
    var body: some View {
        VStack {
            Text(String(number))
                .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 35))))
                .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                .frame(maxWidth: .infinity)
        }
        .frame(height: viewModel.selectedItem == number ? UIScreen.main.bounds.height * 0.059 : UIScreen.main.bounds.height * 0.06)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
        .cornerRadius(10)
        .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == number ? 3 : 5)
        .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == number ? 3 : 5)
        .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == number ? 3 : 5)
        .padding(.top, viewModel.selectedItem == number ? UIScreen.main.bounds.height * 0.06 -  UIScreen.main.bounds.height * 0.059 : 0)
        
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
                    .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
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

