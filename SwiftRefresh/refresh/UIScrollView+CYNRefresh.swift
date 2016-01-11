//
//  UIScrollView+CYNRefresh.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import Foundation
import UIKit

let kRefreshViewHeight = kSelfHeight

extension UIScrollView: YNRefreshHeaderViewDelegate, YNRefreshFooterViewDelegate {

    private struct associatedKeys {
    
        static var headerRefreshView = "headerRefreshView"
        static var footerrefreshView = "footerrefreshView"
        static var showRefresh = "showRefresh"
    }
    
   weak var headerRefreshView: YNRefreshHeaderView? {
    
        get {
        
            return objc_getAssociatedObject(self, &associatedKeys.headerRefreshView) as? YNRefreshHeaderView
        }
        
        set {
        
//            self.willChangeValueForKey("YNRefreshHeaderView")
            objc_setAssociatedObject(self, &associatedKeys.headerRefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            self.didChangeValueForKey("YNRefreshHeaderView")
        }
        

    }
    
    weak var footerrefreshView: YNRefreshFooterView? {
    
        get {
            
            return objc_getAssociatedObject(self, &associatedKeys.footerrefreshView) as? YNRefreshFooterView
        }
        
        set {
            
            objc_setAssociatedObject(self, &associatedKeys.footerrefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
    }
    
    var showRefresh: Bool? {
    
        get {
        
            return objc_getAssociatedObject(self, &associatedKeys.showRefresh) as? Bool
        }
        
        set {
        
            objc_setAssociatedObject(self, &associatedKeys.showRefresh, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if !showRefresh! {
            //不显示
                
                self.removeObserver(self.headerRefreshView!, forKeyPath: self.headerRefreshView!.observerKeyPath)
                
            } else {
            
                //显示
                
                self.addObserver(self.headerRefreshView!, forKeyPath: self.headerRefreshView!.observerKeyPath, options: NSKeyValueObservingOptions.New, context: nil)
                
                
            }
            
            
            
        }
        
        
    }
    
    
    func addHeaderRefreshWithActionHandler(actionHandler: ()->Void) {
    
        let yOrigin = -kRefreshViewHeight
        
        let headerRefreshView = YNRefreshHeaderView(frame: CGRectMake(0, yOrigin, self.bounds.size.width, kRefreshViewHeight))
        headerRefreshView.delegate = self
//        self.addSubview(headerRefreshView)
        
        headerRefreshView.refreshActionHandler = actionHandler
        
        self.headerRefreshView = headerRefreshView
        
        
//        self.delegate = self.headerRefreshView
        
        self.showRefresh = true
        
    }
    
    func addFooterRefreshWithActionHandler(actionHandler: ()->Void) {
        
        let footerRefreshView = YNRefreshFooterView(frame: CGRectZero)
        
        footerRefreshView.delegate = self
        footerRefreshView.refreshActionHandler = actionHandler
        
        self.footerrefreshView = footerRefreshView
        
        self.delegate = self.footerrefreshView
        
    }
    
    //MARK:YNRefreshHeaderViewDelegate 
    func refreshHeaderView(headerView: YNRefreshHeaderView, removerMyObserve: Bool) {
        
//        self.showRefresh = !removerMyObserve
    }
    
    func resetScrollViewContentInset() {
        
        var currentInsets = self.contentInset
        currentInsets.top = 0
        
        UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.AllowUserInteraction, .BeginFromCurrentState], animations: { () -> Void in
            
                self.contentInset = currentInsets
            
            }) { (isfinish) -> Void in
                
                
        }
        
    }
    
    //MARK: YNRefreshFooterViewDelegate
    func resetScrollViewBottomContentInset() {
        
        var currentInsets = self.contentInset
        currentInsets.bottom = 0
        
        UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.AllowUserInteraction, .BeginFromCurrentState], animations: { () -> Void in
            
            self.contentInset = currentInsets
            
            }) { (isfinish) -> Void in
                
                
        }
    }
    
}