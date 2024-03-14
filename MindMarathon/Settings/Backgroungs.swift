//
//  Backgroungs.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 4.08.23.
//

import UIKit

enum CustomColor {
    case viewColor
    case gameElement
    case numbersBackground
    case numbersFieldBackground
    
    var color: UIColor {
        switch self {
        case .viewColor:
            return UIColor(named: "viewColor") ?? .clear
        case .gameElement:
            return UIColor(named: "gameElementColor") ?? .clear
        case .numbersBackground:
            return UIColor(named: "numbersBackground") ?? .clear
        case .numbersFieldBackground:
            return UIColor(named: "numbersFieldBackground") ?? .clear
        }
    }
}
