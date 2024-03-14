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
            Text(TimeManager.shared.convertToMinutes(seconds: viewModel.time))
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
        }
    }
}
