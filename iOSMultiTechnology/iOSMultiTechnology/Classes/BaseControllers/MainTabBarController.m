//
//  MainTabBarController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "HomeTableViewController.h"
#import "OtherTableViewController.h"

@interface MainTabBarController ()<UINavigationControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBarView];
}
- (void)initTabBarView{
    
    //必须要在这里写 标题，否则底部文字会有重叠
    
    HomeTableViewController *homePageVC = [[HomeTableViewController alloc] init];
    homePageVC.title = @"首页";
    MainNavigationController *nav1 = [[MainNavigationController alloc] initWithRootViewController:homePageVC];
    nav1.delegate = self;
    
    OtherTableViewController *otherVC = [[OtherTableViewController alloc] init];
    otherVC.title = @"其他";
    MainNavigationController *nav2 = [[MainNavigationController alloc] initWithRootViewController:otherVC];
    nav2.delegate = self;
    
    NSArray *navArrays = @[nav1,nav2];
    self.viewControllers = navArrays;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
