//
//  TwoViewController.swift
//  仿今日头条转场效果
//
//  Created by caimengnan on 2018/9/26.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController{
    
    lazy var pushBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("PUSH", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        btn.center = CGPoint(x: self.view.center.x-100, y: self.view.center.y)
        btn.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var popBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("POP", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        btn.center = CGPoint(x: self.view.center.x+100, y: self.view.center.y)
        btn.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "detail"))
        imageView.frame = self.view.bounds
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(pushBtn)
        view.addSubview(popBtn)
    }
    
    @objc func pushAction() {
        let threeVC = ThreeViewController()
        navigationController?.pushViewController(threeVC, animated: true)
    }
    
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("释放")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
