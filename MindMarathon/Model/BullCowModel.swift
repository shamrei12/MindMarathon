//
//  BullCowModel.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 27.06.23.
//

import Foundation

protocol BullCowProtocol {
    var size: Int { get set }
    var bull: Int { get set }
    var cow: Int { get set }
    var userStep: [Int] { get set }
}

struct BullCowModel: BullCowProtocol {
    var size: Int
    var bull: Int
    var cow: Int
    var userStep: [Int]
}
