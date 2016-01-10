//
//  YNRefreshFooterView.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/10.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

protocol YNRefreshFooterViewDelegate {

    func resetScrollViewBottomContentInset()
}

let kRefreshFooterHeight: CGFloat = 44

class YNRefreshFooterView: UIView, UIScrollViewDelegate {

    
    var delegate: YNRefreshFooterViewDelegate?
    var refreshActionHandler: (()->Void)?
    
    let activityView: UIActivityIndicatorView = {
        
        let tempView = UIActivityIndicatorView()
        tempView.color = UIColor.blackColor()
        tempView.hidesWhenStopped = true
        tempView.hidden = true
        return tempView
        
    }()
    
    var state: YNPullRefreshState? {
        
        didSet {
            
            if let _ = state {
                
                switch state! {
                    
                case YNPullRefreshState.Pulling:
                    
                    self.activityView.hidden = true
                    break
                case .Loading:
                    
//                    self.activityView.hidden = false
                    self.activityView.startAnimating()
                    
                    self.refreshActionHandler!()
                
                    break
                case .Normal:
                    
//                    self.activityView.hidden = true
                    
                    self.activityView.stopAnimating()
                    
                    self.delegate?.resetScrollViewBottomContentInset()
                    
                    break
                    
                }
                
            }
            
        }
    }
    
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(activityView)
        activityView.startAnimating()
        
        self.state = .Normal
        
//        self.backgroundColor = UIColor.redColor()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 刷新成功
    func successStopRefresh() {
        
        self.state = YNPullRefreshState.Normal
        self.activityView.stopAnimating()
        self.removeFromSuperview()
    }
    
    //MARK: 刷新失败
    func failureStopRefresh() {
        
        self.state = YNPullRefreshState.Normal
        self.activityView.stopAnimating()
        self.removeFromSuperview()
    }
    
    
    //MARK: uiscrollview delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.state == .Loading {
            
            //正在加载，什么都不做
        } else if self.state == .Normal {
            
            /**
            *  关键-->
            *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
            *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
            *  个滚动视图的contentSize.height
            */
            
            
            if scrollView.contentOffset.y + scrollView.frame.size.height + 8 > scrollView.contentSize.height {
                
                scrollView.addSubview(self)
                
                self.frame = CGRectMake(0, scrollView.contentSize.height, kScreenWidth, kRefreshFooterHeight)

                
                let y = kRefreshFooterHeight/2
                
                self.activityView.center = CGPointMake(kCycleCenterX, y)
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, kRefreshFooterHeight, 0)
                    
                    }, completion: { (isfinish) -> Void in
                        
                        
                        //开始加载
                        self.state = .Loading
                        
                })
                
            }
            
            
        }
        
    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        if self.state == .Loading {
//        
//            //正在加载，什么都不做
//        } else if self.state == .Normal {
//        
//            /**
//            *  关键-->
//            *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
//            *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
//            *  个滚动视图的contentSize.height
//            */
//            
//            
//            if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height {
//                
//                self.frame = CGRectMake(0, scrollView.contentSize.height, kScreenWidth, kRefreshFooterHeight)
//                
//                let y = kRefreshFooterHeight/2
//                
//                self.activityView.center = CGPointMake(kCycleCenterX, y)
//                
//                UIView.animateWithDuration(0.3, animations: { () -> Void in
//                    
//                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, kRefreshFooterHeight, 0)
//                    
//                    }, completion: { (isfinish) -> Void in
//                        
//                    
//                        //开始加载
//                        self.state = .Loading
//
//                })
//                
//            }
//            
//            
//        }
//        
//        
//    }
    
    
    
}
