# CZPullToRefresh
  These UIScrollView categories makes it super easy to add pull-to-refresh  to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing UIViewController, CZPullToRefresh uses the Objective-C runtime to add the following methods to UIScrollView:

		public func addpullToRefreshScrollWithHandler(topInsert: CGFloat ,indicatorType: IndicatorType, actionHandler: handler)

#UIScrollView extension for pulling to refresh.
### Usage:
 * add func "addpullToRefreshScrollWithHandler" in viewDidLoad()
 * add func "stopPullRefreshAnimation" when update view forData
 * parameter handler: doing network request in handler
 * parameter topInsert: insert of tableview top.
 * parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator" : use a CGPath indicator, you can edit CGPath in func "scrollBezierPath()"

### Adding pull to refresh
		tableView.addpullToRefreshScrollWithHandler(topInsert, indicatorType: indicatorType) {
	// prepend data to dataSource, insert cells at top of table view
    // call [tableView.pullToRefreshView stopAnimating] when done
  	}

### Stop animating when done
	tableView.pullRefreshView?.stopPullRefreshAnimation() 



###IndicatorType
 * SystemIndicator
 
> use system animation indicator when loading data.

 * CustomIndicator

> use a CGPath indicator, you can rewrite CGPath in function: scrollBezierPath()
>
>		func scrollBezierPath(progress: CGFloat) -> CGPath {
       // return a CGPath whatever you like
    }

###other changeable property in code
		 //MARK: - define refresh view height -
		private let PullRefreshViewHeight: CGFloat = 70
    	//MARK: - define lineWidth -
   	 let lineWidth: CGFloat = 2


