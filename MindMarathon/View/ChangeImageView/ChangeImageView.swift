//
//  ChangeImageView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 7.02.24.
//

import SwiftUI

struct ChangeImageView: View {
    @State private var userImage: String = ""
    var dismisAction: (() -> Void)
    var body: some View {
        ZStack {
            NewBlurView()
            ImageView(userimage: $userImage, dismisAction: dismisAction)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2)
        }
    }
}

struct ImageView: View {
    @Binding var userimage: String
    var dismisAction: (() -> Void)
    var body: some View {
        VStack {
            Text("Выберите изображение профиля")
                .font(.init(UIFont.sfProText(ofSize: 20, weight: .bold )))
            HStack {
                Image("userImage0")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .border(userimage == "userImage0" ? Color.black : Color.clear)
                    .onTapGesture {
                        userimage = "userImage0"
                    }
                Image("userImage1")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .border(userimage == "userImage1" ? Color.black : Color.clear)
                    .onTapGesture {
                        userimage = "userImage1"
                    }
                Image("userImage2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .border(userimage == "userImage2]" ? Color.black : Color.clear)
                    .onTapGesture {
                        userimage = "userImage2"
                    }
            }
            
            Button(action: {
                RealmManager.shared.changeUserImage(image: userimage)
                dismisAction()
            }) {
                Text("confirmButton".localize())
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
            .padding([.leading, .trailing], 5)
            .background(userimage.isEmpty ? Color.gray : Color.green)
            .buttonBorderShape(.roundedRectangle)
            .disabled(userimage.isEmpty)

        }
    }
}


//#Preview {
//    ChangeImageView(dismi)
//}
