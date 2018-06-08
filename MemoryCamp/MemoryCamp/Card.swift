//
//  Card.swift
//  MemoryCamp
//
//  Created by Charles on 2018/2/11.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import Foundation

struct Card: Hashable {  //Control Card Obj from 0~n
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool { //當用到==時自動給它identifier
        return lhs.identifier == rhs.identifier    //在ＭemoryCamp中的mutating func chooseCard有用到
    }
    
    var isFaceUp = false
    var isMatched = false
    var identifier : Int //get i-number(識別碼) from below func
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){//initializatiom 初始化
        self.identifier = Card.getUniqueIdentifier()
    }
}
