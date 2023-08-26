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
    
    var color: UIColor {
        switch self {
        case .viewColor:
            return UIColor(named: "viewColor") ?? .clear
        case .gameElement:
            return UIColor(named: "gameElementColor") ?? .clear
        }
    }
}
