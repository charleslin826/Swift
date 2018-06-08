//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Charles on 2018/2/22.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    var description: String { return "\(suit)\(rank)"}
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible{ //use below unicode icon for uniqueness
    
        case spades = "♠️"//'raw value' of Int =0, string="spades"
        case hearts = "❤️" //raw value of Int =1, ..
        case diamonds = "♦️"//raw value of Int =2, ..
        case clubs = "♣️" //raw value of Int =3, ..
        
        static var all = [Suit.spades,.hearts,.diamonds,.clubs]
        
        var description: String { return rawValue}
    }
    
    enum Rank:CustomStringConvertible{
        case ace
        case numeric(Int)
        case face(String)
        
        var order: Int{
        switch self{
        case .ace: return 1
        case .numeric(let pips):return pips
        case .face(let kind) where kind == "J": return 11
        case .face(let kind) where kind == "Q": return 12
        case .face(let kind) where kind == "K": return 13
        default: return 0
            }
        }
        
        static var all: [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
        
        var description: String {
            switch self{
            case .ace: return "A"
            case .numeric(let pips):return String(pips)
            case .face(let kind): return kind
        }
        
    }
}
}

