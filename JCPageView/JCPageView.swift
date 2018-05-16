//
//  JCPageView.swift
//  JCScrollView
//
//  Created by 严伟 on 2018/5/14.
//  Copyright © 2018年 yW. All rights reserved.
//

import UIKit
import Then
import SnapKit

/// JCPageViewDelegate代理
public protocol JCPageViewDelegate {
    // item选中
    func selectedItem(index: Int)
}

extension JCPageViewDelegate {
    func selectedItem(index: Int) { }
}

// MARK: - 外部接口
extension JCPageView {
    
    
    /// 设置pageEnum的高度
    ///
    /// - Parameter height: 高度
    ///   - backgroundColor: 背景色
    public func setTitle(height: CGFloat = 48.0,
                         titleColor: UIColor = Color.selectedColor,
                         titleBackgroundColor: UIColor = .white) {
        headView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
        headView.backgroundColor = titleBackgroundColor
        for i in 0..<pageTitleArr.count {
            pageTitleArr[i].setTitleColor(titleColor, for: .normal)
        }
        headHeight = height
        setSelectedItem(index: lastIndex)
    }
    
    /// 设置分页线的颜色
    ///
    /// - Parameter color: 颜色
    public func setLineColor(_ color: UIColor = Color.selectedColor) {
        lineView.backgroundColor = color
    }
    
    /// 设置选中下标
    ///
    /// - Parameter index: 下标
    public func setSelectedItem(index: Int = 0) {
        let space = (Constant.screenWidth - totalWidth - minSpace) / CGFloat(pageTitleArr.count + 1)
        let offset = isPaging ? minSpace : space + minSpace
        let text = pageTitleArr[index].titleLabel?.text ?? ""
        let font = pageTitleArr[index].titleLabel?.font ?? Font.dp(15)
        lineView.frame = CGRect(x: offset, y: headHeight - lineHeight,
                                width: text.getWidth(font, 100), height: lineHeight)
        lastIndex = index
    }
    
    /// 设置pageView
    ///
    /// - Parameters:
    ///   - pageView: pageView
    ///   - index: 下标
    public func set(_ pageView: UIView, index: Int) {
        if index > pageViewArr.count {
            print("pageViewIndex越界")
        } else {
            pageViewArr[index].addSubview(pageView)
        }
    }
}

/// 分页视图
public class JCPageView: UIView {
    
    /// 代理
    public var delegate: JCPageViewDelegate?
    
    /// 初始化
    public init(frame: CGRect, _ titles: [String], font: UIFont = Font.dp(20)) {
        super.init(frame: frame)

        addSubview(contentScrollView)
        addSubview(headView)
        headView.addSubview(lineView)
        contentScrollView.delegate = self
        setupTitle(titles, font: font)
    }
    
    /// 设置page内容
    ///
    /// - Parameter title: page Title
    internal func setupTitle(_ titles: [String], font: UIFont) {
        var titleArr: [UIButton] = []
        var viewArr: [UIView] = []
        for i in 0..<titles.count {
            // pageTitle
            let titleBtn = UIButton()
            titleBtn.setTitle(titles[i], for: .normal)
            titleBtn.setTitleColor(Color.selectedColor, for: .normal)
            titleBtn.titleLabel?.font = font
            titleBtn.tag = 100 + i
            titleBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
            totalWidth += titles[i].getWidth(font, 100) + minSpace
            titleArr.append(titleBtn)
            headView.addSubview(titleBtn)
            
            // pageView
            let pageView = UIView()
            pageView.backgroundColor = UIColor.randomColor
            pageView.frame = CGRect(x: CGFloat(i) * Constant.screenWidth, y: 0,
                                    width: Constant.screenWidth, height: bounds.height - headHeight)
            viewArr.append(pageView)
            contentScrollView.addSubview(pageView)
        }
        pageTitleArr = titleArr
        pageViewArr = viewArr
        pageTitleViewLayout()
    }
    
    /// title点击事件
    ///
    /// - Parameter btn: 某点击项
    @objc internal func click(btn: UIButton) {
        guard lastIndex != btn.tag - 100 else { return }
        lastIndex = btn.tag - 100
        delegate?.selectedItem(index: btn.tag - 100)
        let maxOffset = self.totalWidth + minSpace - Constant.screenWidth
        UIView.animate(withDuration: 0.2) {
            self.lineView.center.x = btn.center.x
            self.lineView.bounds = CGRect(x: 0, y: 0, width: btn.bounds.width, height: self.lineHeight)
            self.contentScrollView.contentOffset.x = Constant.screenWidth * CGFloat(btn.tag - 100)
            if self.isPaging && btn.center.x > Constant.screenWidth / 2 {
                self.headView.contentOffset.x = (btn.center.x - Constant.screenWidth / 2 > maxOffset) ? maxOffset : btn.center.x - Constant.screenWidth / 2
            } else {
                self.headView.contentOffset.x = 0
            }
        }
    }
    
    /// 布局
    internal func pageTitleViewLayout() {
        // 当总长度小于屏幕宽度时，空隙计算
        let space = (Constant.screenWidth - totalWidth - minSpace) / CGFloat(pageTitleArr.count + 1)
        let offset = isPaging ? minSpace : space + minSpace
        for i in 0..<pageTitleArr.count {
            pageTitleArr[i].snp.makeConstraints({ (m) in
                m.left.equalTo((i - 1 < 0) ? headView : pageTitleArr[i - 1].snp.right).offset(offset)
                m.centerY.equalTo(headView)
            })
        }
        setSelectedItem()
    }
    
    /// 系统布局
    public override func layoutSubviews() {
        headView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: headHeight)
        contentScrollView.frame = CGRect(x: 0, y: headHeight, width: Constant.screenWidth, height: bounds.height - headHeight)
    }
    
    /// title Lable集合
    private var pageTitleArr: [UIButton] = [] {
        didSet {
            isPaging = totalWidth + minSpace > Constant.screenWidth
            let pagingWidth = isPaging ? totalWidth + minSpace : Constant.screenWidth
            headView.contentSize = CGSize(width: pagingWidth, height: headHeight)
            contentScrollView.contentSize = CGSize(width: Constant.screenWidth * CGFloat(pageTitleArr.count), height: bounds.height - headHeight)
        }
    }
    
    /// 内容View集合
    private var pageViewArr: [UIView] = []
    
    /// 项之间的最小空隙
    private let minSpace: CGFloat = 30
    
    /// page头的默认高度
    private var headHeight: CGFloat = 48
    
    /// 线的高度
    private let lineHeight: CGFloat = 3
    
    /// 计算title的总长度
    private var totalWidth: CGFloat = 0
    
    /// 是否分页
    private var isPaging: Bool = false
    
    /// 上一次按钮点击的下标
    private var lastIndex: Int = 0

    // page头
    private let headView = UIScrollView().then {
        $0.bounces = false
        $0.isPagingEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    /// 内容
    private let contentScrollView = UIScrollView().then {
        $0.bounces = false
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    /// line线
    private let lineView = UIView().then {
        $0.backgroundColor = Color.selectedColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate代理
extension JCPageView: UIScrollViewDelegate {
    
    /// scrollView正在滑动
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 当前滑动在哪个下标
        var index = (scrollView.contentOffset.x.remainder(dividingBy: Constant.screenWidth) != 0) ?  Int(scrollView.contentOffset.x / Constant.screenWidth) : Int(scrollView.contentOffset.x / Constant.screenWidth) - 1
        index = index < 0 ? 0 : index
        // 当屏幕宽度大于title的总长度时，计算空隙
        let space = (Constant.screenWidth - totalWidth - minSpace) / CGFloat(pageTitleArr.count + 1)
        // lineView偏移距离
        let centerDistance = (isPaging ? minSpace : space + minSpace) + pageTitleArr[index].bounds.width / 2 + pageTitleArr[index + 1].bounds.width / 2
        // contentView偏移比例
        let scale = (scrollView.contentOffset.x - CGFloat(index) * Constant.screenWidth) / Constant.screenWidth
        let lineOffset = centerDistance * scale
        let lineViewWidth = (pageTitleArr[index + 1].bounds.width - pageTitleArr[index].bounds.width) * scale
        lineView.center.x = lineOffset + pageTitleArr[index].center.x
        lineView.bounds = CGRect(x: 0, y: 0, width: pageTitleArr[index].bounds.width + lineViewWidth, height: lineHeight)
        // 超过屏幕中心
        let outScreenCenterX = lineView.center.x > Constant.screenWidth / 2
        let lineViewMaxOffset = totalWidth + minSpace - Constant.screenWidth
        if outScreenCenterX && isPaging && (lineViewMaxOffset >= lineOffset + pageTitleArr[index].center.x - Constant.screenWidth / 2) {
            headView.contentOffset.x = lineOffset + pageTitleArr[index].center.x - Constant.screenWidth / 2
        }
    }
    
    /// 停止滑动
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / Constant.screenWidth)
        guard lastIndex != index else { return }
        lastIndex = index
        delegate?.selectedItem(index: index)
    }
}

extension UIColor {
    //返回随机颜色
    open class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

