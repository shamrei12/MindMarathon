//
//  Localization.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 15.07.23.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", value: self, comment: self)
    }
}
