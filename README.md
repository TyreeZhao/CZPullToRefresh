# CZPullToRefresh
  These UIScrollView categories makes it super easy to add pull-to-refresh  to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing UIViewController, CZPullToRefresh uses the Objective-C runtime to add the following methods to UIScrollView:
  ```
      <font color = "red" >public func</font> addpullToRefreshScrollWithHandler(topInsert: <font color = "blue" >CGFloat<\font> ,indicatorType: <font color = "blue">IndicatorType</font>, actionHandler: <font color = "blue" >handler<\font>)
  ```
# UIScrollView extension for pulling to refresh.
### Usage:
 * add func "addpullToRefreshScrollWithHandler" in viewDidLoad()
 * add func "stopPullRefreshAnimation" when update view forData
 * parameter handler: doing network request in handler
 * parameter topInsert: insert of tableview top.
 * parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator" : use a CGPath indicator, you can edit CGPath in func "scrollBezierPath()"
