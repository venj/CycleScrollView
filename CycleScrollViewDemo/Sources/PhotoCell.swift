//
//  PhotoCell.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/24.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

public class PhotoCell: UICollectionViewCell {
    public var imageView : UIImageView? {
        didSet {
            if let imageView = imageView {
                if !contentView.subviews.contains(imageView) {
                    contentView.addSubview(imageView)
                }
            }
        }
    }
    public var title : String? {
        didSet {
            guard let title = title else { return }
            titleLabel?.text = "   \(title)"
        }
    }
    
    public var titleLabelTextColor : UIColor? {
        didSet {
            titleLabel?.textColor = titleLabelTextColor
        }
    }

    public var titleLabelTextFont : UIFont? {
        didSet {
            titleLabel?.font = titleLabelTextFont
        }
    }

    public var titleLabelBackgroundColor : UIColor? {
        didSet {
            titleLabel?.backgroundColor = titleLabelBackgroundColor
        }
    }

    public var titleLabelHeight : CGFloat = 0.0
    public var hasConfigured : Bool = false

    private var titleLabel : UILabel?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        imageView = UIImageView()
        titleLabel = UILabel()
        contentView.addSubview(titleLabel!)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds // imageView should not be nil
        titleLabel?.frame = CGRect(x: 0.0, y: sd_height - titleLabelHeight, width: sd_width, height: titleLabelHeight)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        title = nil
    }
}
