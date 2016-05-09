//
//  CZPullToRefresh.swift
//  CZPullToRefresh framework
//
//  Created by Tong Zhao on 16/5/9.
//  Copyright © 2016年 ChazZhao.com. All rights reserved.
//

import UIKit
import Foundation

//MARK: - define refresh view height -
private let PullRefreshViewHeight: CGFloat = 70
private var Key: Void?
public typealias handler = () -> ()

public enum IndicatorType {
    case SystemIndicator
    case CustomIndicator
}

extension UIScrollView: UIScrollViewDelegate {
    
    public var pullRefreshView: CZPullToRefreshScrollview? {
        get {
            return objc_getAssociatedObject(self, &Key) as? CZPullToRefreshScrollview
        }
        set {
            self.willChangeValueForKey("pullRefreshView")
            objc_setAssociatedObject(self, &Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValueForKey("pullRefreshView")
        }
    }
    /**
     UIScrollView extension for pulling to refresh.
     - Usage:
     - add func "addpullToRefreshScrollWithHandler" in viewDidLoad()
     - add func "stopPullRefreshAnimation" when update view forData
     - parameter handler: doing network request in handler
     - parameter topInsert: insert of tableview top.
     - parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator" : use a CGPath indicator, you can edit CGPath in func "scrollBezierPath()"
     */
    public func addpullToRefreshScrollWithHandler(topInsert: CGFloat ,indicatorType: IndicatorType, actionHandler: handler) {
        if pullRefreshView == nil {
            pullRefreshView = CZPullToRefreshScrollview(frame: CGRect(x: CGFloat(0), y: -PullRefreshViewHeight, width: bounds.width, height: PullRefreshViewHeight), topInsert: topInsert, indicatorType: indicatorType)
            if let pullRefreshView = pullRefreshView {
                addSubview(pullRefreshView)
                pullRefreshView.autoresizingMask = .FlexibleWidth
                addPullRefreshViewObservers()
            }
        }
        pullRefreshView?.actionHandler = actionHandler
    }
    
    func addPullRefreshViewObservers() {
        if let pullRefreshView = pullRefreshView {
            addObserver(pullRefreshView, forKeyPath: "contentOffset", options:.New, context: nil)
            addObserver(pullRefreshView, forKeyPath: "contentSize", options:.New, context: nil)
        }
    }
}

public class CZPullToRefreshScrollview: UIView {
    
    public enum State {
        case Stopped
        case Triggered
        case OverTriggerd
        case Loading
    }
    
    public var state: State = .Stopped {
        didSet(previous) {
            if state != previous {
                setNeedsLayout()
                switch state {
                case .Loading:
                    if previous == .OverTriggerd {
                        beginRefresh()
                        actionHandler?()
                    }
                case .Stopped:
                    resetScrollViewContentInset()
                case .Triggered:
                    if scrollviewIndicatorType == .SystemIndicator {
                        activityIndicator.startAnimating()
                    }
                    break
                case .OverTriggerd:
                    if scrollviewIndicatorType == .SystemIndicator {
                        activityIndicator.startAnimating()
                    }
                    break
                }
                
            }
        }
    }
    
    public var actionHandler: handler?
    
    let radius: CGFloat = 8
    //MARK: - define lineWidth -
    let lineWidth: CGFloat = 2
    private var progress: CGFloat = 0.0
    var isAnimation = false
    var isRefreshing = false
    var scrollViewOriginContentTopInset: CGFloat = 0
    var scrollviewIndicatorType: IndicatorType = .SystemIndicator
    var shapLayer = CAShapeLayer()
    
    public var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, topInsert: CGFloat, indicatorType: IndicatorType) {
        super.init(frame: frame)
        scrollViewOriginContentTopInset = topInsert
        scrollviewIndicatorType = indicatorType
        initViews()
    }
    
    func initViews() {
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.strokeColor = UIColor.lightGrayColor().CGColor
        let positionY = scrollViewOriginContentTopInset >= 33 ? PullRefreshViewHeight - scrollViewOriginContentTopInset + 8 : PullRefreshViewHeight / 2
        
        switch scrollviewIndicatorType {
        case .SystemIndicator:
            activityIndicator.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, positionY)
            addSubview(activityIndicator)
        case .CustomIndicator:
            shapLayer.anchorPoint = CGPointMake(0, 0)
            shapLayer.bounds = CGRectMake( 0 , 0, 100, 100)
            shapLayer.position = CGPointMake(UIScreen.mainScreen().bounds.width / 2 - 10, positionY)
            shapLayer.transform = CATransform3DMakeScale(0.2, 0.2, 1)
            layer.addSublayer(shapLayer)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            scrollViewDidScroll(change?[NSKeyValueChangeNewKey]?.CGPointValue)
        } else if keyPath == "contentSize" {
            setNeedsLayout()
            self.frame = CGRectMake(0, -PullRefreshViewHeight, self.bounds.size.width, PullRefreshViewHeight);
        } else if keyPath == "frame" {
            setNeedsLayout()
        }
    }
    
    private func scrollViewDidScroll(contentOffset: CGPoint?) {
        guard let scrollview = scrollView, let offset = contentOffset else { return }
        if state != .Loading {
            if !scrollview.dragging && state == .OverTriggerd {
                state = .Loading
            } else if -offset.y < PullRefreshViewHeight && scrollview.dragging {
                if scrollviewIndicatorType == .CustomIndicator {
                    scrollAnimate(-offset.y)
                }
                state = .Triggered
            } else if -offset.y >= PullRefreshViewHeight && scrollview.dragging && state == .Triggered {
                if scrollviewIndicatorType == .CustomIndicator {
                    scrollAnimate(-offset.y)
                }
                state = .OverTriggerd
            } else if -offset.y < PullRefreshViewHeight && state != .Stopped {
                state = .Triggered
            }
        }
    }
    
    func beginRefresh() {
        isRefreshing = true
        isAnimation = true
        
        guard let scrollview = scrollView else { return }
        UIView.animateWithDuration(0.3) {
            var inSet = scrollview.contentInset
            inSet.top += self.frame.size.height
            self.scrollView?.contentInset = inSet
        }
        
        switch scrollviewIndicatorType {
        case .SystemIndicator:
            activityIndicator.startAnimating()
            return
        case .CustomIndicator:
            shapLayer.path = scrollBezierPath(1)
            shapLayer.fillColor = UIColor.clearColor().CGColor
            shapLayer.lineWidth = lineWidth
            shapLayer.lineDashPattern = [1.5]
            
            let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
            baseAnimation.duration = 0.8
            baseAnimation.fromValue = 0
            baseAnimation.toValue = 1
            baseAnimation.timeOffset = Double()
            baseAnimation.repeatDuration = 50
            shapLayer.addAnimation(baseAnimation, forKey: nil)
        }
    }
    
    func stopPullRefreshAnimation() {
        isRefreshing = false
        delay(0.8) {
            self.activityIndicator.stopAnimating()
            self.state = .Stopped
            self.isAnimation = false
            self.shapLayer.removeAllAnimations()
        }
    }
    
    func resetScrollViewContentInset() {
        guard let scrollview = scrollView else { return }
        UIView.animateWithDuration(0.5) {
            var inSet = scrollview.contentInset
            inSet.top  = self.scrollViewOriginContentTopInset
            self.scrollView?.contentInset = inSet
        }
    }
    
    func scrollAnimate(offY: CGFloat) {
        progress = min(offY / self.frame.height, 1.0)
        progress = min(offY / self.frame.height, 0.971428)
        reDrawLayer()
    }
    
    func reDrawLayer() {
        if !isAnimation {
            shapLayer.lineWidth = lineWidth
            shapLayer.lineDashPattern = [1.5]
            shapLayer.fillColor = UIColor.clearColor().CGColor
            shapLayer.path = scrollBezierPath(progress)
            shapLayer.strokeEnd = progress
        }
    }
    
    func scrollBezierPath(progress: CGFloat) -> CGPath {
        //you can rewrite any bezierPath yourself.
        return UIBezierPath(arcCenter: CGPointMake(frame.size.width / 2 , frame.size.height - 25), radius: radius * progress, startAngle: 0.0 , endAngle: CGFloat( 2 * M_PI ) * progress, clockwise: true).CGPath
    }
    
    public func delay(secounds: Double , completion:() -> ()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * secounds))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        return activityIndicator
    }()
}


