//
//  DotView.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

public class DotView : UIView {
    public init() {
        super.init(frame: CGRectZero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    required public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = frame.width / 2.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 2.0
    }

    public func changeActivityState(active: Bool) {
        backgroundColor = active ? UIColor.whiteColor() : UIColor.clearColor()
    }
}
