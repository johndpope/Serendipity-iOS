//
//  DiscoverViewController.swift
//  Serendipity
//
//  Created by Tony Xiao on 1/28/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import UIKit
import ObjectiveDDP

@objc(DiscoverViewController)
class DiscoverViewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profile = storyboard?.instantiateViewControllerWithIdentifier("Profile") as UIViewController
        addChildViewController(profile)
        view.insertSubview(profile.view, atIndex: 0)
        profile.view.frame = view.bounds
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        performSegueWithIdentifier("DiscoverToSettings", sender: sender)
    }
    
    @IBAction func showConnections(sender: AnyObject) {
        performSegueWithIdentifier("DiscoverToConnections", sender: sender)
    }
}
