//
//  DemoAirbnbTableViewController.m
//  TMOEmptyDataSetDemo
//
//  Created by 崔 明辉 on 14-7-13.
//  Copyright (c) 2014年 崔 明辉. All rights reserved.
//

#import "DemoAirbnbTableViewController.h"
#import "TMOTableView.h"

@interface DemoAirbnbTableViewController ()

@property (strong, nonatomic) IBOutlet TMOTableView *tableView;

@end

@implementation DemoAirbnbTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *failView = [[[NSBundle mainBundle] loadNibNamed:@"AirbnbFail" owner:nil options:nil] firstObject];
    
    [self.tableView firstLoadWithBlock:^(TMOTableView *tableView, id viewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView.myFirstLoadControl fail];//always fail
        });
    } withLoadingView:nil withFailView:failView];
    
    UIButton *retryButton = (UIButton *)[failView viewWithTag:1];
    [retryButton addTarget:self.tableView.myFirstLoadControl action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
