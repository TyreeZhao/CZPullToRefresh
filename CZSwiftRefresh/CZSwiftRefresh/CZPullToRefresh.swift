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
    case CustomIndicator(indicatorPath: UIBezierPath)
}

extension UIScrollView: UIScrollViewDelegate {
    
    public var pullRefreshView: CZPullToRefreshView? {
        get {
            return objc_getAssociatedObject(self, &Key) as? CZPullToRefreshView
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
     - parameter topInset: inset of tableview top.
     - parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator(indicatorParh: UIBezierPath)" : input a CGPath parameter
     */
    public func addpullToRefreshScrollWithHandler(topInset: CGFloat ,indicatorType: IndicatorType, actionHandler: handler) {
        if pullRefreshView == nil {
            pullRefreshView = CZPullToRefreshView(frame: CGRect(x: CGFloat(0), y: -PullRefreshViewHeight, width: bounds.width, height: PullRefreshViewHeight), topInset: topInset, indicatorType: indicatorType)
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

public class CZPullToRefreshView: UIView {
    /**
     after addpullToRefreshScrollWithHandler function modified this prperty, which use for transform the indicator centerY offset:
     - parameter +: move down indicator
     - parameter -: move up indicator
     */
    public var indicatorPositionYOffset: CGFloat = 0 {
        didSet {
            initViews()
        }
    }
    public var actionHandler: handler?
    
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
                        activityIndicator.startAnimating()
                        actionHandler?()
                    }
                case .Stopped:
                    resetScrollViewContentInset()
                case .Triggered:
                    switch scrollviewIndicatorType {
                    case .SystemIndicator:
                        activityIndicator.stopAnimating()
                        activityIndicator.hidden = false
                    default:
                        break
                    }
                    break
                case .OverTriggerd:
                    switch scrollviewIndicatorType {
                    case .SystemIndicator:
                        activityIndicator.startAnimating()
                    default:
                        break
                    }
                }
                
            }
        }
    }
    
    //MARK: - define lineWidth -
    let lineWidth: CGFloat = 4
    private var progress: CGFloat = 0.0
    var isAnimation = false
    var scrollViewOriginContentTopInset: CGFloat = 0
    var scrollviewIndicatorType: IndicatorType = .SystemIndicator
    var shapLayer = CAShapeLayer()
    var scrollBezierPath = UIBezierPath()
    
    public var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, topInset: CGFloat, indicatorType: IndicatorType) {
        super.init(frame: frame)
        switch indicatorType {
        case .CustomIndicator(let inputPath):
            scrollBezierPath = inputPath
        default: break
        }
        scrollViewOriginContentTopInset = topInset
        scrollviewIndicatorType = indicatorType
        initViews()
    }
    
    func initViews() {
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.strokeColor = UIColor.lightGrayColor().CGColor
        let positionY =  PullRefreshViewHeight / 2 + indicatorPositionYOffset
        
        switch scrollviewIndicatorType {
        case .SystemIndicator:
            activityIndicator.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, positionY)
            addSubview(activityIndicator)
        case .CustomIndicator:
            shapLayer.anchorPoint = CGPointMake(0, 0)
            shapLayer.bounds = CGRectMake( 0 , 0, 100, 100)
            shapLayer.position = CGPointMake(UIScreen.mainScreen().bounds.width / 2 - 20, positionY)
            shapLayer.masksToBounds = true
            shapLayer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            layer.addSublayer(shapLayer)
        }
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
                switch scrollviewIndicatorType {
                case .CustomIndicator(_):
                    scrollAnimate(-offset.y)
                default: break
                }
                state = .Triggered
            } else if -offset.y >= PullRefreshViewHeight && scrollview.dragging && state == .Triggered {
                switch scrollviewIndicatorType {
                case .CustomIndicator(_):
                    scrollAnimate(-offset.y)
                default: break
                }
                state = .OverTriggerd
            } else if -offset.y < PullRefreshViewHeight && state != .Stopped {
                state = .Triggered
            }
        }
    }
    
    func beginRefresh() {
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
        case .CustomIndicator:
            shapLayer.path = scrollBezierPath.CGPath
            shapLayer.fillColor = UIColor.clearColor().CGColor
            shapLayer.lineWidth = lineWidth
            
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
        reDrawLayer()
    }
    
    func reDrawLayer() {
        if !isAnimation {
            shapLayer.lineWidth = lineWidth
            shapLayer.fillColor = UIColor.clearColor().CGColor
            shapLayer.path = scrollBezierPath.CGPath
            shapLayer.strokeEnd = progress
        }
    }
    
    public func delay(secounds: Double , completion:() -> ()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * secounds))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        return activityIndicator
    }()
}

