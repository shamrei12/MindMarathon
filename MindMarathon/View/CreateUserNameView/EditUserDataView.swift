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
            Text("enterNickname".localize())
                .frame(alignment: .trailing)
                .font(.init(UIFont.sfProText(ofSize: 15, weight: .regular)))
                .padding([.trailing, .leading, .top], 15)
            
            TextField("enterNickname".localize(), text: $myProperty)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 10)
            
            if myProperty.count > 15 {
                Text("symbolsError".localize())
                    .frame(alignment: .trailing)
                    .font(.init(UIFont.sfProText(ofSize: 10, weight: .light)))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
            
            if myProperty.isEmpty {
                Button("cancelButton".localize(), action: {
                    self.dismisAction()
                })
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.08)
                .background(.gray)
                .tint(.white)
                .padding()
                .cornerRadius(12)
            } else if !myProperty.isEmpty && myProperty.count <= 15 {
                Button("confirmButton".localize(), action: {
                    RealmManager.shared.changeUsername(name: myProperty)
                    self.dismisAction()
                })
                .cornerRadius(12)
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.08)
                .background(.green)
                .tint(.white)
                .padding()
                
            } else {
                Button("clearButton".localize(), action: {
                    myProperty = ""
                })
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.08)
                .background(.gray)
                .tint(.white)
                .padding()
                .cornerRadius(12)
            }
        }
        .background(Color(UIColor(named: "gameElementColor")!))
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

