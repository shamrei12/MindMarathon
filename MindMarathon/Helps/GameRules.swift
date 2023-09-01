//
//  GameRules.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 4.08.23.
//

import Foundation

protocol Game {
    var title: String { get }
    var createdBy: String { get}
    var descripton: String { get }
    var rules: String { get }
    var gameImage: String { get set }
}
