//
//  TileLabel.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/26/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

class TileLabel: UILabel {
    init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.textAlignment = .Center
        
    }
}
