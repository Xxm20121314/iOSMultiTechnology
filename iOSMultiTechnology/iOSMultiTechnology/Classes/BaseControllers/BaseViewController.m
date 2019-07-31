//
//  BaseViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

 - (void)showTipStr:(NSString *)string
{
    self.tipLabel.text = string;
   self.tipLabel.size =  [self.tipLabel sizeThatFits:self.view.size];
}
- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,0,0}];
        _tipLabel.numberOfLines = 0;
        [self.view addSubview:self.tipLabel];
    }
    return _tipLabel;
    
    
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
