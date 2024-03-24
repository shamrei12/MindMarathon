//
//  SteperView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct SteperView: View {
    @Binding var level: Int
    @State var max: Int
    @State var min: Int
    @State var step: Int
    var body: some View {
        HStack {
            ButtonSteperView( level: $level, max: max, min: min, step: step, systemName: "minus")
            Spacer()
            Text(String(level))
                .font(.init(PFFontFamily.SFProText.semibold.swiftUIFont(size: 15)))
                .foregroundColor(.white)
            Spacer()
            ButtonSteperView(level: $level, max: max, min: min, step: step, systemName: "plus")
        }
    }
}

struct ButtonSteperView: View {
    @Binding var level: Int
    @State var max: Int
    @State var min: Int
    @State var step: Int
    @State var systemName: String
    var body: some View {
        Button(action: {
                level = systemName == "minus" ? level - step : level + step
            if level == max + step || level == min - step {
                level = min
            }
        }) {
            Image(systemName: systemName)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.width * 0.1)
        .tint(.white)
        .cornerRadius(50)
    }
}

//#Preview {
//    SteperView(level: .constant(2))
//}
