//
//  GridView.swift
//  TicTacToe
//
//  Created by Guo Tian on 2/4/21.
//

import UIKit

class GridView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var path: UIBezierPath!
    
    override func draw(_ rect: CGRect) {
        path = UIBezierPath()
        path.lineWidth = 10
        
        path.move(to: CGPoint(x: 125.0, y: 0.0))
        path.addLine(to: CGPoint(x: 125.0, y: self.frame.size.height))
        
        path.move(to: CGPoint(x: 265.0, y: 0.0))
        path.addLine(to: CGPoint(x: 265.0, y: self.frame.size.height))
        
        path.move(to: CGPoint(x: 0.0, y: 125.0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 125.0))
        
        path.move(to: CGPoint(x: 0.0, y: 265.0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 265.0))
        
        UIColor.purple.setStroke()
        path.stroke()
    }
}
