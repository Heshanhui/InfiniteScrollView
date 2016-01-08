//
//  ViewController.swift
//  HSHInfiniteScrollView
//
//  Created by HUI on 16/1/7.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - 懒加载图片展示的view
    lazy var infiniteScrollView : HSHInfiniteScrollView = {

        let infiniteScrollView = HSHInfiniteScrollView(images: ["img_00", "img_01", "img_02", "img_03", "img_04"], imageSelectCallBack: { (index) -> () in
            // 在此执行点击图片的动作 index为图片数组下标
            print(index)
        })
        
        infiniteScrollView.scrollDirectionLandscape = false
        return infiniteScrollView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置图片滚动器的frame即可
        infiniteScrollView.frame = CGRect(x: 50, y: 100, width: 300, height: 180)
        view.addSubview(infiniteScrollView)
        
    }

}

