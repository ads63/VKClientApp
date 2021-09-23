//
//  CustomNavigationController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 20.09.2021.
//

import UIKit

final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isStarted = false
    var isPosssible = false
    var shouldFinish = false
}

final class CustomNavigationController: UINavigationController,
    UINavigationControllerDelegate
{
    private let interactiveTransition = CustomInteractiveTransition()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let edgePanGR = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:)))
        edgePanGR.edges = .left
        view.addGestureRecognizer(edgePanGR)
    }
        
    @objc private func handlePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .possible:
            interactiveTransition.isPosssible = true
        case .began:
            interactiveTransition.isStarted = true
            popViewController(animated: true)
        case .changed:
            guard let width = recognizer.view?.bounds.width else {
                interactiveTransition.isStarted = false
                interactiveTransition.cancel()
                return
            }
                
            let translation = recognizer.translation(in: view)
            let relativeTranslation = translation.x / width
            let progress = max(0, min(relativeTranslation, 1))
            interactiveTransition.update(progress)
            interactiveTransition.shouldFinish = progress > 0.3
                
        case .ended:
            interactiveTransition.isStarted = false
            interactiveTransition.shouldFinish ?
                interactiveTransition.finish() :
                interactiveTransition.cancel()
                
        case
            .failed,
            .cancelled:
            interactiveTransition.isStarted = false
            interactiveTransition.cancel()
                
        default: break
        }
    }
        
    // MARK: NavigationController Delegate

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        switch operation {
        case .push:
            return PushAnimation()
        case .pop:
            return PopAnimation()
        default:
            return nil
        }
    }
        
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        interactiveTransition.isStarted ? interactiveTransition : nil
    }
}
