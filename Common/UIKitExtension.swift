//
//  UIKitExtension.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/6/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Snap

extension UIView {
    func makeCircular() {
        layer.cornerRadius = max(frame.size.width, frame.size.height) / 2
        layer.masksToBounds = true
    }
    
    func makeEdgesEqualTo(view: UIView) {
        snp_makeConstraints { (make) -> () in
            make.edges.equalTo(view)
            return // Hack needed to compile
        }
    }
    
    func whenTapped(block: () -> ()) {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.rac_gestureSignal().subscribeNextAs { (recognizer : UIGestureRecognizer) -> () in
            if recognizer.state == .Ended {
                block()
            }
        }
        addGestureRecognizer(tap)
    }
}
