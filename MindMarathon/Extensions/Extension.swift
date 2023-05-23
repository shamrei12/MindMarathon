//
//  Extension.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 14.05.23.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil)[0] as! Self
    }
}

extension UIView {
    static func loadFromNib() -> UIView {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }

}
