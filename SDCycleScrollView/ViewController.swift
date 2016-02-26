//
//  ViewController.swift
//  SDCycleScrollView
//
//  Created by 朱文杰 on 16/2/26.
//  Copyright © 2016年 GSD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CycleScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.99)
        let backgroundView = UIImageView(image: UIImage(named: "005.jpg"))
        backgroundView.frame = view.bounds
        let containerView = UIScrollView(frame: view.frame)
        containerView.contentSize = CGSize(width: view.frame.width, height: 700)
        view.addSubview(containerView)

        title = "Demo"

        let imageNames = ["h1.jpg", "h2.jpg", "h3.jpg", "h4.jpg"]

        let imageURLStrings = ["https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]

        let titles = ["First title", "Second title",  "Fourth title"]

        let w = view.frame.width

        let cycleScrollView = CycleScrollView(frame: CGRect(x: 0.0, y: 0.0, width: w, height: 180.0), shouldInfiniteLoop: true, imagesPaths: imageNames)
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = .Animated
        containerView.addSubview(cycleScrollView)
        cycleScrollView.autoScrollTimeInterval = 4.0
        
        let cycleScrollView2 = CycleScrollView(frame: CGRect(x: 0.0, y: 220.0, width: w, height: 180.0), delegate: self, placeholderImage: UIImage(named: "placeholder"))
        cycleScrollView2.pageControlAliment = .Right
        cycleScrollView2.titles = titles
        cycleScrollView2.currentPageDotColor = UIColor.whiteColor()
        containerView.addSubview(cycleScrollView2)

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            cycleScrollView2.imagePaths = imageURLStrings
        }

        cycleScrollView2.clickItemOperation = {
            print("------  callback at \($0)")
        }

        let cycleScrollView3 = CycleScrollView(frame: CGRect(x: 0.0, y: 420.0, width: w, height: 180.0), delegate: self, placeholderImage: UIImage(named: "placeholder"))
        cycleScrollView3.currentPageDotImage = UIImage(named: "pageControlCurrentDot")
        cycleScrollView3.pageDotImage = UIImage(named: "pageControlDot")
        cycleScrollView3.imagePaths = imageURLStrings
        containerView.addSubview(cycleScrollView3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cycleScrollView(cycleScrollView: CycleScrollView, didSelectItemAtIndex index: Int) {
        print("------  You selected picture \(index)")
        navigationController?.pushViewController(DemoVCWithXib(), animated: true)
    }

}
