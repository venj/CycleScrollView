//
//  DotView.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

class DotView : UIView {
    init() {
        super.init(frame: CGRectZero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = frame.width / 2.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 2.0
    }

    func changeActivityState(active: Bool) {
        backgroundColor = active ? UIColor.whiteColor() : UIColor.clearColor()
    }
}
