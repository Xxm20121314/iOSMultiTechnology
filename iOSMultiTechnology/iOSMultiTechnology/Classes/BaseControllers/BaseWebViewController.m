//
//  BaseWebViewController.m
//  iOSMultiTechnology
//
//  Created by 许小明 on 2019/7/25.
//  Copyright © 2019 许小明(xxm20121314@hotmail.com). All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation BaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s",__func__);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"document.title";
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"%s",__func__);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
-(UIWebView*)webView
{
    if (!_webView){
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
@end
