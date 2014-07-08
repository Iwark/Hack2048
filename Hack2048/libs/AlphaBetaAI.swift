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
        
        let date = NSDate()
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
        
//        var maxScore = 0
//        var maxDir = minmax(board, limit: 3).1
        var maxDir = alphabeta(board, limit: 3, alpha: Int.min, beta: Int.max).1
        
//        for dir in swipableDirections {
//            board.swipeBoard(dir)
//            let score = Evaluator.evaluate(board)
//            board.undo()
//            
//            if score > maxScore { maxScore = score; maxDir = dir }
//        }

        board.swipeBoard(maxDir)
        
        println(NSDate().timeIntervalSinceDate(date))
        
    }
    
    class func minmax(board:Board, limit:Int) -> (Int, Direction) {
        
        let swipableDirections = board.swipableDirections()
        var maxDir = Direction.Right
        
        // if gameover -> return
        if swipableDirections.count == 0 {
            return (Evaluator.evaluate(board), maxDir)
        }
        
        // reached to the limit of calc
        if limit == 0 { return (Evaluator.evaluate(board), maxDir) }
        
        if board.turn % 2 == 0 {
            var min = Int.max
            
            let emptyPositions = board.getEmptyPositions()
            for pos in emptyPositions {
                let y = pos / BOARD_SIZE
                let x = pos % BOARD_SIZE
                board.setNumber(x, y)
                let score = minmax(board, limit: limit-1).0
                board.undo()
                
                if score < min {
                    min = score
                }
            }
            println("turn: \(board.turn), min: \(min)")
            return (min, maxDir)
        } else {
            var max = Int.min
            for dir in swipableDirections {
                board.AIswipeBoard(dir)
                let score = minmax(board, limit: limit-1).0
                board.undo()
                if score > max {
                    max = score
                    maxDir = dir
                }
            }
            println("turn: \(board.turn), max: \(max)")
            return (max, maxDir)
        }
    }
    
    class func alphabeta(board:Board, limit:Int, alpha:Int, beta:Int) -> (Int, Direction) {
        
        var maxDir = Direction.Right

        let swipableDirections = board.swipableDirections()
        if swipableDirections.count == 0 {
            return (Evaluator.evaluate(board), maxDir)
        }
        
        // reached to the limit of calc
        if limit == 0 { return (Evaluator.evaluate(board), maxDir) }
        
        if board.turn % 2 == 0 {
            var min = Int.max
            var newBeta = beta
            let emptyPositions = board.getEmptyPositions()
            for pos in emptyPositions {
                let y = pos / BOARD_SIZE
                let x = pos % BOARD_SIZE
                board.setNumber(x, y)
                newBeta = alphabeta(board, limit: limit-1, alpha:alpha, beta:newBeta).0
                board.undo()
                
                if beta < newBeta {
                    newBeta = beta
                }
                if alpha >= newBeta {
                    return (alpha, maxDir)
                }
            }
            println("turn: \(board.turn), beta: \(newBeta)")
            return (newBeta, maxDir)
        } else {
            var max = Int.min
            var newAlpha = alpha
            for dir in swipableDirections {
                board.AIswipeBoard(dir)
                newAlpha = alphabeta(board, limit: limit-1, alpha:newAlpha, beta:beta).0
                board.undo()
                if alpha > newAlpha {
                    newAlpha = alpha
                } else {
                    maxDir = dir
                }
                if newAlpha >= beta {
                    return (beta, maxDir)
                }
            }
            println("turn: \(board.turn), alpha: \(newAlpha)")
            return (newAlpha, maxDir)
        }
    }
    
//    class func alphabeta(board:Board, limit:Int, alpha:Int, beta:Int) -> Int{
//        
//        let swipableDirections = board.swipableDirections()
//        
//        // if gameover -> return
//        if swipableDirections.count == 0 {
//            return Evaluator.evaluate(board);
//        }
//        
//        // reached to the limit of calc
//        if limit == 0 { return Evaluator.evaluate(board); }
//        
//        var newAlpha = alpha
//        var newBeta = beta
//        // computer turn
//        if board.turn % 2 == 0 {
//            let emptyPositions = board.getEmptyPositions()
//            for pos in emptyPositions {
//                let y = pos / BOARD_SIZE
//                let x = pos % BOARD_SIZE
//                board.setNumber(x, y)
//                let val = alphabeta(board, limit: limit-1, alpha: newAlpha, beta: newBeta)
//                board.undo()
//
//                if val < newAlpha {
//                    newAlpha = val
//                }
//            }
//            return newAlpha
//        } else {
//            for dir in swipableDirections {
//                board.swipeBoard(dir)
//                let val = alphabeta(board, limit: limit-1, alpha: newAlpha, beta: newBeta)
//                if val >= newBeta {
//                    return newBeta
//                }
//                if val > newAlpha {
//                    newAlpha = val
//                }
//            }
//        }
//        return 0
//    }
    
    
}
