//
//  CycleScrollView.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/26.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit
import Kingfisher

@objc
public enum CycleScrollViewPageContolAliment : Int {
    case Right
    case Center
}

@objc
public enum CycleScrollViewPageContolStyle : Int {
    case Classic
    case Animated
    case None
}

@objc
public protocol CycleScrollViewDelegate {
    optional func cycleScrollView(cycleScrollView: CycleScrollView, didSelectItemAtIndex index: Int)
    optional func cycleScrollView(cycleScrollView: CycleScrollView, didScrollToIndex index: Int)
}

private let ID = "cycleCell"

public class CycleScrollView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    public var titles : [String]?
    public var autoScrollTimeInterval : NSTimeInterval? {
        didSet {
            doneSettingAutoScroll()
        }
    }
    public var infiniteLoop : Bool = true
    public var autoScroll : Bool = true
    public weak var delegate : CycleScrollViewDelegate?
    public var clickItemOperation : ((Int) -> Void)?
    public var imageViewContentMode : UIViewContentMode = .ScaleToFill
    public var placeholderImage : UIImage? {
        didSet {
            backgroundImageView.image = placeholderImage
        }
    }
    public var showPageControl : Bool = true {
        didSet {
            pageControl?.hidden = !showPageControl
        }
    }
    public var hidesForSinglePage : Bool = true
    public var pageControlStyle : CycleScrollViewPageContolStyle = .Classic {
        didSet {
            setupPageControl()
        }
    }
    public var pageControlAliment : CycleScrollViewPageContolAliment = .Center
    public var pageControlDotSize : CGSize = CGSize(width: 10, height: 10) {
        didSet {
            setupPageControl()
            if let p = pageControl as? PageControl {
                p.dotSize = pageControlDotSize
            }
        }
    }
    public var currentPageDotColor : UIColor = UIColor.whiteColor() {
        didSet {
            if let p = pageControl as? PageControl {
                p.dotColor = currentPageDotColor
            }
            if let p = pageControl as? UIPageControl {
                p.currentPageIndicatorTintColor = currentPageDotColor
            }
        }
    }
    public var pageDotColor : UIColor = UIColor.lightGrayColor() {
        didSet {
            if let p = pageControl as? UIPageControl {
                p.pageIndicatorTintColor = currentPageDotColor
            }
        }
    }
    public var currentPageDotImage : UIImage? {
        didSet {
            doneSettingCurrentPageDotImage()
        }
    }
    public var pageDotImage : UIImage? {
        didSet {
            doneSettingPageDotImage()
        }
    }
    public var titleLabelTextColor : UIColor = UIColor.whiteColor()
    public var titleLabelTextFont : UIFont = UIFont.systemFontOfSize(14.0)
    public var titleLabelBackgroundColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    public var titleLabelHeight : CGFloat = 30.0
    public var trustedHosts : Set<String>? {
        didSet {
            ImageDownloader.defaultDownloader.trustedHosts = trustedHosts
        }
    }
    public var showDownloadIndicator : Bool = true

    private var mainView: UICollectionView?
    private var flowLayout: UICollectionViewFlowLayout?
    public var imagePaths : [String] = [] {
        didSet {
            doneSettingImagePaths()
        }
    }

    private var timer : NSTimer?
    private var totalItemsCount : Int = 0
    private var pageControl : UIControl?
    private var backgroundImageView : UIImageView = UIImageView() {
        didSet {
            backgroundImageView.contentMode = .ScaleAspectFit
            insertSubview(backgroundImageView, belowSubview: mainView!)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public init(frame:CGRect, delegate: CycleScrollViewDelegate? = nil, placeholderImage: UIImage? = nil, shouldInfiniteLoop infiniteLoop: Bool = true, imagesPaths: [String] = []) {
        super.init(frame: frame)
        self.infiniteLoop = infiniteLoop
        self.imagePaths = imagesPaths
        self.placeholderImage = placeholderImage
        self.delegate = delegate
        setup()
        doneSettingImagePaths()
        doneSettingAutoScroll()
        clearCache()
    }

    override public func awakeFromNib() {
        setup()
    }

    private func setup() {
        // Basic setup
        pageControlAliment = .Center
        autoScrollTimeInterval = 2.0
        titleLabelTextColor = UIColor.whiteColor()
        titleLabelTextFont = UIFont.systemFontOfSize(14.0)
        titleLabelBackgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        titleLabelHeight = 30.0
        autoScroll = true
        showPageControl = true
        pageControlDotSize = CGSize(width: 10, height: 10)
        pageControlStyle = .Classic
        hidesForSinglePage = true
        currentPageDotColor = UIColor.whiteColor()
        pageDotColor = UIColor.lightGrayColor()
        imageViewContentMode = .ScaleToFill
        backgroundColor = UIColor.lightGrayColor()

        // CollectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .Horizontal
        self.flowLayout = flowLayout

        let mainView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clearColor()
        mainView.pagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: ID)
        mainView.dataSource = self
        mainView.delegate = self
        addSubview(mainView)
        self.mainView = mainView
    }

    private func setupPageControl() {
        if pageControl != nil { pageControl?.removeFromSuperview() }
        if imagePaths.count <= 1 && hidesForSinglePage { return }

        switch pageControlStyle {
        case .Animated:
            let p = PageControl()
            p.numberOfPages = imagePaths.count
            p.dotColor = currentPageDotColor
            p.userInteractionEnabled = false
            addSubview(p)
            pageControl = p
        case .Classic:
            let p = UIPageControl()
            p.numberOfPages = imagePaths.count
            p.currentPageIndicatorTintColor = currentPageDotColor
            p.pageIndicatorTintColor = pageDotColor
            p.userInteractionEnabled = false
            addSubview(p)
            pageControl = p
        default:
            break
        }

        reloadPageDotImages()
    }

    private func setCustomPageControlDotImage(image: UIImage?, isCurrentPageDot isCurrent: Bool) {
        if image == nil || pageControl == nil { return }

        if let p = pageControl as? PageControl {
            if isCurrent {
                p.currentDotImage = image
            }
            else {
                p.dotImage = image
            }
        }
        if let p = pageControl as? UIPageControl {
            if isCurrent {
                //FIXME: Private API?
                p.setValue(image, forKey: "_currentPageImage")
            }
            else {
                p.setValue(image, forKey: "_pageImage")
            }
        }
    }

    private func setupTimer() {
        if timer != nil {
            timer?.invalidate()
        }
        if autoScroll {
            timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval!, target: self, selector:"automaticScroll", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }

    func automaticScroll() {
        if totalItemsCount == 0 { return }
        let currentIndex = Int(mainView!.contentOffset.x / flowLayout!.itemSize.width)
        var targetIndex = currentIndex + 1
        if targetIndex == totalItemsCount {
            if infiniteLoop {
                targetIndex = totalItemsCount / 2
            }
            else {
                return
            }
            mainView?.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
        }
        else {
            mainView?.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: true)
        }
    }

    private func doneSettingImagePaths() {
        totalItemsCount = infiniteLoop ? imagePaths.count * 100 : imagePaths.count

        if imagePaths.count > 1 {
            mainView?.scrollEnabled = true
            doneSettingAutoScroll()
        }
        else {
            mainView?.scrollEnabled = false
        }

        setupPageControl()
        mainView?.reloadData()
    }

    private func doneSettingAutoScroll() {
        setupTimer()
    }

    private func doneSettingCurrentPageDotImage() {
        setCustomPageControlDotImage(currentPageDotImage, isCurrentPageDot: true)
    }
    private func doneSettingPageDotImage() {
        setCustomPageControlDotImage(pageDotImage, isCurrentPageDot: false)
    }

    private func reloadPageDotImages() {
        doneSettingCurrentPageDotImage()
        doneSettingPageDotImage()
    }

    class func clearImagesCache() {
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }

    func clearCache() {
        CycleScrollView.clearImagesCache()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        flowLayout?.itemSize = frame.size
        guard let mainView = mainView else {
            fatalError("mainView is not correctly initialized.")
        }
        mainView.frame = bounds
        if mainView.contentOffset.x == 0 && totalItemsCount != 0 {
            var targetIndex = 0
            if infiniteLoop {
                targetIndex = totalItemsCount / 2
            }
            mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
        }

        let size: CGSize
        if let p = pageControl as? PageControl {
            size = p.sizeForNumberOfPages(imagePaths.count)
        }
        else {
            size = CGSize(width: CGFloat(imagePaths.count) * pageControlDotSize.width * 1.2, height: pageControlDotSize.height)
        }
        var x = (sd_width - size.width) / 2.0
        if pageControlAliment == .Right {
            x = mainView.sd_width - size.width - 10.0
        }
        let y = mainView.sd_height - size.height - 10.0
        if let p = pageControl as? PageControl {
            p.sizeToFit()
        }
        pageControl?.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        pageControl?.highlighted = !showPageControl
        backgroundImageView.frame = bounds
    }

    //MARK: - UICollectionViewDataSource
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! PhotoCell
        let itemIndex = indexPath.item % imagePaths.count
        let imagePath = imagePaths[itemIndex]
        if imagePath.hasPrefix("http://") || imagePath.hasPrefix("https://") {
            cell.imageView?.kf_showIndicatorWhenLoading = showDownloadIndicator
            cell.imageView?.kf_setImageWithURL(NSURL(string: imagePath)!, placeholderImage: placeholderImage)
        }
        else {
            cell.imageView?.image = UIImage(named: imagePath)
        }

        if titles?.count > 0 && itemIndex < titles?.count {
            let title = titles![itemIndex]
            cell.title = title
        }

        if !cell.hasConfigured {
            cell.titleLabelBackgroundColor = titleLabelBackgroundColor
            cell.titleLabelHeight = titleLabelHeight
            cell.titleLabelTextColor = titleLabelTextColor
            cell.titleLabelTextFont = titleLabelTextFont
            cell.imageView?.contentMode = imageViewContentMode
            cell.clipsToBounds = false
            cell.hasConfigured = true
        }

        return cell
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let i = indexPath.item % imagePaths.count
        delegate?.cycleScrollView?(self, didSelectItemAtIndex: i)
        clickItemOperation?(i)
    }

    //MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if imagePaths.count == 0 { return }
        guard let mainView = mainView else { fatalError("mainView is not initialized correctly.") }
        let itemIndex = Int((scrollView.contentOffset.x + mainView.sd_width / 2.0) / mainView.sd_width)
        let indexOnPageControl = itemIndex % imagePaths.count

        if let p = pageControl as? PageControl {
            p.currentPage = indexOnPageControl
        }
        if let p = pageControl as? UIPageControl  {
            p.currentPage = indexOnPageControl
        }
    }

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll {
            timer?.invalidate()
            timer = nil
        }
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            setupTimer()
        }
    }

    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if imagePaths.count == 0 { return }
        guard let mainView = mainView else { fatalError("mainView is not initialized correctly.") }
        let itemIndex = Int((scrollView.contentOffset.x + mainView.sd_width / 2.0) / mainView.sd_width)
        let indexOnPageControl = itemIndex % imagePaths.count
        delegate?.cycleScrollView?(self, didScrollToIndex: indexOnPageControl)
    }
}
