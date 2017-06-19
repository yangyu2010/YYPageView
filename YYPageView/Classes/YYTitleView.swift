//
//  YYTitleView.swift
//  YYPageView
//
//  Created by Young on 2017/4/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

protocol YYTitleViewDelegate : class {
    func yyTitleViewClick(_ titleView: YYTitleView, targetIndex: Int)
}

class YYTitleView: UIView {

    // MARK:-属性
    fileprivate var titles: [String]
    fileprivate var style: YYTitleViewStyle
    fileprivate lazy var labels: [UILabel] = [UILabel]()
    fileprivate lazy var currentIndex: Int = 0

    weak var delegate: YYTitleViewDelegate?
    
    // MARK:-控件
    fileprivate lazy var backScrollView: UIScrollView = {
        let backScrollView = UIScrollView(frame: self.bounds)
        backScrollView.showsVerticalScrollIndicator = false
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.scrollsToTop = false
        return backScrollView
    }()
    
    /// 底部横线
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.backScrollView.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    
    // MARK:-初始化
    init(frame: CGRect, titles: [String], style: YYTitleViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK:-UI
extension YYTitleView {
    fileprivate func setupUI() {
        addSubview(backScrollView)
        setupTitleLabels()
        setupTitleLabelsFrame()
        if style.isShowScrollLine {
            backScrollView.addSubview(bottomLine)
        }
    }
    
    /// 添加label
    private func setupTitleLabels() {
        for i in 0..<titles.count {
            let lab = UILabel()
            lab.text = titles[i]
            lab.textColor = i == 0 ? style.selectColor : style.normalColor
            lab.textAlignment = .center
            lab.font = UIFont.systemFont(ofSize: style.fontSize)
            lab.tag = i
            labels.append(lab)
            backScrollView.addSubview(lab)
            
            lab.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tap:)))
            lab.addGestureRecognizer(tap)
        }
        
    }
    
    /// 设置label的frame
    private func setupTitleLabelsFrame() {
        
        let count = labels.count
        
        for i in 0..<count {
            let lab = labels[i]
            
            var x : CGFloat = 0
            let y : CGFloat = 0
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            
            if style.isScrollEnble {
                // 可以滑动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : lab.font], context: nil).width
                if i == 0 {
                    x = style.itemMargin * 0.5
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                }else {
                    x = labels[i - 1].frame.maxX + style.itemMargin
                }
                
            }else {
                // 不能滑动
                w = bounds.width / CGFloat(count)
                x = CGFloat(i) * w
                
                if (i == 0) && (style.isShowScrollLine) {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
                
            }
            
            lab.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        backScrollView.contentSize = style.isScrollEnble ? CGSize(width: labels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK:-Method
extension YYTitleView {
    
    /// titleLabel点击事件
    ///
    /// - Parameter tap: 手势tap
    @objc fileprivate func titleLabelClick(tap: UITapGestureRecognizer) {
        
        // 取出当前和原来的label
        guard let targetLabel = tap.view as? UILabel else { return }

        // 调整
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        // 滑动bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            }
        }
                                                                      
        // 通知contentView滚动
        delegate?.yyTitleViewClick(self, targetIndex: currentIndex)
        
    }
    
    
    /// 调整titleLabel的文字颜色 和 移动到中间位置
    ///
    /// - Parameter targetIndex: 目标位置
    fileprivate func adjustTitleLabel(targetIndex: Int) {
        
        guard targetIndex != currentIndex else {
            return
        }
        
        // 取出当前和原来的label
        let targetLabel = labels[targetIndex]
        let sourceLabel = labels[currentIndex]
        
        // 改变label文字颜色
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        // 更新当前label下表
        currentIndex = targetLabel.tag
        
        // 偏移scrollView
        if style.isScrollEnble {
            var offsetX = targetLabel.center.x - backScrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > (backScrollView.contentSize.width - backScrollView.bounds.width) {
                offsetX = backScrollView.contentSize.width - backScrollView.bounds.width
            }
            backScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
    }
}

// MARK:-ContentViewDelegate
extension YYTitleView: YYContentViewDelegate {
    func yyContentView(_ contentView: YYContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func yyContentView(_ contentView: YYContentView, targetIndex: Int, progress: CGFloat) {
        // 1.取出当前和原来的label
        let targetLabel = labels[targetIndex]
        let sourceLabel = labels[currentIndex]
        
        // 2.颜色渐变
        let deltaRGB = UIColor.yy_getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.yy_getRGB()
        let noramlRGB = style.normalColor.yy_getRGB()
        targetLabel.textColor = UIColor(r: noramlRGB.0 + deltaRGB.0 * progress, g: noramlRGB.1 + deltaRGB.1 * progress, b: noramlRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        // 3.移动底部line
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
       
    }
}
