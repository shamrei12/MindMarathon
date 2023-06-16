//
//  TicTacToeModel.swift
//  MindMarathon
//
//  Created by Nikita  on 6/16/23.
//

import Foundation


class TicTacToeCell {
    
    enum SignType {
        case cross
        case circle
    }
    
    var signType: SignType?
    
    init(signType: SignType? = nil) {
        self.signType = signType
    }
}
