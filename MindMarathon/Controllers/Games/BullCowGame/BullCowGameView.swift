//
//  BullCowGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI
import AudioToolbox
import AVFoundation

struct BullCowGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = BullCowViewModelNew()
    @State private var secretDigit: [Int] = [Int]()
    @State private var showAlert: Bool = false
    
    func saveResults() {
        let resultGame = WhiteBoardModel(nameGame: "bullcow", resultGame: "win", countStep: "\(viewModel.historyGame.count)", timerGame: viewModel.time)
        RealmManager.shared.saveResult(result: resultGame)
        CheckTaskManager.shared.checkPlayGame(game: 5)
    }
    
    var body: some View {
        VStack {
            TopViewGameView(viewModel: viewModel)
                .padding(.horizontal, 20)
            GameControlBullCowView(viewModel: viewModel, secretDigit: $secretDigit)
                .padding(.top, 5)
                .padding(.horizontal, 10)
            GuesHistoryStepsBullCowView(viewModel: viewModel)
                .background(.clear)
                .padding(.top, 10)
            Spacer()
            KeyboardBullCowView(viewModel: viewModel, secretDigits: $secretDigit)
                .padding(.horizontal, 10)
        }
        .background(Color(UIColor(hex: 0x688dab)))
        .alert("Конец игры", isPresented: $viewModel.isFinishGame, actions: {
            Button("Сыграть еще раз", role: .cancel, action: {
                saveResults()
                viewModel.statusStarGame()
                viewModel.time = 0
                secretDigit = viewModel.makeNumber(maxLenght: viewModel.sizeDigits)
            })
            
            Button("Выйти из игры", role: .destructive, action: {
                saveResults()
                dismiss()
            })
        }, message: {
            Text("Тебе конец! Я тебе дам шанс сыграть еще раз:)")
        })
    }
}

struct TopViewGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BullCowViewModelNew
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(.white)
                }
                Spacer()
            }
            
            HStack {
                Text(TimeManager.shared.convertToMinutes(seconds: viewModel.time))
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                    .foregroundColor(.white)
                    .onReceive(timer) { _ in
                        if viewModel.isStartGame  {
                            viewModel.time += 1
                        }
                    }
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Text("Ур \(viewModel.sizeDigits)")
                        .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 20))))
                        .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
                .background(.white)
                .clipShape(.capsule)
                .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 10 ? 1 : 3)
                .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 10 ? 1 : 3)
                .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: viewModel.selectedItem == 10 ? 1 : 3)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            viewModel.selectedItem = 10
                            audioPlayerDown?.play()
                        }
                        .onEnded { _ in
                            viewModel.selectedItem = nil
                            if !viewModel.isStartGame {
                                viewModel.changeSizeDigit()
                            }
                            audioPlayerUP?.play()
                        }
                )
            }
        }
        .onAppear {
            DispatchQueue.global().async {
                playUp()
                playDown()
            }
        }
    }
}

#Preview {
    BullCowGameView()
}
