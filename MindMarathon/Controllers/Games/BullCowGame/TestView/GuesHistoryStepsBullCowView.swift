//
//  GuesHistoryStepsBullCowView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 23.02.24.
//

import SwiftUI

struct GuesHistoryStepsBullCowView: View {
    @Binding var massiveUserStep: [String]
    var body: some View {
        ScrollView {
            VStack {
                ForEach($massiveUserStep, id: \.self) { text in
                    GuesUserStepsBullCowView(userGues: text)
                        .padding(.horizontal, 10)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .shadow(color: .gray, radius: 1)
                }
            }
        }
    }
}

struct GuesUserStepsBullCowView: View {
    @Binding var userGues: String
    var body: some View {
        HStack {
            UserStepsBullCowView(userGues: $userGues)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            ResultUserStepsBullCowView()
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
                .background(Color(uiColor: .systemGray4))
                .cornerRadius(10)
            }
          
        }
    }
}


struct ResultUserStepsBullCowView: View {
    var body: some View {
        HStack {
            VStack {
                Image(uiImage: PFAssets.cow.image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                Text("1")
                    .font(.init(PFFontFamily.SFProText.regular.swiftUIFont(size: 20)))
            }
            VStack {
                Image(uiImage: PFAssets.bull.image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)

                Text("1")
                    .font(.init(PFFontFamily.SFProText.regular.swiftUIFont(size: 20)))

            }
        }
    }
}

//
//#Preview {
//    GuesHistoryStepsBullCowView(massiveUserStep: ["1234", "5678", "1352", "6789", "0123", "3456"])
//}
