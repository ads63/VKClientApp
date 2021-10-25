//
//  NavigationControllerAnimation.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 20.09.2021.
//

import UIKit

final class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private let animateTime = 1.0

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        animateTime
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning)
    {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }

        transitionContext.containerView.addSubview(destination.view)

        destination.view.frame = transitionContext.containerView.frame
        destination.view.center.x += source.view.frame.width/2
        destination.view.center.y -= source.view.frame.height/2
        destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        destination.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)

        UIView.animateKeyframes(
            withDuration: animateTime,
            delay: 0.0,
            options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 1.0) {
                    destination.view.transform = CGAffineTransform(rotationAngle: 0)
                }
        } completion: { isCompleted in
            if isCompleted, !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                destination.view.transform = .identity
            }

            transitionContext.completeTransition(isCompleted &&
                !transitionContext.transitionWasCancelled)
        }
    }
}

final class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private let animateTime = 1.0

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        animateTime
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning)
    {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }

        transitionContext.containerView.insertSubview(
            destination.view,
            belowSubview: source.view)

        source.view.frame = transitionContext.containerView.frame
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)

        UIView.animateKeyframes(
            withDuration: animateTime,
            delay: 0.0,
            options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 1.0) {
                    source.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                }
        } completion: { isCompleted in
            if isCompleted, !transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
                source.view.transform = .identity
            }

            transitionContext.completeTransition(isCompleted &&
                !transitionContext.transitionWasCancelled)
        }
    }
}
