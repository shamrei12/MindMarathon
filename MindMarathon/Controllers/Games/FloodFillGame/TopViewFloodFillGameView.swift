//
//  TopViewFloodFillGameView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 9.03.24.
//

import SwiftUI

struct TopViewFloodFillGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FloodFillViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
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
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        Text("Ур \(viewModel.sizeField)")
                            .font(.init(PFFontFamily.SFProText.heavy.swiftUIFont(size: FontAdaptation.addaptationFont(sizeFont: 20))))
                            .foregroundColor(Color(UIColor(hex: 0x71889e, alpha: 1)))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            
                        VStack {
                            Spacer()
                            Color(UIColor.black).opacity(0.2)
                                .frame(height: 7)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.12)
                .background(Color(UIColor(hex: 0xdeecf2, alpha: 1)))
                .cornerRadius(5)
                .onTapGesture {
                    if !viewModel.isStartGame {
                        viewModel.changeLevel(level: viewModel.sizeField)
                    }
                }
                
            }
        }
    }
}

#Preview {
    TopViewFloodFillGameView(viewModel: FloodFillViewModel())
}
