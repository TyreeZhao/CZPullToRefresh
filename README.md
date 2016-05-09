##CZPullToRefresh

##UIScrollView extension for pulling to refresh.
###Usage:
 * add func "addpullToRefreshScrollWithHandler" in viewDidLoad()
 * add func "stopPullRefreshAnimation" when update view forData
 * parameter handler: doing network request in handler
 * parameter topInsert: insert of tableview top.
 * parameter indicatorType: "SystemIndicator" : use system default indicator animate; "CustomIndicator" : use a CGPath indicator, you can edit CGPath in func "scrollBezierPath()"
