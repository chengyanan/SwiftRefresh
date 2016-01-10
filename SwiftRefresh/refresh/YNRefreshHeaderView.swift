//
//  YNRefreshHeaderView.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

enum YNPullRefreshState {

    case Pulling, Normal, Loading
}

protocol YNRefreshHeaderViewDelegate {

    func refreshHeaderView(headerView: YNRefreshHeaderView, removerMyObserve: Bool)
    func resetScrollViewContentInset()
}

class YNRefreshHeaderView: UIView, UIScrollViewDelegate {

    //MARK: property public
    var scrollViewOriginalDelegate:YNRefreshFooterView?
    
    let observerKeyPath = "contentOffset"
    var refreshActionHandler: (()->Void)?
    var delegate: YNRefreshHeaderViewDelegate?
    var state: YNPullRefreshState? {
    
        didSet {
        
            if let _ = state{
            
                switch state! {
                    
                case YNPullRefreshState.Pulling:
                    self.cycleLayer.hidden = false
                    self.activityView.hidden = true
                    break
                case .Loading:
                    self.cycleLayer.hidden = true
                    self.activityView.hidden = false
                    self.activityView.startAnimating()
                    
                    self.refreshActionHandler!()
//
                    self.delegate?.refreshHeaderView(self, removerMyObserve: true)
                    break
                case .Normal:
                    
                    self.cycleLayer.hidden = true
                    self.delegate?.resetScrollViewContentInset()
                    
                    break
                    
                }
            
            }
            
        }
    }
    
    //MARK: property private
    var currentY: CGFloat?
    var newAngle: CGFloat? {
    
        didSet {
        
            self.cycleLayer.newAngle = newAngle!
        }
    }
    var startAngle: CGFloat?
    
    //MARK: property UI component
    let cycleLayer = YNCycleLayer()
    let activityView: UIActivityIndicatorView = {
    
        let tempView = UIActivityIndicatorView()
        tempView.center = CGPointMake(kCycleCenterX, kCycleCenterY)
        tempView.color = UIColor.blackColor()
        tempView.hidesWhenStopped = true
        tempView.hidden = true
        return tempView
        
    }()
    
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(activityView)
        activityView.startAnimating()
    
        cycleLayer.frame = self.bounds
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.addSublayer(self.cycleLayer)
        
        self.state = YNPullRefreshState.Normal
        
        
//        self.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 刷新成功
    func successStopRefresh() {
    
        self.state = YNPullRefreshState.Normal
        self.activityView.stopAnimating()
    }
    
    //MARK: 刷新失败
    func failureStopRefresh() {
    
        self.state = YNPullRefreshState.Normal
        self.activityView.stopAnimating()
    }
    
    //MARK: UIScrollViewDelegate
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        
//        self.delegate?.refreshHeaderView(self, removerMyObserve: false)
//        
//    }
//    
//    
//    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if self.state == YNPullRefreshState.Loading {
        
            let offset = max(scrollView.contentOffset.y * -1, 0)
            
            var currentInsets = scrollView.contentInset
            currentInsets.top = min(offset, kSelfHeight)
            
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                
                scrollView.contentInset = currentInsets
                
                }, completion: { (isfinish) -> Void in
                   
                    
                    scrollView.delegate = self.scrollViewOriginalDelegate
            })
            
        }
        
    }
    
    //MARK: observing
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        print(change)
        
        // change = Optional(["new": NSPoint: {0, -1}, "kind": 1])
        
//        print(object)
        
        if keyPath == self.observerKeyPath {
            
            let changeValue = change!["new"] as? NSValue
            let newPoint = changeValue?.CGPointValue()
            
            if let scrollView = object as? UIScrollView {
            
                self.scrollViewDidScrolla(newPoint!, scrollView: scrollView)
                
            }
            
            
        }
    }
    
    //MARK: custom motheds
    func scrollViewDidScrolla(contentOffset: CGPoint, scrollView: UIScrollView) {
        
        if self.state != YNPullRefreshState.Loading {
        
            
            let top = kSelfHeight - kOffsetHeight
            
            //当向下拉的距离小于（kSelfHeight + 4）
            if contentOffset.y > -(kSelfHeight + 4) {
                
                if contentOffset.y >= -top {
                    
                    self.cycleLayer.hidden = true
                    self.activityView.hidden = true
                    
                } else if contentOffset.y >= -kSelfHeight {
                    
                    //开始画圆
                    self.state = YNPullRefreshState.Pulling
                    
                    self.currentY = -contentOffset.y
                    
                    let x = (-contentOffset.y - top) * 2 * CGFloat(M_PI)
                    let y = kRadiusOfCycle * 2
                    
                    let angle: CGFloat = x / y - CGFloat(M_PI_2)
                    
                    self.newAngle = angle
                    
                }
                
                
            } else {
                
                
                //contentInset的设置放在scrollViewWillEndDragging方法中 才能平缓过渡 不会有跳跃
                
                self.scrollViewOriginalDelegate = scrollView.delegate as? YNRefreshFooterView
                scrollView.delegate = self
                self.state = YNPullRefreshState.Loading
                
                
//                let offset = max(contentOffset.y * -1, 0)
//                
//                var currentInsets = scrollView.contentInset
//                currentInsets.top = min(offset, kSelfHeight)
//                
//                UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
//                    
//                    scrollView.contentInset = currentInsets
//                    
//                    }, completion: { (isfinish) -> Void in
//                        
//                        
//                })
                
                
            }
            
        }

        
    }
    
    
    
    
}
