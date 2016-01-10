//
//  HSHInfiniteScrollView.swift
//  HSHInfiniteScrollView
//
//  Created by HUI on 16/1/7.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit


enum PageControlLocation{
    
    case left, right, center
}

class HSHInfiniteScrollView: UIView {
    
    var images : [String] = []
    var scrollDirectionLandscape : Bool = false
    var showPageControl : Bool = true // 显示pageControl
    var isAutoScroll : Bool = false // 开启自动滚动
    var pageControlLocation : PageControlLocation = .left // pageControl位置
    let imageViewCount : Int = 3
    var timer : NSTimer? = nil
    var imageSelectCallBack : ((index: Int) -> ())?
    
    
    // MARK: - lazy
    lazy var scrollView : UIScrollView? = {
        let scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for i in 0..<self.imageViewCount {
            let imageView = UIImageView()
            imageView.userInteractionEnabled = true
            scrollView.addSubview(imageView)
            
        }
        return scrollView
    }()
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.hidden = !self.showPageControl
        return pageControl
        
    }()
    
    // MARK: - 自定义构造方法
    convenience init(images: [String], imageSelectCallBack: (index: Int) -> ()){
        
        self.init()
        
        self.imageSelectCallBack = imageSelectCallBack
        
        for i in 0..<imageViewCount{
            let imageView = scrollView?.subviews[i] as? UIImageView
            imageView?.image = UIImage(named: images[i])
        }
        self.images = images
        pageControl.numberOfPages = images.count
        self.addSubview(scrollView!)
        self.addSubview(pageControl)
        addChildViewsConstraints()
        if isAutoScroll{
            startTimer()
        }
    }
    
    // MARK: - 系统回调
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView?.frame = self.bounds
        
        if scrollDirectionLandscape == true {
            scrollView?.contentSize = CGSize(width: self.bounds.size.width * CGFloat(imageViewCount), height: 0)
        }else{
             scrollView?.contentSize = CGSize(width: 0, height: self.bounds.size.height * CGFloat(imageViewCount))
        }
        
        for i in 0..<imageViewCount {
            let imageView = scrollView!.subviews[i];
            if scrollDirectionLandscape == true{
                imageView.frame = CGRect(x: CGFloat(i) * scrollView!.frame.size.width, y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
            }else{
                imageView.frame = CGRect(x: 0, y: CGFloat(i) * scrollView!.frame.size.height, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
            }
        }
        
        updateContent()
    }
    
    // MARK: - 私有方法

    class func infiniteScrollView(images: [String]) -> HSHInfiniteScrollView{
        
        let infiniteScroll = HSHInfiniteScrollView(images: images) { (index: Int) -> () in
            
        }
       
        return infiniteScroll
    }
    
    // 设置pageControl 位置
    private func addChildViewsConstraints(){
    
        let dict = ["self": self, "pageControl" : pageControl]
    
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        var str : String?
        switch pageControlLocation{
        
        case .left : 
            str = "H:|-[pageControl]"
        case .right:
            str = "H:[pageControl]-|"
        case .center:
            str = "H:|-[pageControl]-|"
            
        }
        
        let layoutH1 = NSLayoutConstraint.constraintsWithVisualFormat(str!, options: .DirectionLeadingToTrailing, metrics: nil, views: dict)
        self.addConstraints(layoutH1)
        
        let layoutV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl]-(-5)-|", options: .DirectionLeadingToTrailing, metrics: nil, views: dict)
        self.addConstraints(layoutV1)
    }
    
    /// 内容更新
    func updateContent(){
    
        for i in 0..<imageViewCount{
        
            let imageView = scrollView?.subviews[i] as? UIImageView
            var indexPage = pageControl.currentPage
            if i == 0 {
                indexPage--
            }else if i == 2 {
                indexPage++
            }
            if indexPage < 0 {
                indexPage = pageControl.numberOfPages - 1;
            
            }else if indexPage >= pageControl.numberOfPages {
            
                indexPage = 0
            }
            imageView?.image = UIImage(named: self.images[indexPage])
            imageView?.tag = indexPage
            imageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showImageInfo:"))
        }
        scrollView!.contentOffset = scrollDirectionLandscape ? CGPointMake(scrollView!.frame.size.width, 0) : CGPointMake(0, scrollView!.frame.size.height)
    }

    
    private func startTimer(){
    
        let timer = NSTimer(timeInterval: 2, target: self, selector: "nextPage", userInfo: nil, repeats: true)
        self.timer = timer
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func nextPage(){
    
        if scrollDirectionLandscape == false {
            scrollView?.setContentOffset(CGPoint(x: 0, y:  2 * scrollView!.frame.size.height), animated: true)
        } else {
            scrollView?.setContentOffset(CGPoint(x: 2 * scrollView!.frame.size.width, y:  0), animated: true)
        }
    }
    
    @objc private func showImageInfo(tap: UITapGestureRecognizer){
        
        imageSelectCallBack!(index: pageControl.currentPage)

    }
}


extension HSHInfiniteScrollView : UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateContent()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        updateContent()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page = 0
        var minDistance = CGFloat(MAXFLOAT)
        for i in 0..<3{
            let imageView = scrollView.subviews[i] as? UIImageView
            let distance = scrollDirectionLandscape ? abs(imageView!.frame.origin.x - scrollView.contentOffset.x) : abs(imageView!.frame.origin.y - scrollView.contentOffset.y)
            if distance < minDistance{
                minDistance = distance;
                page = imageView!.tag
            }
          
        }
        pageControl.currentPage = page
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll{
            startTimer()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if isAutoScroll{
        
            stopTimer()
        }
    }

}


