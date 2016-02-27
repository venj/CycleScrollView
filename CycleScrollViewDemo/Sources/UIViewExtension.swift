//
//  UIViewExtension.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/24.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

public extension UIView {
    public var sd_width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    public var sd_height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    public var sd_x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    public var sd_y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}
