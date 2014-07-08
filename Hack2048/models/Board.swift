//
//  Board.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/28/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

let BOARD_SIZE = 4

class Board: NSObject {
   
    var rawBoard = [[Int]]()  // board state
    var movementBoard = [Points]()
    var turn:Int = 0
    var updateLog = [[[Int]]]()  // board history
    
    init(){
        super.init()
        for _ in 0..<BOARD_SIZE {
            rawBoard += [Int](count: BOARD_SIZE, repeatedValue: 0)
            movementBoard += Points(count:BOARD_SIZE, repeatedValue:Point(0, 0))
        }
        updateLog += rawBoard
    }
    
    // start a new game
    func initGame(){
        for y in 0..<BOARD_SIZE {
            for x in 0..<BOARD_SIZE {
                rawBoard[y][x] = 0
            }
        }
        updateLog = [[[Int]]]()
        updateLog += rawBoard
        turn = 0
    }
    
    func swipeBoard(dir:Direction, virtual:Bool = false) -> Bool {
        var isChanged = false
        for line in 0..<BOARD_SIZE {
            let swipedLine:[[String:Int]]? = self.swipeLine(line, dir:dir)
            
            if let l = swipedLine {
                isChanged = true
                if !virtual {
                    for (idx,num) in enumerate(l) {
                        switch dir {
                        case .Right:
                            movementBoard[line][BOARD_SIZE-1-num["from"]!] = Point(BOARD_SIZE-1-num["to"]!, line)
                            rawBoard[line][BOARD_SIZE-1-idx] = num["num"]!
                        case .Left:
                            movementBoard[line][num["from"]!] = Point(num["to"]!, line)
                            rawBoard[line][idx] = num["num"]!
                        case .Up:
                            movementBoard[num["from"]!][line] = Point(line, num["to"]!)
                            rawBoard[idx][line] = num["num"]!
                        case .Down:
                            movementBoard[BOARD_SIZE-1-num["from"]!][line] = Point(line, BOARD_SIZE-1-num["to"]!)
                            rawBoard[BOARD_SIZE-1-idx][line] = num["num"]!
                        }
                    }
                }
            } else if(!virtual) {
                for i in 0..<BOARD_SIZE {
                    switch dir {
                    case .Right, .Left:
                        movementBoard[line][i] = Point(i, line)
                    case .Up, .Down:
                        movementBoard[i][line] = Point(line, i)
                    }
                }
            }
        }
        
        if isChanged {
            if !virtual{
                updateLog += rawBoard
                ++turn
            }
            return true
        }
        else { return false }
        
    }
    
    func swipeLine(line:Int, dir:Direction) -> [Dictionary<String, Int>]? {
        
        var isChanged = false
        
        var numbers = [Dictionary<String, Int>]()
        for i in 0..<BOARD_SIZE {
            switch dir {
            case .Right:
                numbers += ["num":rawBoard[line][BOARD_SIZE-1-i], "from":i, "to":i]
            case .Left:
                numbers += ["num":rawBoard[line][i], "from":i, "to":i]
            case .Up:
                numbers += ["num":rawBoard[i][line], "from":i, "to":i]
            case .Down:
                numbers += ["num":rawBoard[BOARD_SIZE-1-i][line], "from":i, "to":i]
            }
        }
        
        var num = 0
        while num < BOARD_SIZE-1 {
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
        while num < BOARD_SIZE-1 {
            if(numbers[num]["num"] == 0 && numbers[num+1]["num"] > 0){
                isChanged = true
                if(num+2 < BOARD_SIZE && numbers[num+1]["to"] == numbers[num+2]["to"]){
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
    
    func getEmptyPositions() -> [Int]{
        var results = [Int]()
        
        for y in 0..<BOARD_SIZE {
            for x in 0..<BOARD_SIZE {
                if(rawBoard[y][x] == 0){
                    results += y*BOARD_SIZE + x
                }
            }
        }
        return results;
    }
    
    func generateNumber() -> Int{
        let empties = self.getEmptyPositions()
        
        let randomNum = arc4random_uniform(UInt32(empties.count))
        let randomPos = empties[Int(randomNum)]
        let y = randomPos / BOARD_SIZE
        let x = randomPos % BOARD_SIZE
        
        self.setNumber(x, y)
        
        return randomPos
    }
    
    func setNumber(x:Int, _ y:Int) {
        rawBoard[y][x] = 2
        
        updateLog += rawBoard
        ++turn
    }
    
    func undo(){
        if(turn > 0){
            rawBoard = self.updateLog[turn-1]
            self.updateLog.removeAtIndex(turn)
            --turn
        }
    }
    
    // where can the board swipe?
    func swipableDirections() -> [Direction]{
        
        var results = [Direction]()
        for dir in [Direction.Left, Direction.Down, Direction.Right, Direction.Up]{
            if swipeBoard(dir, virtual:true){
                results += dir
            }
        }
        return results
    }
    
    func isGameOver() -> Bool{
        
        for y in 0..<BOARD_SIZE {
            for x in 0..<BOARD_SIZE {
                if(rawBoard[y][x] == 0){
                    return false
                }
            }
        }
        
        for dir in [Direction.Right, Direction.Up]{
            if swipeBoard(dir, virtual:true){
                return false
            }
        }
        
        return true
    }
    
    func AIswipeBoard(dir:Direction) {
        for line in 0..<BOARD_SIZE {
            let swipedLine = self.AIswipeLine(line, dir:dir)
            var idx = 0
            for i in 0..<BOARD_SIZE {
                var num = 0
                if swipedLine.count > i {
                    num = swipedLine[i]
                }
                switch dir {
                case .Right:
                    rawBoard[line][BOARD_SIZE-1-idx] = num
                case .Left:
                    rawBoard[line][idx] = num
                case .Up:
                    rawBoard[idx][line] = num
                case .Down:
                    rawBoard[BOARD_SIZE-1-idx][line] = num
                }
                ++idx
            }
        }
        
        updateLog += rawBoard
        ++turn
    }
    
    func AIswipeLine(line:Int, dir:Direction) -> [Int] {
        
        var numbers = [Int]()
        for i in 0..<BOARD_SIZE {
            var num = 0
            switch dir {
            case .Right:
                num = rawBoard[line][BOARD_SIZE-1-i]
            case .Left:
                num = rawBoard[line][i]
            case .Up:
                num = rawBoard[i][line]
            case .Down:
                num = rawBoard[BOARD_SIZE-1-i][line]
            }
            if num > 0 {
                numbers += num
            }
        }
        
        var i = 0
        while(i < numbers.count - 1){
            if(numbers[i] == numbers[i+1] && numbers[i] != 0){
                numbers[i] = numbers[i] * 2
                numbers.removeAtIndex(i+1)
            }
            ++i
        }
        
        return numbers
        
    }
    
}
