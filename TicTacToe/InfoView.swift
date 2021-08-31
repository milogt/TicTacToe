//
//  InfoView.swift
//  TicTacToe
//
//  Created by Guo Tian on 2/4/21.
//

import UIKit

class InfoView: UIView {
    
    var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label?.textColor = .white
        label?.textAlignment = .center
        label?.layer.cornerRadius = 20
        label?.layer.borderColor = UIColor.white.cgColor
        label?.layer.borderWidth = 3
        label?.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        label?.layer.masksToBounds = true
        label?.lineBreakMode = .byWordWrapping
        label?.numberOfLines = 4
      }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
