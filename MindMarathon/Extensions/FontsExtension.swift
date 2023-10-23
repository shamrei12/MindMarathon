//
//  FontsExtension.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 22.10.23.
//

import UIKit

extension UIFont {
    enum SFProText: String {
        case regular = "SFProText-Regular"
        case bold = "SFProText-Bold"
        case semiBold = "SFProText-Semibold"
        case medium = "SFProText-Medium"
        case light = "SFProText-Light"
        // Добавьте другие стили шрифта SF Pro Text, если необходимо
    }
    
    class func sfProText(ofSize fontSize: CGFloat, weight: SFProText) -> UIFont {
        return UIFont(name: weight.rawValue, size: fontSize) ?? systemFont(ofSize: fontSize)
    }
}

