//
//  AnimatedDotView.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

public class AnimatedDotView: DotView {
    public var dotColor : UIColor? = UIColor.whiteColor() {
        didSet {
            guard let dotColor = dotColor else { return }
            layer.borderColor  = dotColor.CGColor
        }
    }

    public var animateDuration : NSTimeInterval = 1.0
    
    override public init() {
        super.init(frame: CGRectZero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    required public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() { }

    override public func changeActivityState(active: Bool) {
        if active {
            animateToActiveState()
        }
        else {
            animateToInActiveState()
        }
    }

    private func animateToActiveState() {
        UIView.animateWithDuration(animateDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20.0, options: .CurveLinear, animations: { [weak self] in
                self?.backgroundColor = self?.dotColor
                self?.transform = CGAffineTransformMakeScale(1.4, 1.4)
            }, completion: nil)
    }

    private func animateToInActiveState() {
        UIView.animateWithDuration(animateDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: { [weak self] in
                self?.backgroundColor = UIColor.clearColor()
                self?.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}
