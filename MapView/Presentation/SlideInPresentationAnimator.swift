//
//  SlideInPresentationAnimator.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/28/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SlideInPresentationAnimator: NSObject {

    let direction: PresentationDirection
    
    let isPresentation: Bool
    
    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        
        guard let controller = transitionContext.viewController(forKey: key)
            else { return }
        
        // 2
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        // 3
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        // 4
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        // 5
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                controller.view.frame = finalFrame
        }, completion: { finished in
            if !self.isPresentation {
                controller.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        })
    }

    
}
