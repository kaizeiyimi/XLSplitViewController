XLSplitViewController
=====================

custom splitViewController. 

1. sometimes and I don't know why, the apple's UISplitViewController will not call the delegate method 
'– splitViewController:willHideViewController:withBarButtonItem:forPopoverController:'.

2. when the master shows up, the master view is on the top level of window. That's to say if there
is some view sit left to the splitViewController's view, this view will be covered when the master view moves.

these are the reason why I write this custom splitViewController. Hope it's useful to you.

the usage is very like apple's. additionally, you can customize the master's width, the split line width and the split line color.

Requirement
---------------------

iOS 5+, ARC.

NOTICE: the sample project is created by XCode5. Embed view is used in the project, so it must be run on iOS 6+.
