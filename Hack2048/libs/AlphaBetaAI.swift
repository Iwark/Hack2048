//
//  AlphaBetaAI.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/29/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

class AlphaBetaAI: NSObject {
    
    class func swipe(board:Board){
        
        let swipableDirections = board.swipableDirections()
        
        // if gameover -> return
        if swipableDirections.count == 0 {
            return
        }
        
        // if able to swipe only one direction, then swipe that direction immediately.
        if swipableDirections.count == 1{
            board.swipeBoard(swipableDirections[0])
            return
        }
        
        var maxScore = 0
        var maxDir:Direction = .Left
        
        for dir in swipableDirections {
            board.swipeBoard(dir)
            let score = Evaluator.evaluate(board)
            board.undo()
            
            if score > maxScore { maxScore = score; maxDir = dir }
        }

        board.swipeBoard(maxDir)
        
    }
    
    func alphabeta(board:Board, limit:Int, alpha:Int, beta:Int){
        
        
        
    }
    
    
}
