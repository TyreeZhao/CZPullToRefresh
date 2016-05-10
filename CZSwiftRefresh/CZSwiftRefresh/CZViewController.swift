//
//  CZViewController.swift
//  CZSwiftRefresh
//
//  Created by Tong Zhao on 16/5/10.
//  Copyright © 2016年 ChazZhao. All rights reserved.
//

import UIKit

class CZViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //fake data source
    var dataSource = [1, 2, 3, 4]
    var fakeData: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addpullToRefreshScrollWithHandler(0, indicatorType: IndicatorType.CustomIndicator(indicatorPath: path())) {
            self.networkRequest()
        }
        tableView.pullRefreshView?.indicatorPositionYOffset = -10

    }
    
    func networkRequest(){
        print("recieve data...")
        dataSource.append(fakeData)
        tableView.reloadData()
        tableView.pullRefreshView?.stopPullRefreshAnimation()
    }
    
    func delay(secounds: Double , completion:() -> ()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * secounds))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    func path() -> UIBezierPath {
        // dont be afraid, it just a custom path...
        let aPath = UIBezierPath()
        aPath.moveToPoint(CGPointMake(37.68, 10.68))
        aPath.addCurveToPoint(CGPointMake(26.75, 13.95), controlPoint1: CGPointMake(33.65, 10.68), controlPoint2: CGPointMake(29.89, 11.88))
        aPath.addCurveToPoint(CGPointMake(17.75, 30.63), controlPoint1: CGPointMake(21.32, 17.51), controlPoint2: CGPointMake(17.74, 23.65))
        aPath.addCurveToPoint(CGPointMake(37.71, 50.55), controlPoint1: CGPointMake(17.75, 41.63), controlPoint2: CGPointMake(26.69, 50.55))
        aPath.addCurveToPoint(CGPointMake(57.67, 30.58), controlPoint1: CGPointMake(48.74, 50.54), controlPoint2: CGPointMake(57.68, 41.6))
        aPath.addCurveToPoint(CGPointMake(37.68, 10.68), controlPoint1: CGPointMake(57.65, 19.57), controlPoint2: CGPointMake(48.7, 10.66))
        aPath.closePath()
        aPath.moveToPoint(CGPointMake(60.45, 16.78))
        aPath.addCurveToPoint(CGPointMake(68.51, 15.1), controlPoint1: CGPointMake(62.94, 15.69), controlPoint2: CGPointMake(65.67, 15.1))
        aPath.addCurveToPoint(CGPointMake(87.88, 29.73), controlPoint1: CGPointMake(77.52, 15.1), controlPoint2: CGPointMake(85.43, 21.08))
        aPath.addCurveToPoint(CGPointMake(81.18, 50.82), controlPoint1: CGPointMake(90.08, 37.54), controlPoint2: CGPointMake(87.36, 45.82))
        aPath.addCurveToPoint(CGPointMake(100, 78.35), controlPoint1: CGPointMake(92.25, 55.41), controlPoint2: CGPointMake(100, 66.01))
        aPath.addLineToPoint(CGPointMake(100, 88.34))
        aPath.addLineToPoint(CGPointMake(93.33, 88.34))
        aPath.addLineToPoint(CGPointMake(93.33, 78.35))
        aPath.addCurveToPoint(CGPointMake(76.04, 56.06), controlPoint1: CGPointMake(93.33, 67.85), controlPoint2: CGPointMake(86.05, 58.98))
        aPath.addCurveToPoint(CGPointMake(74.8, 55.36), controlPoint1: CGPointMake(75.82, 56), controlPoint2: CGPointMake(75.02, 55.64))
        aPath.addCurveToPoint(CGPointMake(73.33, 51.72), controlPoint1: CGPointMake(74.13, 54.45), controlPoint2: CGPointMake(73.33, 52.61))
        aPath.addCurveToPoint(CGPointMake(73.33, 50.05), controlPoint1: CGPointMake(73.33, 50.86), controlPoint2: CGPointMake(73.33, 50.59))
        aPath.addCurveToPoint(CGPointMake(75.23, 46.67), controlPoint1: CGPointMake(73.33, 49.18), controlPoint2: CGPointMake(74.63, 47.02))
        aPath.addCurveToPoint(CGPointMake(81.8, 35.19), controlPoint1: CGPointMake(79.17, 44.36), controlPoint2: CGPointMake(81.81, 40.08))
        aPath.addCurveToPoint(CGPointMake(68.49, 21.95), controlPoint1: CGPointMake(81.79, 27.87), controlPoint2: CGPointMake(75.83, 21.94))
        aPath.addCurveToPoint(CGPointMake(63.23, 23.04), controlPoint1: CGPointMake(66.62, 21.95), controlPoint2: CGPointMake(64.84, 22.34))
        aPath.addLineToPoint(CGPointMake(63.32, 23.36))
        aPath.addCurveToPoint(CGPointMake(51.65, 53.23), controlPoint1: CGPointMake(66.56, 34.8), controlPoint2: CGPointMake(61.79, 47))
        aPath.addCurveToPoint(CGPointMake(75.56, 88.34), controlPoint1: CGPointMake(65.65, 58.75), controlPoint2: CGPointMake(75.56, 72.39))
        aPath.addCurveToPoint(CGPointMake(75.56, 95), controlPoint1: CGPointMake(75.56, 90.61), controlPoint2: CGPointMake(75.56, 92.8))
        aPath.addLineToPoint(CGPointMake(68.64, 95))
        aPath.addCurveToPoint(CGPointMake(68.89, 88.34), controlPoint1: CGPointMake(68.89, 92.81), controlPoint2: CGPointMake(68.89, 90.63))
        aPath.addCurveToPoint(CGPointMake(63.31, 70.59), controlPoint1: CGPointMake(68.89, 81.74), controlPoint2: CGPointMake(66.83, 75.62))
        aPath.addLineToPoint(CGPointMake(63.22, 70.59))
        aPath.addCurveToPoint(CGPointMake(51.07, 60.24), controlPoint1: CGPointMake(60.14, 66.14), controlPoint2: CGPointMake(55.94, 62.57))
        aPath.addCurveToPoint(CGPointMake(37.78, 57.27), controlPoint1: CGPointMake(47.04, 58.33), controlPoint2: CGPointMake(42.53, 57.27))
        aPath.addCurveToPoint(CGPointMake(6.67, 88.34), controlPoint1: CGPointMake(20.6, 57.27), controlPoint2: CGPointMake(6.67, 71.18))
        aPath.addCurveToPoint(CGPointMake(6.69, 89.84), controlPoint1: CGPointMake(6.67, 88.85), controlPoint2: CGPointMake(6.68, 89.35))
        aPath.addCurveToPoint(CGPointMake(7.09, 95), controlPoint1: CGPointMake(6.75, 91.59), controlPoint2: CGPointMake(6.9, 93.3))
        aPath.addLineToPoint(CGPointMake(0, 95))
        aPath.addCurveToPoint(CGPointMake(0, 88.34), controlPoint1: CGPointMake(-0, 92.81), controlPoint2: CGPointMake(0, 90.61))
        aPath.addCurveToPoint(CGPointMake(4.44, 70.59), controlPoint1: CGPointMake(0, 81.92), controlPoint2: CGPointMake(1.6, 75.88))
        aPath.addCurveToPoint(CGPointMake(23.78, 53.24), controlPoint1: CGPointMake(8.52, 62.86), controlPoint2: CGPointMake(15.29, 56.62))
        aPath.addCurveToPoint(CGPointMake(12.09, 23.36), controlPoint1: CGPointMake(13.62, 47.02), controlPoint2: CGPointMake(8.85, 34.81))
        aPath.addCurveToPoint(CGPointMake(25.67, 6.87), controlPoint1: CGPointMake(14.16, 16.03), controlPoint2: CGPointMake(19.19, 10.15))
        aPath.addCurveToPoint(CGPointMake(37.7, 4), controlPoint1: CGPointMake(29.32, 5.02), controlPoint2: CGPointMake(33.42, 4))
        aPath.addCurveToPoint(CGPointMake(60.45, 16.78), controlPoint1: CGPointMake(47.17, 4), controlPoint2: CGPointMake(55.71, 8.99))
        aPath.closePath()
        return aPath
    }

}

extension CZViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pullCell", forIndexPath: indexPath)
        cell.textLabel?.text = String(dataSource[indexPath.row])
        
        let green = arc4random_uniform(256)
        let red = arc4random_uniform(256)
        let blue = arc4random_uniform(256)
        cell.backgroundColor = UIColor(colorLiteralRed: Float(red) / 256, green: Float(green) / 256, blue: Float(blue) / 256, alpha: 1)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}

