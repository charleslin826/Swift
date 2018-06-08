//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Charles on 2018/2/24.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit
@IBDesignable // this code will reflesh the screen on story board once change (can see it change imm)
class PlayingCardView: UIView {
    @IBInspectable
    var rank: Int = 12 { didSet {setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var suit: String = "❤️" { didSet {setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isFaceUp: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout() }}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() }}
    
    @objc func adjustFaceCardScale(byHandlingGestureRecongnizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1 //讓上一行的動作後的大小重設為初始值1 如此才能繼續放更大或者縮更小 //但不設定也可以？
        default: break
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) // let fontSize can be adjusted by iphone scaler
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0 //default is 1, if set to 0 which mean take as many as you need
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero // 預設是長度會跟著變 寬度不變。這邊我們兩個都要跟著調整所以把預設刪除
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { //即時追蹤使用者字體大小設定 並同步呈現
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .rotated(by: CGFloat.pi)
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
    
    private func drawPips(){ //畫出中間主要的花瓣
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })//垂直的花瓣數
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) {max($1.max() ?? 0, $0) })//水平的花瓣數
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount//垂直花瓣間距＝卡片高/垂直的花瓣數
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)//嘗試花瓣 大小為垂直花瓣間距
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)//可能花瓣大小＝垂直花瓣間距/（嘗試花瓣的高/垂直花瓣間距）
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)//設定花瓣是出現在中間的字體 大小:（上一行）
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))//若花瓣寬大於卡片的寬 則 縮小依畫面比例縮小一半
            } else {
                return probablyOkayPipString//花瓣
            }
            
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2 )
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount{
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)//卡片大小為view邊界的設定大小 並且設定圓邊角
        roundedRect.addClip()
        UIColor.white.setFill() //設定底色是白色
        roundedRect.fill()//填滿設定的顏色（白色）
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale)) //(SizeRatio.faceCardImageSizeToBoundsSize) is 75% of the screen
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in:Bundle(for: self.classForCoder), compatibleWith: traitCollection ) {
                cardBackImage.draw(in: bounds)
            }
        }
        
        /*practice to draw a circle*/
//        if let context = UIGraphicsGetCurrentContext() {//it could return nil that's why we use if let, here never retun nil but maybe it will return nil in other contexts
//            //it could do ! point but we just gonna do if let
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
        /*practice to draw a circle*/
//        let path = UIBezierPath() //PLUS: goto storyboard content_mode >> set redraw to let circle correct in landscape mode
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.stroke()
//        path.fill()
    }
}

extension PlayingCardView {
    private struct SizeRatio { //These constants matters
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.05
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33 //角落偏移量 （＝距離角落圓邊多少）
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {//意思是視窗高＊0.085 (8.5%)
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String{
        switch rank{
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}


extension CGRect{
    var leftHalf: CGRect { //左半邊
        return CGRect(x: minX, y:minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {//右半邊
        return CGRect(x: midX, y:minY, width: width/2, height: height)
    }
    func inset(by size:CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(by size:CGSize) -> CGRect {
        return CGRect(origin:origin, size: size)
    }
    func zoom(by scale:CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
