//
//  PhotoCell.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/24.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    var imageView : UIImageView? {
        didSet {
            if let imageView = imageView {
                if !contentView.subviews.contains(imageView) {
                    contentView.addSubview(imageView)
                }
            }
        }
    }
    var title : String? {
        didSet {
            guard title != nil else { return }
            titleLabel = UILabel()
            titleLabel?.text = "   \(title!)"
        }
    }
    
    var titleLabelTextColor : UIColor? {
        didSet {
            titleLabel?.textColor = titleLabelTextColor
        }
    }

    var titleLabelTextFont : UIFont? {
        didSet {
            titleLabel?.font = titleLabelTextFont
        }
    }

    var titleLabelBackgroundColor : UIColor? {
        didSet {
            titleLabel?.backgroundColor = titleLabelBackgroundColor
        }
    }

    var titleLabelHeight : CGFloat = 0.0
    var hasConfigured : Bool = false

    private var titleLabel : UILabel? {
        didSet {
            guard let titleLabel = titleLabel else { return }
            if !contentView.subviews.contains(titleLabel) {
                contentView.addSubview(titleLabel)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        imageView = UIImageView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds // imageView should not be nil
        titleLabel?.frame = CGRect(x: 0.0, y: sd_height - titleLabelHeight, width: sd_width, height: titleLabelHeight)
    }
}
