//
//  FontAdaptation.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 24.10.23.
//

import UIKit

final class FontAdaptation {
    static func addaptationFont(sizeFont: CGFloat) -> CGFloat {
        if UIScreen.main.bounds.size.width <= 414 {
            return sizeFont
        } else {
            return sizeFont * CGFloat(2)
        }
    }
}
