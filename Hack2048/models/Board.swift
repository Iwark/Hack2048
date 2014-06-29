//
//  Board.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/28/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

//typealias Point = (x:Int, y:Int)
typealias Point = Dictionary<String, Int>
typealias Points = Array<Point>

class Board: NSObject {
   
    let boardSize = 4
    var rawBoard = Int[][]()  // board state
    var movementBoard = Points[]()
    var turn:Int = 0
    var updateLog = Int[][][][]()  // board history
    
    init(){
        super.init()
        for _ in 0..boardSize {
            rawBoard += Int[](count: boardSize, repeatedValue: 0)
            movementBoard += Points(count:boardSize, repeatedValue:["x":0, "y":0])
        }
    }
    
    // start a new game
    func initGame(){
        for y in 0..boardSize {
            for x in 0..boardSize {
                rawBoard[y][x] = 0
            }
        }
    }
    
    func swipeBoard(dir:Direction) -> Bool {
        var isChanged = false
        for line in 0..boardSize {
            let swipedLine:Dictionary<String, Int>[]? = self.swipeLine(line, dir:dir)
            
            if let l = swipedLine? {
                isChanged = true
                for (idx,num) in enumerate(l) {
                    switch dir {
                    case .Right:
                        movementBoard[line][boardSize-1-num["from"]!] = ["x":boardSize-1-num["to"]!, "y":line]
                        rawBoard[line][boardSize-1-idx] = num["num"]!
                    case .Left:
                        movementBoard[line][num["from"]!] = ["x":num["to"]!, "y":line]
                        rawBoard[line][idx] = num["num"]!
                    case .Up:
                        movementBoard[num["from"]!][line] = ["x":line, "y":num["to"]!]
                        rawBoard[idx][line] = num["num"]!
                    case .Down:
                        movementBoard[boardSize-1-num["from"]!][line] = ["x":line, "y":boardSize-1-num["to"]!]
                        rawBoard[boardSize-1-idx][line] = num["num"]!
                    }
                }
            } else {
                for i in 0..boardSize {
                    switch dir {
                    case .Right, .Left:
                        movementBoard[line][i] = ["x":i, "y":line]
                    case .Up, .Down:
                        movementBoard[i][line] = ["x":line, "y":i]
                    }
                }
            }
        }
        
        println(rawBoard)
        
        if isChanged { return true }
        else { return false }
        
    }
    
    func swipeLine(line:Int, dir:Direction) -> Dictionary<String, Int>[]? {
        
        var isChanged = false
        
        var numbers = Dictionary<String, Int>[]()
        for i in 0..boardSize {
            switch dir {
            case .Right:
                numbers += ["num":rawBoard[line][boardSize-1-i], "from":i, "to":i]
            case .Left:
                numbers += ["num":rawBoard[line][i], "from":i, "to":i]
            case .Up:
                numbers += ["num":rawBoard[i][line], "from":i, "to":i]
            case .Down:
                numbers += ["num":rawBoard[boardSize-1-i][line], "from":i, "to":i]
            }
        }
        
        var num = 0
        while num < boardSize-1 {
            if(numbers[num]["num"] == 0 && numbers[num+1]["num"] > 0){
                isChanged = true
                numbers[num+1]["to"] = num
                let tempNum = numbers[num+1]
                numbers[num+1] = numbers[num]
                numbers[num] = tempNum
                num = 0 // need?
            }else{
                ++num
            }
        }
        
        var i = 0
        while(i < numbers.count - 1){
            if(numbers[i]["num"] == numbers[i+1]["num"] && numbers[i]["num"] != 0){
                isChanged = true
                numbers[i]["num"] = numbers[i]["num"]! * 2
                numbers[i]["to"] = i
                numbers[i+1]["num"] = 0
                numbers[i+1]["to"] = i
                ++i
            }
            ++i
        }
        
        num = 0
        while num < boardSize-1 {
            if(numbers[num]["num"] == 0 && numbers[num+1]["num"] > 0){
                isChanged = true
                if(num+2 < boardSize && numbers[num+1]["to"] == numbers[num+2]["to"]){
                    numbers[num+2]["to"] = num
                }
                numbers[num+1]["to"] = num
                let tempNum = numbers[num+1]
                numbers[num+1] = numbers[num]
                numbers[num] = tempNum
                num = 0
            }else{
                ++num
            }
        }
        
        if isChanged { return numbers }
        else { return nil }
        
    }
    
    func getEmptyPositions() -> Int[]{
        var results = Int[]()
        
        for y in 0..boardSize {
            for x in 0..boardSize {
                if(rawBoard[y][x] == 0){
                    results += y*boardSize + x
                }
            }
        }
        return results;
    }
    
    func generateNumber() -> Int{
        let empties:Int[] = self.getEmptyPositions()
        
        let randomNum = arc4random_uniform(UInt32(empties.count))
        let randomPos = empties[Int(randomNum)]
        let y = randomPos / boardSize
        let x = randomPos % boardSize
        rawBoard[y][x] = 2
        
        return randomPos
    }
    
//    func undo(){
//        if(turn > 0){
//            rawBoard = self.updateLog[turn-1][0].copy()
//            self.updateLog.removeAtIndex(turn)
//        }
//    }
    
//    func isGameOver() -> Bool{
//        
//        for y in 0..boardSize {
//            for x in 0..boardSize {
//                if(rawBoard[y][x] == 0){
//                    return false
//                }
//            }
//        }
//        
//        for dir in [Direction.Right, Direction.Up]{
//            if(swipeBoard(dir)){
//                self.undo()
//                return false
//            }
//        }
//        
//        return true
//        
//    }
    
}
