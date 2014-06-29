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
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.textAlignment = .Center
        
    }
    
    func getHue(num:Int, hue:CGFloat = 60) -> CGFloat{
        if(num < 2){ return hue }
        if(hue == 360){ return getHue(num / 2, hue: 24 ) }
        return getHue(num / 2, hue: hue + 24 )
    }
    
    func setNumber(num:Int){
        if num == 0 {
            self.text = ""
            self.backgroundColor = UIColor.clearColor()
        } else {
            self.text = String(num)
            self.backgroundColor = UIColor(hue: getHue(num)/360, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
    }
    
    func moveTo(pos:Point){
        let size = self.frame.size.width
        self.frame = CGRectMake( size * CGFloat(pos["x"]!), size * CGFloat(pos["y"]!), size, size )
    }
}
