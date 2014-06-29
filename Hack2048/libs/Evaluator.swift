//
//  Evaluator.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/29/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

class Evaluator: NSObject {
   
    class func evaluate(board:Board) -> Int{
        
        if board.isGameOver() {
            return -9999
        }
        
        var score = 0
        for y in 0..board.boardSize {
            for x in 0..board.boardSize {
                if x%(board.boardSize-1) == 0 { score += board.rawBoard[y][x] * 2 }
                if y%(board.boardSize-1) == 0 { score += board.rawBoard[y][x] * 2 }
                score += board.rawBoard[y][x]
            }
        }
        return score
    }
    
}
