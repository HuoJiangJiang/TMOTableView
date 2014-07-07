TMOTableView
============

TMOTableView includes RefreshControl LoadMoreControl FirstLoadControl, and you can customize it. It support iOS5+, support UIViewController &amp; UITableViewController.

# Usage

## Pod

`pod 'TMOTableView'`

## Subclass(Must Do)

* Xib Or StoryBoard -> subclass UITableView To TMOTableView

* Code -> Init TMOTableView

---

## Use FirstLoadControl

![](https://raw.githubusercontent.com/duowan/TMOTableView/master/Wiki/1.gif)

* You use FirstLoadControl to avoid null content showed, and perform good user experience. We provide a  default loadingView, and we provide a default failView. Further more, you could custom it.

* It's really easy to use, see example code.

---

    [self.tableView firstLoadWithBlock:^(TMOTableView *tableView, DemoTableViewController *viewController) {
        //do something load data jobs
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (arc4random() % 10 < 3) {
                //We try to make load data jobs fail, and you can see what happen.
                [tableView.myFirstLoadControl fail];
            }
            else {
                viewController.numberOfRowsInSection0 = 5;
                viewController.numberOfRowsInSection1 = 8;
                [tableView.myFirstLoadControl done];//You don't need to use [tableView reloadData].
            }
        });
    } withLoadingView:customLoadingView withFailView:customFailView];


## Use RefreshControl

![](https://raw.githubusercontent.com/duowan/TMOTableView/master/Wiki/2.gif)

* RefreshControl, you know that! Our RefreshControl support iOS5+.

---

    [self.tableView refreshWithCallback:^(TMOTableView *tableView, DemoTableViewController *viewController) {
        viewController.numberOfRowsInSection0 = arc4random() % 10;
        viewController.numberOfRowsInSection1 = arc4random() % 10;
        [tableView refreshDone];
    } withDelay:1.5];//Really easy to use.
    //Don't use self in block! Use tableView, viewController. It will 'Circular references'.

---

## Use LoadMoreControl

![](https://raw.githubusercontent.com/duowan/TMOTableView/master/Wiki/3.gif)

* You use LoadMoreControl to show more cells.

---

    [self.tableView loadMoreWithCallback:^(TMOTableView *tableView, DemoTableViewController *viewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (arc4random() % 10 < 4) {
                //try to fail
                tableView.myLoadMoreControl.isFail = YES;
            }
            else {
                viewController.numberOfRowsInSection1 += 10;
                [tableView loadMoreDone];
            }
        });
    } withDelay:0.0];
