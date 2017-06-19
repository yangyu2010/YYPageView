//
//  YYPageView.swift
//  YYPageView
//
//  Created by Young on 2017/4/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

public class YYPageView: UIView {

    // MARK:-属性
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var titleStyle: YYTitleViewStyle
    
    // MARK:-视图
    fileprivate var titleView: YYTitleView!
    
    // MARK:-初始化
    public init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, titleStyle : YYTitleViewStyle) {
        self.titles = titles
        self.childVcs  = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK:-UI
extension YYPageView {
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        titleView = YYTitleView(frame: frame, titles: titles, style: titleStyle)
        addSubview(titleView)
    }
    
    private func setupContentView() {
        let frame = CGRect(x: 0, y: titleStyle.titleViewHeight, width: bounds.width, height: bounds.height - titleStyle.titleViewHeight)
        let contentView = YYContentView(frame: frame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
