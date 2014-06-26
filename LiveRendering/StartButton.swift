//
//  StartButton.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/24/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

let APP_SIZE = UIScreen.mainScreen().applicationFrame.size

@IBDesignable class StartButton: UIButton {
    
    // cornerRadius
    @IBInspectable var radius:CGFloat = 20.0 { didSet {
        self.layer.cornerRadius = radius
    } }
    
    var p:CGFloat = 20.0 { didSet {
        self.center = CGPointMake(APP_SIZE.width/2, APP_SIZE.height/2)
    } }
    
}