//
//  BaseNaviViewController.swift
//  
//
//  Created by caimengnan on 2018/9/12.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

import UIKit

class BaseNaviViewController: UINavigationController,UINavigationControllerDelegate {

    //滑动进度
    var percentComplete:CGFloat = 0.0
    // 区分是手势交互还是直接pop/push
    var isInteractive:Bool?
    //添加标识，防止暴力操作
    var hold:Bool = false
    //自定义滑动动画类
    lazy var transitionAnimation:TransitionAnimation = {
        var transitionAnimation = TransitionAnimation()
        return transitionAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.navigationBar.isHidden = true
        self.delegate = self
        addPanGestureAction()
    }
    
    //添加侧滑手势
    private func addPanGestureAction() {
        let ges = UIPanGestureRecognizer(target: self, action: #selector(edgTapAction))
        self.view.addGestureRecognizer(ges)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}


//MARK: add tap action
extension BaseNaviViewController {
    //侧滑事件
    @objc func edgTapAction(ges:UIPanGestureRecognizer) {
        //找到当前点
        let translation = ges.translation(in: ges.view)
        percentComplete = abs(translation.x/kWidth)
        //滑动比例
        percentComplete = min(max(percentComplete, 0.01), 0.99)
        if translation.x < 0 {  //手势左滑的状态相当于滑动比例为0，
            percentComplete = 0.0
        }
        
        switch ges.state {
        case .began:
            isInteractive = true
            let currentVCArray = self.viewControllers
            if (currentVCArray.count) > 1 {
                self.popViewController(animated: true)
            }
        case .changed:
            self.transitionAnimation.update(CGFloat(percentComplete))
        case .ended,.cancelled:
            isInteractive = false
            ges.isEnabled = false
            if percentComplete >= 0.5 {
                self.transitionAnimation.finish {
                    ges.isEnabled = true
                }
            } else {
                self.transitionAnimation.cancel {
                    ges.isEnabled = true
                }
            }
        default:
            break
        }
    }
}


//MARK: nav delegate
extension BaseNaviViewController {
    //处理push/pop过渡动画
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            self.transitionAnimation.animationType = .push
        } else if operation == .pop {
            self.transitionAnimation.animationType = .pop
        }
        return self.transitionAnimation
        
    }
    
    //pop手势百分比
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.transitionAnimation.animationType == .pop {
            let gestureMove = isInteractive == true ? self.transitionAnimation : nil
            return gestureMove
        }
        return nil
    }
}
