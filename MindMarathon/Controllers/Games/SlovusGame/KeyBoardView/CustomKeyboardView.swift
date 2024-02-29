//
//  CustomKeyboardView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 29.02.24.
//

import SwiftUI
import WrappingHStack

struct CustomKeyboardView: View {
    @State var arrayButtons: [[String]] = [["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"], ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э"], ["Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "delete"]]
    var body: some View {
        VStack {
            ForEach(arrayButtons, id: \.self) { array in
                HStack {
                    ForEach(array, id: \.self) { letter in
                        CustomButtonKeyboardView(letter: letter)
                            .cornerRadius(5)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            Button(action: {
                print("123")
            }) {
                Text("Проверить слово")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 5)
            .background(.gray)
            .cornerRadius(5)
            
        }
        .padding(.horizontal, 5)

    }
}

struct CustomButtonKeyboardView: View {
    @State var letter: String
    var body: some View {
        if letter == "delete" {
            Button(action: {
                
            }) {
                Image(systemName: "delete.left.fill")
                    .tint(.white)
                    .padding()
            }
            .background(.gray)
            .frame(height: 40)
        } else {
            Button(action: {
                print(letter)
            }) {
                Text(letter)
                    .font(.init(PFFontFamily.SFProText.bold.swiftUIFont(size: 18)))
                    .foregroundColor(.white)
            }
            
            .frame(width: UIScreen.main.bounds.width * 0.06, height: 40)
            .background(.gray)
        }
        
        
    }
}

#Preview {
    CustomKeyboardView()
}
