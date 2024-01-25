//
//  EditUserDataView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 25.01.24.
//

import SwiftUI

struct ContentView: View {
//    @State var isViewHidden = UserDefaultsManager.shared.getUserKey()
    var dismisAction: (() -> Void)
    var body: some View {
            EditUserDataView(dismisAction: dismisAction)
        }
    }

struct EditUserDataView: View {
    var dismisAction: (() -> Void)
    
    var body: some View {
        ZStack {
            BlurView()
                MySecondView(myProperty: "",  dismisAction: dismisAction)
        }
    }
}

struct MySecondView: View {
    @State var myProperty: String
    var dismisAction: (() -> Void)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Введите новый никнейм")
                .frame(alignment: .trailing)
                .font(.init(UIFont.sfProText(ofSize: 15, weight: .regular)))
                .padding([.trailing, .leading, .top], 15)
            
            TextField("Введите никнейм", text: $myProperty)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 10)
            
            Button("Принять", action: {
                if !myProperty.isEmpty {
                    RealmManager.shared.changeUsername(name: myProperty)
                }
                self.dismisAction()
                
            })
            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.1)
            .background(.black)
            .tint(.white)
            .padding(.bottom, 10)
        }
        .background(.white)
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .cornerRadius(12)
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

//#Preview {
//    ContentView(, dismisAction: <#() -> Void#>)
//}

