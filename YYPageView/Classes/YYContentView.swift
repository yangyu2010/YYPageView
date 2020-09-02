//
//  YYContentView.swift
//  YYPageView
//
//  Created by Young on 2017/4/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

private let kContentViewCellID = "kContentViewCellID"

protocol YYContentViewDelegate : class {
    func yyContentView(_ contentView: YYContentView, targetIndex: Int)
    func yyContentView(_ contentView: YYContentView, targetIndex: Int, progress: CGFloat)
}

class YYContentView: UIView {

    // MARK:-属性
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    weak var delegate: YYContentViewDelegate?
    
    /// 记录开始滑动的位置
    fileprivate lazy var startOffsetX: CGFloat = 0
    fileprivate lazy var isForbidScroll : Bool = false
    
    // MARK:-控件
    fileprivate lazy var contentCollecView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let contentCollecView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        contentCollecView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentViewCellID)
        contentCollecView.isPagingEnabled = true
        contentCollecView.bounces = false
        contentCollecView.scrollsToTop = false
        contentCollecView.showsHorizontalScrollIndicator = false
        contentCollecView.dataSource = self
        contentCollecView.delegate = self
        return contentCollecView
    }()
    
    // MARK:-初始化
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:-UI
extension YYContentView {
    fileprivate func setupUI() {
        
        for childVc in childVcs {
            parentVc.addChild(childVc)
        }
        
        addSubview(contentCollecView)

    }
}

// MARK:-DataSource
extension YYContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:-Delegate
extension YYContentView : UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentViewEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate {
            contentViewEndScroll()
        }else {
            scrollView.isScrollEnabled = false
        }
    }
    
    
    /// scrollView停止滚动的时候 通知titleView 调整位置和颜色
    private func contentViewEndScroll() {
        
        guard !isForbidScroll else { return }
        
        let currentIndex = Int(contentCollecView.contentOffset.x / contentCollecView.bounds.width)
        delegate?.yyContentView(self, targetIndex: currentIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 滑动的时候 让处理代理
        isForbidScroll = false
        
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.判断条件,
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else {
            return
        }
        
        // 2.定义初始值
        var targetIndex: Int = 0
        var progress: CGFloat = 0
        
        // 3.计算出当前位置
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        
        // 4.判断是左滑还是右滑动
        if startOffsetX < scrollView.contentOffset.x {
            // 左滑动 index变大
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        }else {
            // 右滑动 index变小
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 5.通知代理
        delegate?.yyContentView(self, targetIndex: targetIndex, progress: progress)
    }
}

// MARK:-TitleViewDelegate
extension YYContentView : YYTitleViewDelegate {
    func yyTitleViewClick(_ titleView: YYTitleView, targetIndex: Int) {
        
        // 点击titleView label时, 不然触发scrollView代理
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        contentCollecView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
