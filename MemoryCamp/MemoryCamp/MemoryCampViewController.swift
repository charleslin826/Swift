//
//  ViewController.swift
//  MemoryCamp
//
//  Created by Charles on 2018/2/11.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

class MemoryCampViewController: UIViewController {

    private lazy var game: MemoryCamp = MemoryCamp(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
   
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "翻牌次數:\(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
        //            FlipCount.text = "翻牌次數:\(flip)"}
    }

        
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)//卡片選擇次序＝按鈕次序
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel(){
        if cardButtons != nil{
            for i in cardButtons.indices {
                let button = cardButtons[i]
                let card = game.cards[i]
                if card.isFaceUp{//若陣列中的卡片是被點開(FaceUp)則顯示emoji
                    button.setTitle(emoji(for: card), for:UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                }else{//若陣列中的卡片是沒被點開(FaceUp=false)則顯示""(空白)
                    button.setTitle("", for:UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                }//若陣列中的卡片配對成功了 則變透明 否則顯示反面的顏色
            }
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? "" //if not return "" if yes = theme
            emoji = [:] //因為先前宣告過 所以可以不用打出完整的[Int:String]
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🍄🌳🍎🦋🌼🌷🌵🎄" //Int Array 最多支援8組配對的不同變化emoji(=emojiChoices倉庫)
    //command E 選取要的 例如『“,"』然後command G 直接移到下一個“,"
    private var emoji = [Card:String]()
//    var emoji = [Int:String]() //=精簡版Dictionary<Int,String>()
//    //此emoji方法的card=靜態變數struct:Card陣列 並將此指定為String物件
    private func emoji(for card: Card) -> String {
//若emoji字典的Card陣列的第1/2/3..(看有幾個卡片)個沒有值＆emojiChoices倉庫>0 則取亂數索引值randomIndex
        if emoji[card] == nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
//            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))//arc4random_uniform(x) = -x~0~x 前面冠Int可使之恆正數
//            emoji[card] = emojiChoices.remove(at: randomIndex)//".remove" which mean delete the choosed one from list
////上面是將emojiChoices倉庫的第i個(亂數索引值)的emoji資料取出給emoji字典(無留底)
            }
        return emoji[card] ?? "?"  //equals to " == nil return ?" (same with below code)
        //        if emoji[card] != nil{
        //            return emoji[card]!
        //        }else {
        //            return "?"
        //        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
    }
}
}
