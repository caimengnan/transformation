//
//  ThreeViewController.swift
//  仿今日头条转场效果
//
//  Created by caimengnan on 2018/9/26.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController {

    
    lazy var popBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("POP", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        btn.center = self.view.center
        btn.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "girl"))
        imageView.frame = self.view.bounds
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(imageView)
        view.addSubview(popBtn)
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
