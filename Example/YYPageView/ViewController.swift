//
//  ViewController.swift
//  YYPageView
//
//  Created by yangyu2010@aliyun.com on 06/19/2017.
//  Copyright (c) 2017 yangyu2010@aliyun.com. All rights reserved.
//

import UIKit
import YYPageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        automaticallyAdjustsScrollViewInsets = false
        
        let titles = ["趣玩", "发", "颜值美女女", "美女养眼美女", "运动动", "周边美女", "美女养眼美女", "运动动", "周边美女"]
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.yy_randomColor()
            childVcs.append(vc)
        }
        
        let style = YYTitleViewStyle()
        style.isScrollEnble = true
        style.isShowScrollLine = true
        
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let pageView = YYPageView(frame: frame, titles: titles, childVcs: childVcs, parentVc: self, titleStyle: style)
        
        view.addSubview(pageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

