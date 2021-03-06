//
//  NotificationCenter.swift
//  Ketch
//
//  Created by Tony Xiao on 4/8/15.
//  Copyright (c) 2015 Ketch. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
    class Proxy {
        let queue : NSOperationQueue
        let center : NSNotificationCenter
        var observers : [NSObjectProtocol] = []
        
        init(center: NSNotificationCenter, queue: NSOperationQueue = NSOperationQueue.mainQueue()) {
            self.center = center
            self.queue = queue
        }
        
        deinit {
            observers.map { self.center.removeObserver($0) }
        }
        
        func listen(name: String, object: AnyObject? = nil, block: (NSNotification) -> ()) {
            observers += center.addObserverForName(name, object: object, queue: queue) { note in
                block(note)
            }
        }
    }
    
    func proxy() -> Proxy {
        return Proxy(center: self)
    }
}