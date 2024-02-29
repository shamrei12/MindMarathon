//
//  SteperView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.02.24.
//

import SwiftUI

struct SteperView: View {
    @Binding var level: Int
    var body: some View {
        HStack {
            ButtonSteperView(level: $level, systemName: "minus")
            Spacer()
            Text(String(level))
                .font(.init(PFFontFamily.SFProText.semibold.swiftUIFont(size: 20)))
                .foregroundColor(.white)
            Spacer()
            ButtonSteperView(level: $level, systemName: "plus")
        }
    }
}

struct ButtonSteperView: View {
    @Binding var level: Int
    @State var systemName: String
    var body: some View {
        Button(action: {
                level = systemName == "minus" ? level - 1 : level + 1
            if level == 7 || level == 1 {
                level = 2
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

#Preview {
    SteperView(level: .constant(2))
}
