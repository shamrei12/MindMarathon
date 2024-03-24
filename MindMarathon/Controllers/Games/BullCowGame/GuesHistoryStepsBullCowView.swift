//
//  GuesHistoryStepsBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct GuesHistoryStepsBullCowView: View {
    @ObservedObject var viewModel: BullCowViewModelNew
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<viewModel.historyGame.count, id: \.self) { text in
                    GuesUserStepsBullCowView(userGues: $viewModel.historyGame[text].userStep, bullCount: $viewModel.historyGame[text].bull, cowCount: $viewModel.historyGame[text].cow)
                        .padding(.horizontal, 10)
                        .background(Color(UIColor(hex: 0xfaf4ef, alpha: 1)))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .shadow(color: Color(UIColor(hex: 0x86969f, alpha: 1)), radius: 1, x: 0, y: 5)
                        .shadow(color: Color(UIColor(hex: 0x395574, alpha: 1)), radius: 1, x: 0, y: 5)
                        .shadow(color: Color(UIColor(hex: 0x4b6a8b, alpha: 1)), radius: 1, x: 0, y: 5)
                }
            }
            .padding(.top, 5)
        }
    }
}

struct GuesUserStepsBullCowView: View {
    @Binding var userGues: String
    @Binding var bullCount: Int
    @Binding var cowCount: Int
    var body: some View {
        HStack {
            UserStepsBullCowView(userGues: $userGues)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            ResultUserStepsBullCowView(bullCount: $bullCount, cowCount: $cowCount)
        }
    }
}


struct UserStepsBullCowView: View {
    
    @Binding var userGues: String
    var body: some View {
        HStack {
            ForEach(Array(userGues.enumerated()), id: \.offset) { offset, letter in
                VStack {
                    Text(String(letter))
                        .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 25)))
                        .foregroundColor(.white)
                        
                }
                .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.15)
                .background(Color(UIColor(hex: 0x71889e, alpha: 1)))
                .cornerRadius(10)
            }
          
        }
    }
}


struct ResultUserStepsBullCowView: View {
    @Binding var bullCount: Int
    @Binding var cowCount: Int
    
    var body: some View {
//        HStack {
            VStack {
//                Image(uiImage: PFAssets.cow.image)
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                Text("\(cowCount) коров")
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
                    .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                Text("\(bullCount) быков")
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
                    .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
            }
//            VStack {
//                Image(uiImage: PFAssets.bull.image)
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)

//                Text("\(bullCount) быков")
//                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 20)))
//                    .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
//
//            }
//        }
    }
}

//
//#Preview {
//    GuesHistoryStepsBullCowView(massiveUserStep: ["1234", "5678", "1352", "6789", "0123", "3456"])
//}
