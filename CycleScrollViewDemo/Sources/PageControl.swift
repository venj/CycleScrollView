//
//  PageControl.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

@objc
public protocol PageControlDelegate {
    optional func pageControl(pageControl: PageControl?, didSelectPageAtIndex index: Int)
}

public class PageControl : UIControl {
    public var dotViewClass : AnyClass?
    public var dotImage : UIImage? {
        didSet {
            resetDotViews()
            if dotImage != nil {
                dotSize = dotImage!.size
            }
            dotViewClass = nil
        }
    }
    public var currentDotImage : UIImage? {
        didSet {
            resetDotViews()
            dotViewClass = nil
        }
    }

    public var dotSize : CGSize = CGSize(width: 8, height: 8)
    public var dotColor : UIColor?
    public var spacingBetweenDots : CGFloat = 8.0 {
        didSet {
            resetDotViews()
        }
    }
    public weak var delegate : PageControlDelegate?
    public var numberOfPages : Int = 0 {
        didSet {
            resetDotViews()
        }
    }
    public var currentPage : Int = 0 {
        willSet {
            changeActivity(false, atIndex: currentPage)
        }
        didSet {
            changeActivity(true, atIndex: currentPage)
        }
    }
    public var hidesForSinglePage : Bool = false
    public var shouldResizeFromCenter : Bool = true

    public var dots : [UIView] = []

    public init() {
        super.init(frame: CGRectZero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.dotViewClass = AnimatedDotView.self;
    }

    //Mark: - Touch event

    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let view = touches.first?.view else { return }
        if view != self {
            let index = dots.indexOf(view)?.distanceTo(dots.startIndex)
            delegate?.pageControl?(self, didSelectPageAtIndex: index!)
        }
    }

    //Mark: - Layout

    override public func sizeToFit() {
        updateFrame(true)
    }

    private func updateFrame(overrideExistingFrame: Bool) {
        let c = center
        let requiredSize = sizeForNumberOfPages(numberOfPages)
        if overrideExistingFrame || ((frame.width < requiredSize.width) || frame.height < requiredSize.height && !overrideExistingFrame) {
            frame = CGRect(x: CGRectGetMinX(frame), y: CGRectGetMinY(frame), width: requiredSize.width, height: requiredSize.height)

            if shouldResizeFromCenter { center = c }
        }

        resetDotViews()
    }

    public func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        return CGSize(width: (dotSize.width + spacingBetweenDots) * CGFloat(pageCount) - spacingBetweenDots, height: dotSize.height)
    }

    private func updateDots() {
        if numberOfPages == 0 { return }
        var dot : UIView?
        for i in 0..<numberOfPages {
            if i < dots.count {
                dot = dots[i]
            }
            else {
                dot = generateDotView()
            }
            updateDotFrame(dot!, atIndex: i)
        }

        changeActivity(true, atIndex: currentPage)
        hideForSinglePage()
    }


    private func updateDotFrame(dot: UIView, atIndex index: Int) {
        let x = (dotSize.width + spacingBetweenDots) * CGFloat(index) + ((frame.width - sizeForNumberOfPages(numberOfPages).width) / 2.0)
        let y = (frame.height - dotSize.height) / 2.0
        dot.frame = CGRect(x: x, y: y, width: dotSize.width, height: dotSize.height)
    }


    //Mark: - Utils

    private func generateDotView() -> UIView {
        var dotView: UIView

        let dotViewFrame = CGRect(x: 0.0, y: 0.0, width: dotSize.width, height: dotSize.height)
        if dotViewClass != nil {
            guard let dotViewClass = dotViewClass.self as? DotView.Type else {
                fatalError("Not a valid DotView class")
            }
            dotView = (self.dotViewClass as! DotView.Type).init(frame: dotViewFrame)
            //dotView = viewClass.init(frame: dotViewFrame)
            //dotView.frame = dotViewFrame

            if let _ = dotViewClass as? AnimatedDotView.Type {
                (dotView as! AnimatedDotView).dotColor = dotColor
            }
        }
        else {
            dotView = UIImageView(image: dotImage)
            dotView.frame = dotViewFrame
        }

        addSubview(dotView)
        dots.append(dotView)

        dotView.userInteractionEnabled = true
        return dotView
    }

    private func changeActivity(active: Bool, atIndex index: Int) {
        if dotViewClass != nil {
            guard let dotView = dots[index] as? DotView else {
                fatalError("Not a valid DotView subclass.")
            }
            dotView.changeActivityState(active)
        }
        else if dotImage != nil && currentDotImage != nil {
            let dotView = dots[index] as! UIImageView
            dotView.image = active ? currentDotImage : dotImage
        }
    }

    private func hideForSinglePage() {
        if numberOfPages == 1 && hidesForSinglePage {
            hidden = true
        }
        else {
            hidden = false
        }
    }

    private func resetDotViews() {
        dots.forEach { $0.removeFromSuperview() }
        dots = []
        updateDots()
    }

}
