//
//  GameViewController.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 6/26/14.
//  Copyright (c) 2014 HackerMeetings. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var boardView: UIView

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews(){
        println(__FUNCTION__)
        for y in 0..4 {
            for x in 0..4 {
                let tileSize:CGFloat = boardView.frame.size.width / 4
                let tile = TileLabel(frame:CGRectMake(tileSize * CGFloat(x), tileSize * CGFloat(y), tileSize, tileSize))
                boardView.addSubview(tile)
            }
        }
    }

}
