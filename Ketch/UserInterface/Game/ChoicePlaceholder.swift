//
//  ChoicePlaceholder.swift
//  Ketch
//
//  Created by Tony Xiao on 2/28/15.
//  Copyright (c) 2015 Ketch. All rights reserved.
//

import Foundation

class ChoicePlaceholder : UIImageView {
    @IBInspectable var rawChoice: String!
    var choice : Candidate.Choice {
        return Candidate.Choice(rawValue: rawChoice)!
    }
    var emphasized: Bool = false { didSet { updateAlphaAndTint() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image = image?.imageWithRenderingMode(.AlwaysTemplate)
        updateAlphaAndTint()
    }
    
    func updateAlphaAndTint() {
        if emphasized {
            alpha = 1
            tintColor = UIColor.whiteColor()
        } else {
            alpha = 0.4
            tintColor = StyleKit.teal
        }
    }
    
    func animateEmphasis(emphasized: Bool, delay: NSTimeInterval = 0) {
        UIView.animate(0.4, delay: delay) {
            self.emphasized = emphasized
        }
    }
}