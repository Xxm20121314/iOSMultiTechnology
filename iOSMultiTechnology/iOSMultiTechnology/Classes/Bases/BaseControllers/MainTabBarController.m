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
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBarView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 回首页时显示底部tabbar
    if (self.viewControllers.count > self.selectedIndex) {
        UINavigationController *nav = self.viewControllers[self.selectedIndex];
        if ([nav isKindOfClass:[UINavigationController class]] && nav.viewControllers.count == 1) {
            [self.tabBar setHidden:NO];
        }
    }
}
#pragma mark - s初始化
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
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count > 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.tabBar.hidden = YES;
        }];
    }else if(navigationController.viewControllers.count == 1){
        [UIView animateWithDuration:.3 animations:^{
            self.tabBar.hidden = NO;
        }];
    }
}

@end
