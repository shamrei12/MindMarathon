//
//  TopViewSlovusGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI

struct TopViewSlovusGameView: View {
    @State var dismissAction: (()->Void)
    @ObservedObject var viewModel: SlovusViewModel
    @Binding var time: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.width * 0.065)
                        .tint(Color(UIColor.systemGray))
                }
                Spacer()
            }
            Text(TimeManager.shared.convertToMinutes(seconds: time))
                .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(fixedSize: 25)))
                .onReceive(timer) { _ in
                    if viewModel.isstartGame {
                        time += 1
                    }
                }
        }
    }
}

//#Preview {
//    TopViewSlovusGameView()
//}