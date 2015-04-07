//
//  GameViewController.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/10/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import Foundation

@objc(GameViewController)
class GameViewController : BaseViewController {
    
    @IBOutlet weak var dockBadge: UIImageView!
    var gameView: GameView! { return view as GameView }
    
    var candidates : [Candidate]! { willSet { assert(candidates == nil, "candidates are immutable") } }
    var bubbles : [CandidateBubble]!
    var buckets : [ChoiceBucket]!
    var boxes : [FloatBox]!
    
    override func commonInit() {
        hideKetchBoat = false
    }
    
    override func viewDidLoad() {
        assert(candidates.count == 3, "Must provide 3 candidates before loading GameVC")
        super.viewDidLoad()
        
         // TODO: Refactor me
        bubbles = gameView.bubbles
        buckets = gameView.buckets
        boxes = gameView.boxes
        
        // Setup tap to view profile
        for (i, bubble) in enumerate(bubbles) {
            bubble.candidate = candidates[i]
            // TODO: There is obvious memory leak here... Everything is retaining everything
            bubble.whenTapped {
                self.didTapOnCandidateBubble(bubble)
            }
//            bubble.backgroundColor = UIColor.greenColor()
            bubble.userInteractionEnabled = true
            bubble.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handleBubblePan:"))
        }
        gameView.didConfirmChoices = { [weak self] in
            if let this = self { this.submitChoices(this) }
        }

        gameView.helpText.hidden = true
        gameView.confirmButton.hidden = true
    }
    
    var dynamics : UIDynamicAnimator!
    var targets : [SnapTarget]!
    var collision : UICollisionBehavior!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Setup the game board with target positions acquired from autolayout
        if targets == nil {
            targets = boxes.map {  SnapTarget(view: $0) } + buckets.map { SnapTarget(view: $0) }
            for i in 0..<2 { // TODO: Remove this huge hack
                targets[i].bubble = bubbles[i]
            }
            dynamics = UIDynamicAnimator(referenceView: view)
            dynamics.delegate = self
//            for bubble in bubbles {
//                bubble.transform = CGAffineTransform(scale: 1.5)
//            }

//            dynamics.addBehavior(collision)
        }
    }

    
    // MARK: -
    
    private func assignBubbleToTarget(bubble: CandidateBubble, target: SnapTarget?) {
        let oldTarget = targets.match { $0.bubble == bubble }
        dynamics.removeBehavior(oldTarget?.snap)
        oldTarget?.snap = nil
        oldTarget?.bubble = nil
        
        if let target = target {
            target.bubble = bubble
            target.snap = UISnapBehavior(item: bubble, snapToPoint: target.center)
            dynamics.addBehavior(target.snap)
        }
    }
    
    private func closestTarget(point: CGPoint) -> SnapTarget {
        let freeTargets = targets.filter { $0.bubble == nil }
        return freeTargets.minElement { Float($0.center.distanceTo(point)) }!
    }
    
    func handleBubblePan(pan: UIPanGestureRecognizer) {
        var location = pan.locationInView(view)
        let bubble = pan.view as CandidateBubble
        switch pan.state {

        case .Began:
//            bubble.transform = CGAffineTransform(scale: 1.5)
//            bubble.frame = bubble.frame.scaleFromCenter(1.5)
            assignBubbleToTarget(bubble, target: nil)
            collision = UICollisionBehavior(items: bubbles)
            collision.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(inset: -50))
            collision.collisionMode = .Everything
            dynamics.addBehavior(collision)
            bubble.drag = UIAttachmentBehavior(item: bubble, attachedToAnchor: location)
            dynamics.addBehavior(bubble.drag)
        case .Changed:
            bubble.drag?.anchorPoint = location
        case .Ended:
//            bubble.frame = bubble.frame.scaleFromCenter(1/1.5)
            dynamics.removeBehavior(collision)
            bubbles.map { self.dynamics.removeBehavior($0.drag) }
            
            let velocity = pan.velocityInView(view) * 0.1
            let expectedLocation = bubble.center + velocity
            let target = closestTarget(expectedLocation)
            assignBubbleToTarget(bubble, target: target)
//            bubble.transform = CGAffineTransformIdentity

        default:
            break
        }
    }
    
    // TODO: This can be made much better. We should directly handle a candidate rather than user.candidate
    func didTapOnCandidateBubble(bubble: CandidateBubble) {
        let users = candidates.map { $0.user! }
        let index = find(candidates, bubble.candidate!)!
        let pageVC = ProfileViewController.pagedController(users, initialPage: index)
        presentViewController(pageVC, animated: true)
    }
    
    @IBAction func submitChoices(sender: AnyObject) {
        if !gameView.isReady {
            UIAlertView.show("Error", message: "Need to uniquely assign keep match marry")
        } else {
            let marry = gameView.chosenCandidate(.Yes)!
            let keep = gameView.chosenCandidate(.Maybe)!
            let skip = gameView.chosenCandidate(.No)!
            Core.candidateService.submitChoices(marry, no: skip, maybe: keep).deliverOnMainThread().subscribeNextAs { (res : [String:String]) -> () in
                if res.count > 0 {
                    let connection = Connection.findByDocumentID(res["yes"]!)!
                    self.rootVC.showNewMatch(connection)
                }
            }
        }
    }

    // MARK: - Navigation Logic
    
    override func handleScreenEdgePan(edge: UIRectEdge) -> Bool {
        if edge == .Right {
            performSegue(.GameToDock)
            return true
        }
        return super.handleScreenEdgePan(edge)
    }
}

extension GameViewController : UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        println("Dynamics did pause")
        animator.removeAllBehaviors()
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        println("dynamics will resume")
    }
}

// MARK: - SnapTarget Definition

extension GameViewController {
    class SnapTarget {
        let center : CGPoint
        var bubble : CandidateBubble?
        var snap : UISnapBehavior?
        
        init(view: UIView) {
            center = view.center
        }
    }
}