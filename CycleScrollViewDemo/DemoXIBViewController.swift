//
//  DemoXIBViewController.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/26.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

class DemoXIBViewController: UIViewController, CycleScrollViewDelegate {

    @IBOutlet weak var bannerView: CycleScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None

        let imageURLStrings = ["https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]

        let titles = ["First title", "Second title",  "Fourth title"]

        bannerView.imagePaths = imageURLStrings
        bannerView.pageControlAliment = .Right
        bannerView.titles = titles
        bannerView.currentPageDotColor = UIColor.yellowColor()
        bannerView.placeholderImage = UIImage(named: "placeholder")
        bannerView.delegate = self

        let banner2 = CycleScrollView(frame: CGRect(x: 0.0, y: 200.0, width: view.frame.width, height: 140))
        banner2.pageControlAliment = .Center
        banner2.imagePaths = imageURLStrings
        banner2.titles = titles
        view.addSubview(banner2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
