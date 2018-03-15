//
//  GuideViewController.swift
//  playWithMe
//
//  Created by Murray on 2018/2/21.
//  Copyright © 2018年 Murray. All rights reserved.
//

import UIKit

class GuideViewController:UIViewController,UIScrollViewDelegate
{
    //页面数量
    var numOfPages = 3
    let page = UIPageControl()
    
    override func viewDidLoad()
    {
        let frame = self.view.bounds
        //scrollView的初始化
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),height:frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        //改变小点点的颜色
        page.currentPageIndicatorTintColor = UIColor.black
        page.pageIndicatorTintColor = UIColor.gray

        for i in 0..<numOfPages{
            let imgfile = "GuideImage\(Int(i+1)).png"
            let image = UIImage(named:"\(imgfile)")
            let imgView = UIImageView(image: image)
            imgView.frame = CGRect(x:frame.size.width*CGFloat(i), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
        }
        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
        
        //设置小白点
        page.frame = CGRect(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 6 * 5 , width: 20, height: 20)
        page.numberOfPages = 3
        view.insertSubview(page, aboveSubview: scrollView)
    }
    
    //scrollview滚动的时候就会调用
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
        page.currentPage = Int(scrollView.contentOffset.x / view.bounds.width + 0.5)
        
        //如果在最后一个页面继续滑动的话就会跳转到主页面
        if(scrollView.contentOffset.x > twidth)
        {
            let mainStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let viewController = mainStoryboard.instantiateInitialViewController()
            self.present(viewController!, animated: true, completion:nil)
        }
    }
}
