//
//  TransitionAnimation.swift
//  
//
//  Created by caimengnan on 2018/9/17.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

import UIKit

var default_scale:CGFloat = 0.90 //初始缩放值

enum JumpType {
    case push
    case pop
    case present
    case dismiss
}

class TransitionAnimation: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    var animationType:JumpType?
    var fromVC = UIViewController()
    var toVC = UIViewController()
    let timeInterval = 0.3
    var interactive = false
    
    var fromView:UIView!
    var toView:UIView!
    
    var storedContext: UIViewControllerContextTransitioning?
    private var pausedTime: CFTimeInterval = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        switch animationType {
        case .push?:
            pushAnimation(transitionContext: transitionContext)
        default:
            popAnimation(transitionContext: transitionContext)
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        storedContext = transitionContext
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        fromVC = fromViewController
        toVC = toViewController
        
        self.toView = toViewController.view
        self.fromView = fromViewController.view
        self.toView.transform = CGAffineTransform(scaleX: default_scale, y: default_scale)
        
    }
    
    override func update(_ percentComplete: CGFloat) {
        if storedContext == nil {
            return
        }
        guard self.toView != nil,self.fromView != nil else {
            return
        }
        self.fromView?.frame = CGRect(x: kWidth * percentComplete, y: 0, width: kWidth, height: kHeight)
        let gap_scale = (1 - default_scale) * percentComplete
        let scale = default_scale + gap_scale
        self.toView.transform = CGAffineTransform(scaleX: scale, y: scale)
        storedContext?.updateInteractiveTransition(percentComplete)
    }
    
    func cancel(completedClosure:@ escaping ()->()) {
        
        guard self.toView != nil,self.fromView != nil else {
            completedClosure()
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fromView?.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
            self.toView.transform = CGAffineTransform(scaleX: default_scale, y: default_scale)
        }) { (completed) in
            self.storedContext?.cancelInteractiveTransition()
            self.storedContext?.completeTransition(false)
            self.storedContext = nil
            self.toView = nil
            self.fromView = nil
            self.toVC.view.transform = .identity
            completedClosure()
        }
    }
    
    func finish(completedClosure:@ escaping ()->()) {
        
        guard self.toView != nil,self.fromView != nil else {
            completedClosure()
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fromView?.frame = CGRect(x: kWidth, y: 0, width: kWidth, height: kHeight)
            self.toView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }) { (completed) in
            self.storedContext?.finishInteractiveTransition()
            self.storedContext?.completeTransition(true)
            self.storedContext = nil
            self.toView = nil
            self.fromView = nil
            completedClosure()
        }
    }
    
    
    func pushAnimation(transitionContext:UIViewControllerContextTransitioning) {
        
        //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC，fromVC就是转场前的VC
        
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) is BaseNaviViewController {
            let baseNav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseNaviViewController
            fromVC = (baseNav?.viewControllers.last)!
        } else {
            fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        }
        
        //引入containerView
        let containerView = transitionContext.containerView
        
        fromVC.tabBarController?.tabBar.isHidden = true
        
        toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        containerView.addSubview(toVC.view)
        containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        
        var fromView:UIView!
        var toView:UIView!
        fromView = fromVC.view
        toView = toVC.view
        let frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        fromView.frame = frame
        toView.frame = CGRect(x: kWidth, y: 0, width: kWidth, height: kHeight)
        
        UIView.animate(withDuration: timeInterval, animations: {
            fromView.transform = CGAffineTransform(scaleX: default_scale, y: default_scale)
            toView.frame = frame
        }) { (finished) in
            transitionContext.completeTransition(true)
            //transform还原
            self.fromVC.view.transform = .identity
        }
        
    }
    
    func popAnimation(transitionContext:UIViewControllerContextTransitioning) {
        //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC，fromVC就是转场前的VC
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) is BaseNaviViewController {
            let baseNav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseNaviViewController
            fromVC = (baseNav?.viewControllers.last)!
        } else  {
            fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        }
        toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        toVC.tabBarController?.tabBar.isHidden = true
        //引入containerView
        let containerView = transitionContext.containerView
        
        var fromView:UIView!
        var toView:UIView!
        containerView.insertSubview(toVC.view, belowSubview:fromVC.view)
        fromView = fromVC.view
        toView = toVC.view
        let frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        fromView.frame = frame
        toView.frame = frame
        toView.transform = CGAffineTransform(scaleX: default_scale, y: default_scale)
        
        UIView.animate(withDuration: timeInterval, animations: {
            toView.transform = .identity
            fromView.frame = CGRect(x: kWidth, y: 0, width: kWidth, height: kHeight)
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }

    
    
}
