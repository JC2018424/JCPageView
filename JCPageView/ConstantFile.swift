//
//  ConstantFile.swift
//  QRProject
//
//  Created by 严伟 on 2018/2/23.
//  Copyright © 2018年 yW. All rights reserved.
//

import UIKit

public struct Constant {
    /// 屏幕大小
    static let screenSize = UIScreen.main.bounds.size
    
    /// 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.width
    
    /// 屏幕高度
    static let screenHeight = UIScreen.main.bounds.height
}

extension String {
    
    /// 获取text的宽度
    ///
    /// - parameter text:   text内容
    /// - parameter font:   text字体的大小
    /// - parameter height: text固定宽度
    ///
    /// - returns: 动态的宽度
    public func getWidth(_ font: UIFont, _ height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context:nil).size
        return strSize.width
    }
}
