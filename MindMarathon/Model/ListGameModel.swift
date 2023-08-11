//
//  ListGameModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 11.08.23.
//

import Foundation


protocol ListGameProtocol {
    var gameName: String { get set }
    var createdBy: String { get set }
    var aboutGame: String { get set }
    var imageName: String { get set }
}

struct ListGameModel: ListGameProtocol {
    var gameName: String
    var createdBy: String
    var aboutGame: String
    var imageName: String
}
