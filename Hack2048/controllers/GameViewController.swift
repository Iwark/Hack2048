//
//  GameViewController.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/26/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

enum Direction {
    case Right, Left, Up, Down
    func swipeDir() -> UInt {
        switch self{
        case .Right:
            return UISwipeGestureRecognizerDirection.Right.value
        case .Left:
            return UISwipeGestureRecognizerDirection.Left.value
        case .Up:
            return UISwipeGestureRecognizerDirection.Up.value
        case .Down:
            return UISwipeGestureRecognizerDirection.Down.value
        }
    }
    func string() -> String {
        switch self{
        case .Right:
            return "Right"
        case .Left:
            return "Left"
        case .Up:
            return "Up"
        case .Down:
            return "Down"
        }
    }
}

let AIMode = true

class GameViewController: UIViewController {
    @IBOutlet var boardView: UIView
    let board = Board()
    var tiles = TileLabel[]()
    var animating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add swipe gesture
        let dirs:UISwipeGestureRecognizerDirection[] = [.Right, .Left, .Up, .Down]
        for dir in dirs{
            let sgr = UISwipeGestureRecognizer(target: self, action: Selector("swiped:"))
            sgr.direction = dir
            self.view.addGestureRecognizer(sgr)
        }
    }
    
    override func viewDidLayoutSubviews(){
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let tileSize:CGFloat = boardView.frame.size.width / CGFloat(board.boardSize)
                let tile = TileLabel(frame:CGRectMake(tileSize * CGFloat(x), tileSize * CGFloat(y), tileSize, tileSize))
                boardView.addSubview(tile)
                tiles += tile
            }
        }
        let generatedPos = board.generateNumber()
        tiles[generatedPos].setNumber(2)
        
        if AIMode {
            AlphaBetaAI.swipe(board)
            self.updateStatus()
        }
    }
    
    /*
    * Handle Swip Gesture
    */
    func swiped(sender: UISwipeGestureRecognizer){
        if animating { return; }
        animating = true;
        
        var isSwiped = false
        
        let dirs:Direction[] = [.Right, .Left, .Up, .Down]
        for dir in dirs{
            if dir.swipeDir() == sender.direction.value{
                isSwiped = board.swipeBoard(dir)
                break
            }
        }
        
        if isSwiped {
            self.updateStatus()
        } else {
            animating = false;
        }
    }
    
    func updateStatus(){
        // animation
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                let text = tiles[idx].text
                if(!text || text == ""){ continue }
                
                let pos = board.movementBoard[y][x]
                if pos["x"] != x || pos["y"] != y {
                    self.view.bringSubviewToFront(self.tiles[idx])
                    UIView.animateWithDuration(0.01, animations: { self.tiles[idx].moveTo(pos) }, completion: {(Bool) in })
                }
            }
        }
        
        // after 0.25 seconds
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateScreen:"), userInfo: nil, repeats: false)
    }
    
    func updateScreen(timer:NSTimer){
        
        // go gack tiles
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                tiles[idx].moveTo(["x":x,"y":y])
            }
        }
        
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                let idx:Int = y * board.boardSize + x
                let num:Int = board.rawBoard[y][x]
                tiles[idx].setNumber(num)
            }
        }

        let generatedPos = board.generateNumber()
        tiles[generatedPos].setNumber(2)
        
        animating = false;
        
        if board.isGameOver() {
            println("GameOver")
        }else if AIMode{
            AlphaBetaAI.swipe(board)
            self.updateStatus()
        }
    }
}
