//
//  ViewController.swift
//  SwiftRefresh
//
//  Created by 农盟 on 16/1/8.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let tableView: UITableView = {
        
        return UITableView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
//        
        self.tableView.addHeaderRefreshWithActionHandler { () -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                
                self.tableView.stopHeaderRefresh()
                
            }
            
        }
//
//        
        self.tableView.addFooterRefreshWithActionHandler { () -> Void in
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                self.tableView.stopFooterRefresh()
                
            }
        }
        
    }

   //MARK: tableView datasource
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return 50
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 50
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identify = "CELL"
        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
        }
        
        cell?.textLabel?.text = "rose"
        
        return cell!
        
    }

//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        let state = scrollView.panGestureRecognizer.state
//        
//        print("scrollViewWillEndDragging",state)
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        let state = scrollView.panGestureRecognizer.state
//        print("scrollViewDidEndDragging", scrollView.panGestureRecognizer.state)
//    }
    
}

