//
//  ConstantFont.swift
//  QRProject
//
//  Created by 严伟 on 2018/3/15.
//  Copyright © 2018年 KM. All rights reserved.
//

import UIKit

public struct Font {
    
    /// 设置字体大小
    ///
    /// - Parameter size: 大小
    /// - Returns: 字体
    static public func dp(_ size: Int) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size))
    }
}
