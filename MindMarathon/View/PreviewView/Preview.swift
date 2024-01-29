//
//  Preview.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 28.01.24.
//

import SwiftUI

struct Preview: View {
    var dismisAction: (() -> Void)
    var body: some View {
        ZStack {
            NewBlurView()
            PreviewSecondView(dismisAction: dismisAction)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.5)
                .background(Color(UIColor.white))
                .cornerRadius(10)
        }
    }
}

struct PreviewSecondView: View {
    var dismisAction: (() -> Void)
    @State var type = RealmManager.shared.getUserStatistics().isEmpty ? false : true

    var body: some View {
        VStack {
            HeaderText()
            Spacer()
            MessageText(type: type)
            Spacer()
            ThankYouButton(dismisAction: dismisAction)
        }
    }

}

struct HeaderText: View {
    var body: some View {
        Text("От Разработчиков")
            .padding(.top, 10)
            .foregroundColor(.black)
            .font(.init(UIFont.sfProText(ofSize: 20, weight: .regular)))
    }
}

struct MessageText: View {
    let type: Bool
    var body: some View {
        if type {
            CustomText(message: "Привет. Я очень рад видеть тебя после обновления. Произошел ряд изменений, которые тебе понравятся. Для тебя у меня есть подарок. Я дарю тебе премиум доступ. В дальнейшем он тебе очень поможет и откроет много нового. Удачной игры!")
        } else {
            CustomText(message: "Привет. Я очень рад видеть тебя здесь. У меня есть несколько игр для тебя, чтобы провести весело время. Если увидишь ошибки или пожелания, то пиши мне на почту, которая есть в настройках. Удачной игры!")
        }
    }
}

struct CustomText: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.init(UIFont.sfProText(ofSize: 16, weight: .light)))
            .padding([.leading, .trailing], 15)
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
    }
}

struct ThankYouButton: View {
    var dismisAction: (() -> Void)

    var body: some View {
        Button("Спасибо!") {
            performActions(dissmis: dismisAction)
        }
        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.01)
        .padding()
        .background(Color(UIColor.lightGray))
        .tint(.black)
        .cornerRadius(12)
        .padding(.bottom, 10)
    }
    
    func performActions(dissmis: (() -> Void) ) {
        let uuid = String(UUID().uuidString)
        let lastFourChars = uuid.suffix(4)
        let userName = "User" + lastFourChars
        
        let firebase = FirebaseData()
        let userActivity: [WhiteBoardManager] = RealmManager.shared.getUserStatistics()
        if !userActivity.isEmpty {
            RealmManager.shared.addPremiumStatus(status: 10000000000000000000)
        }
        RealmManager.shared.clearRealmDatabase()
        RealmManager.shared.firstCreateUserProfile(userName: userName)
        let realmData = RealmManager.shared.getUserProfileData()
        firebase.refGetData(from: realmData)
        UserDefaultsManager.shared.setupDataUserDefaults()
        self.dismisAction()
    }
}


struct NewBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

//#Preview {
//    Preview()
//}
