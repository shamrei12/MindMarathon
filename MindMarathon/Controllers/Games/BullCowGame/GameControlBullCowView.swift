//
//  TopViewBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI
import AVFoundation

struct GameControlBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    @State var isStartGame: Bool = false
    @Binding var secretDigit: [Int]
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
            .padding(.top, viewModel.selectedItem == 11 ? 1 : 0)
            .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    viewModel.selectedItem = 11
                    audioPlayerDown?.play()
                    
                }
                .onEnded { _ in
                    audioPlayerUP?.play()
                    viewModel.selectedItem = nil
                    viewModel.isStartGame.toggle()
                    viewModel.isStartGame ? viewModel.statusStarGame() : viewModel.statusFinishGame()
                    secretDigit = viewModel.makeNumber(maxLenght: viewModel.sizeDigits)
                }
            )            
        }
        .onAppear {
            DispatchQueue.global().async {
                playUp()
                playDown()
            }
        }
    }
}

//#Preview {
//    GameControlBullCowView(sizeDigit: .constant(2), isStartGame: 12)
//}
