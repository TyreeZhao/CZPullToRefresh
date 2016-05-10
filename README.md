![](http://ivansun123.b0.upaiyun.com/chaz/picCZPull1.gif!bac)
---
# CZPullToRefresh
  These `UIScrollView` categories makes it super easy to add pull-to-refresh  to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing `UIViewController`, CZPullToRefresh uses the Objective-C runtime to add the following methods to` UIScrollView`:
```swift
public func addpullToRefreshScrollWithHandler(topInsert: CGFloat ,indicatorType: IndicatorType, actionHandler: handler)
```

##Installation
 * Drag the CZPullToRefresh floder in your project
 * that's all, so easy isn't it?!

### Usage:
 * add func "addpullToRefreshScrollWithHandler" in viewDidLoad()
 * add func "stopPullRefreshAnimation" when update view forData
 * parameter handler: doing network request in handler
 * parameter topInsert: insert of tableview top.
 * parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator(indicatorParh: UIBezierPath)" : input a CGPath parameter

### Adding pull to refresh

```swift
	$yourtableView.addpullToRefreshScrollWithHandler(topInsert, indicatorType: indicatorType) {
// prepend data to dataSource, insert cells at top of table view
// call [tableView.pullToRefreshView stopAnimating] when done
}

```

### Stop animating when done
```swift
	$yourtableView.pullRefreshView?.stopPullRefreshAnimation() 
```


###IndicatorType
 * SystemIndicator
 
> use system animation indicator when loading data.

 * CustomIndicator(indicatorPath: UIBezierPath)

> input a UIBezierPath indicator, which you hope indicator present.


###other changeable property in code
```swift
	/**
     	after addpullToRefreshScrollWithHandler function modified this prperty, 
     	use for transform the indicator centerY offset:(if needed)
     	- default : 0
     	- parameter +: move down indicator
     	- parameter -: move up indicator
     	*/
	public var indicatorPositionYOffset: CGFloat = 0
	
	//MARK: - define refresh view height -
	private let PullRefreshViewHeight: CGFloat = 70
	//MARK: - define lineWidth -
	let lineWidth: CGFloat = 2
```
<font color=red>**近期会经常维护github，任何问题随时交流**</font>
**如果你也喜欢这个Demo，请在右上角点个🌟，每一颗🌟都是我继续努力写出好的项目的动力！**
