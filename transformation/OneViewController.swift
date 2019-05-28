//
//  ViewController.swift
//  仿今日头条转场效果
//
//  Created by caimengnan on 2018/9/26.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

import UIKit

class OneViewController: UIViewController {
    
    
    lazy var pushBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("PUSH", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        btn.center = self.view.center
        btn.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home"))
        imageView.frame = self.view.bounds
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(imageView)
        view.addSubview(pushBtn)
    }
    
    
    @objc func pushAction() {
        let twoVC = TwoViewController()
        navigationController?.pushViewController(twoVC, animated: true)
    }
    
    
    deinit {
        print("释放")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
