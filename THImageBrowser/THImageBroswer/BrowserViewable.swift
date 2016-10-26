//
//  BrowserViewable.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit

// 显示数据的模型
class BrowserViewable: NSObject {
    // 小图地址
    var thumbnailUrl: String?
    // 大图地址
    var imageUrl: String?
    // 图文信息
    var attributedTitle: NSAttributedString?
    // 当前索引
    var index: Int = 0
}
