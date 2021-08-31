//
//  ViewController.swift
//  TicTacToe
//
//  Created by Guo Tian on 2/4/21.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var cells: [UIView]!
    @IBOutlet weak var playerX: UILabel!
    @IBOutlet weak var playerO: UILabel!
    @IBOutlet weak var hint: UIButton!
    weak var shapeLayer: CAShapeLayer?
    
    var initialCenter = CGPoint()
    var player = 1
    var grid = Grid()
    var infoView:InfoView!
    let Xpos = CGPoint(x:90.0, y: 710.0)
    let Opos = CGPoint(x:300.0, y: 710.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGestures(playerX)
        addGestures(playerO)
        noticePlayer(playerX, initialPos: Xpos)
        playerO.isUserInteractionEnabled = false
        playerO.alpha = 0.5
        
        infoView = InfoView(frame: CGRect(x: 0, y: 0, width: 300, height: 780))
        infoView.label = UILabel(frame: CGRect(x: 95, y: -200, width: 200, height: 140))
        infoView.awakeFromNib()
        view.addSubview(infoView.label)
        let tapToDissmiss = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(recognizer:)))
        infoView.label.isUserInteractionEnabled = true
        infoView.label.addGestureRecognizer(tapToDissmiss)
        
        hint.addTarget(self,
                       action: #selector(self.tapButton(sender:)),
                         for: UIControl.Event.touchUpInside)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func addGestures(_ view: UILabel) {
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
        panGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    // set up pan gesture
    @objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer){
        guard recognizer.view != nil else {return}
        let piece = recognizer.view!
        var out = true
        self.view.bringSubviewToFront(piece)
        let translation = recognizer.translation(in: self.view)
        piece.center = CGPoint(x: piece.center.x + translation.x, y: piece.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .began {
            self.initialCenter = piece.center
        }
        // check if player locates at an empty cell and update game info
        if recognizer.state == .ended {
            for i in 0...cells.count-1{
                if piece.frame.intersects(cells[i].frame) && grid.checkEmpty(i){
                    UIView.animate(withDuration: 0.6) {
                        piece.center = self.cells[i].center
                    }
                    grid.occupyGrid(i)
                    UpdateGame(i)
                    out = false
                    player = -(player)
                    break
                }
            }
            // reallocate player if released out of grid
            if out == true {
                UIView.animate(withDuration: 0.6) {
                    piece.center = self.initialCenter
                }
            }
        }
    }
    
    // update the game after each round
    func UpdateGame(_ index:Int) {
        if player == 1 {
            grid.patternX.append(index)
            let image = UIImage(named:"X.png")!
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            cells[index].addSubview(imageView)
            if grid.checkWin(grid.patternX) {
                freezeGame()
                drawLine(grid.patternX)
                // create delay refer to
                // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.modifyLabel(content: "Player X wins!    ————————————     OK")
                })
            }
            else if grid.checkTie() {
                freezeGame()
                modifyLabel(content: "It's a tie!    ————————————     OK")
            }
            else {
                playerX.center = Xpos
                playerX.isUserInteractionEnabled = false
                playerX.alpha = 0.5
                noticePlayer(playerO, initialPos: Opos)
            }
        }
        else{
            grid.patternO.append(index)
            let image = UIImage(named: "O.png")!
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            cells[index].addSubview(imageView)
            if grid.checkWin(grid.patternO) {
                freezeGame()
                drawLine(grid.patternO)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.modifyLabel(content: "Player O wins!    ————————————     OK")
                })
            }
            else {
                playerO.center = Opos
                playerO.isUserInteractionEnabled = false
                playerO.alpha = 0.5
                noticePlayer(playerX, initialPos: Xpos)
            }
        }
    }
    
    @objc func tapButton(sender: UIButton!) {
        modifyLabel(content: "Get 3 in a row to win!    ————————————     OK")
        print("button tapped")
    }
    
    // modify the content of the label
    func modifyLabel(content: String) {
        self.infoView.label.center = CGPoint(x: 190, y: -200)
        infoView.label.text = content
        self.view.bringSubviewToFront(infoView.label)
        UIView.animate(withDuration: 0.6) {
            self.infoView.label.center = CGPoint(x: 190, y: 400)
        }
    }
    
    // tap label to dismiss hint and reset game if any player won
    @objc func tapLabel(recognizer:UITapGestureRecognizer){
        guard recognizer.view != nil else {return}
        let piece = recognizer.view!
        UIView.animate(withDuration: 0.6) {
            piece.center = CGPoint(x: 185, y: 1000)
        }
        if grid.gameOn == false {
            resetGame(with: grid)
        }
    }
    
    // to reset two player to its initialed positions and freeze interaction
    func freezeGame(){
        playerX.center = Xpos
        playerX.isUserInteractionEnabled = false
        playerX.alpha = 0.5
        playerO.center = Opos
        playerO.isUserInteractionEnabled = false
        playerO.alpha = 0.5
    }
    
    // restart game by reset grid information and views
    func resetGame(with grid:Grid){
        self.grid.reset()
        player = 1
        noticePlayer(playerX, initialPos: Xpos)
        for i in 0...cells.count-1{
            for sub in cells[i].subviews {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                                sub.alpha = 0.0},completion:{ (finished: Bool) in sub.removeFromSuperview()})
            }
        }
    }
    
    // CABasicAnimation set up refer to:
    // https://stackoverflow.com/questions/42978418/draw-line-animated
    func drawLine(_ pattern:[Int]) {
        // remove old shape layer if any
        self.shapeLayer?.removeFromSuperlayer()

        let path = UIBezierPath()
        for win in grid.winning {
            if pattern.sorted() == win || Set(win).isSubset(of:pattern) {
                path.move(to: cells[win[0]].center)
                path.addLine(to: cells[win[2]].center)
                break
            }
        }
        // create shape layer for that path
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.path = path.cgPath

        //delay untill animation completion refer to:
        //https://stackoverflow.com/questions/27882016/wait-for-swift-animation-to-complete-before-executing-code
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            shapeLayer.isHidden = true
        })
        view.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 3.3
        shapeLayer.add(animation, forKey: "MyAnimation")
        CATransaction.commit()

    }
    
    func noticePlayer(_ label:UILabel, initialPos:CGPoint){
        label.center = initialPos
        label.alpha = 1
        // rotate animation refer to:
        // https://www.journaldev.com/22104/ios-uiview-animations
        let rotate = CGAffineTransform(rotationAngle: 45)
        label.transform = rotate
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            label.transform = .identity},completion:{ (finished: Bool) in label.isUserInteractionEnabled = true
            })
    }

}

