//
//  Point.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 7/8/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

class Point {
    var num = 0
    
    var x:Int{
    get{ return num/4 }
    }
    
    var y:Int{
    get{ return num%4 }
    }
    
    init (_ x:Int, _ y:Int){
        num = y * BOARD_SIZE + x
    }
    
}

typealias Points = [Point]