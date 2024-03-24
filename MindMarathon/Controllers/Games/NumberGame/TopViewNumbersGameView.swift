//
//  TopViewNumbersGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.03.24.
//

import SwiftUI

struct TopViewNumbersGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NumbersViewModel
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(Color(UIColor.systemGray))
                }
                Spacer()
            }
            VStack {
                Text(TimeManager.shared.convertToMinutes(seconds: viewModel.time))
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                    .foregroundColor(.white)
            }
        
            HStack {
                Spacer()
                VStack {
                    Text(viewModel.typeGame ? "Классика" : "Быстрая")
                        .padding(10)
                }
                .background(.white)
                .clipShape(.capsule)
                .shadow(color: .black.opacity(0.6), radius: 0, x: 2, y: 2)
                .shadow(color: .white.opacity(5), radius: 0, x: -2, y: -2)
                .onTapGesture {
                    viewModel.typeGame.toggle()
                }
                .disabled(viewModel.isStartGame)
            }
           
            
        }
    }
}

#Preview {
    TopViewNumbersGameView(viewModel: NumbersViewModel())
}
