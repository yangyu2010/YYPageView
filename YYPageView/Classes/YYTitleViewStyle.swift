//
//  YYTitleViewStyle.swift
//  YYPageView
//
//  Created by Young on 2017/4/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

public class YYTitleViewStyle {
    
    public init() {
        
    }
    
    /// titleView高度
    public var titleViewHeight: CGFloat = 44
    
    /// 默认颜色-必须是RGB格式
    public var normalColor: UIColor = UIColor(r: 0, g: 0, b: 0)
    
    /// 选中颜色-必须是RGB格式
    public var selectColor: UIColor = UIColor(r: 255, g: 127, b: 0)
    
    /// 字体
    public var fontSize: CGFloat = 15
    
    /// 是否可以滚动
    public var isScrollEnble: Bool = false
    
    /// 间距
    public var itemMargin: CGFloat = 20
    
    /// 是否显示底部横线
    public var isShowScrollLine: Bool = false
    
    /// 横线高度
    public var scrollLineHeight: CGFloat = 2
    
    /// 横线颜色
    public var scrollLineColor: UIColor = .orange
    
}
