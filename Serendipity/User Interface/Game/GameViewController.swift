//
//  GameViewController.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/10/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import Foundation
import UIView_draggable

@objc(GameViewController)
class GameViewController : BaseViewController {

    @IBOutlet var avatars: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Core.matchService.fetch.signal.subscribeNextAs { (matches : [Match]) -> () in
            for (i, imageView) in enumerate(self.avatars) {
                if i < matches.count {
                    imageView.sd_setImageWithURL(matches[i].user?.profilePhotoURL)
                } else {
                    imageView.image = nil
                }
            }
        }
        
        // Setup Drag & Drop
        for imageView in self.avatars {
            imageView.userInteractionEnabled = true
            imageView.enableDragging()
            imageView.setDraggable(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for imageView in avatars {
            imageView.contentMode = .ScaleToFill
            imageView.makeCircular()
        }
    }
    
    @IBAction func confirmChoices(sender: AnyObject) {
        for i in 0..<self.avatars.count {
            let match = Core.matchService.fetch.objects[i] as Match
            Core.matchService.passMatch(match)
        }
    }
    
}