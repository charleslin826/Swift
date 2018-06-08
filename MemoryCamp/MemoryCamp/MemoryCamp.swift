//
//  MemoryCamp.swift
//  MemoryCamp
//
//  Created by Charles on 2018/2/11.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import Foundation

//class MemoryCamp{
struct MemoryCamp{
    var cards = [Card]() //這是物件陣列 值在cardButtons的Title上
//    var shufflecards = [String]()
//    var vc = ViewController()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {//Optional = set(=Int第一張牌的索引值) or not set
        get {
            let ch = "h".oneAndOnly
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            //let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            //return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
  
    
    
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        //if !cards[index].isMatched =>如果是true 不要做這個。 因為正常的if(true){要執行的內容} 而if !(true)＝不要執行
        if !cards[index].isMatched {//若第i張卡片沒有配對(isMatched = false)時執行以下 //i=看使用者點到的索引值
            if let matchIndex = indexOfOneAndOnlyFaceUpCard/*matchIndex=第一張牌的索引值*/, matchIndex != index{ //若第一張牌不是被連點兩下
                //遊戲一開始翻開的第一張牌這邊不成立 因為indexOfOneAndOnlyFaceUpCard還是nil 跳到else
                if cards[matchIndex] == cards[index] { //check if cards is matched 若第一張牌和第二張牌相同
                    cards[matchIndex].isMatched = true//則 兩張牌的isMatched =true
                    cards[index].isMatched = true
                }
            cards[index].isFaceUp = true //翻開此張牌
//            indexOfOneAndOnlyFaceUpCard = nil //已經翻開了兩張>>要麼翻到兩張一樣的 要嘛沒翻到 反正都要使第一張牌的索引值回歸nil
        }else{
                indexOfOneAndOnlyFaceUpCard = index
//            //either no cards or 2 cards are face up >>兩張沒配對到的卡片被翻開 且翻開第三張的的時候
//            for flipDownIndex in cards.indices { //將所有卡片翻回背面！因為是從0到cards.indices 看全部有幾張牌
//                cards[flipDownIndex].isFaceUp = false  //遊戲一開始翻開第一張牌時卡片會由初始值變成背面
//            }
//            cards[index].isFaceUp = true//讓第一張 & 第三張翻開
//            indexOfOneAndOnlyFaceUpCard = index //設定第一張牌的索引值
        }
        
        
//        if !cards[index].isFaceUp {
//            cards[index].isFaceUp = false
//        }else{
//            cards[index].isFaceUp = true
//        }
    }
    }
    init(numberOfPairsOfCards: Int){//這邊我們是(9+1)/2=5次
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least 1 pair of cards")
        for _ in 0...numberOfPairsOfCards{ //"1...包含它" equals to "0..<" //Cmd+shift+z 回復下一步
            let card = Card()  // let matchingCard = card//Card=Ctrl struct //card=靜態變數struct:Card
            cards += [card,card]//cards.append(card)^2 or+cards.append(matchingCard)//cards=加兩次(靜態變數struct:Card)進去陣列中
        }
        // TODO: Shuffle the cards
//        for i in 0..<cards.count{
//        let shuffleIndex = Int(arc4random_uniform(UInt32(cards.count)))
//            print(shuffleIndex)//6783679258 //9291378799
//            print(vc.cardButtons[i])
////            shufflecards.append(cards.remove(at: shuffleIndex))
//        }
////        cards = shufflecards
        }
    
   
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
