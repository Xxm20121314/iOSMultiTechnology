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
/** 回退*/
@property (nonatomic, strong) UIButton *goBackBtn;
/** 前进*/
@property (nonatomic, strong) UIButton *goForwardBtn;
/** 刷新*/
@property (nonatomic, strong) UIButton *reloadBtn;
@end
@implementation BaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSURL *url = nil;
    if (self.urlString) {
       url = [NSURL URLWithString:self.urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    if (self.sourceName) {
        NSString*filePath = [[NSBundle mainBundle] pathForResource:self.sourceName ofType:nil];
        url = [[NSBundle mainBundle] URLForResource:self.sourceName withExtension:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSString *mimeType = [NSString mimeTypeForFileAtPath:filePath];
        [self.webView loadData:data MIMEType:mimeType textEncodingName:@"UTF-8" baseURL:url];
    }
    [self navigationItemLeftItems];
}
- (void)navigationItemLeftItems
{
    self.goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goBackBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.goBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goBackBtn setTitle:@"后退" forState:UIControlStateNormal];
    [self.goBackBtn setTitle:@"后退" forState:UIControlStateDisabled];
    [self.goBackBtn addTarget:self action:@selector(goBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackBtn sizeToFit];
    
    self.goForwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goForwardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.goForwardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goForwardBtn setTitle:@"前进" forState:UIControlStateNormal];
    [self.goForwardBtn setTitle:@"前进" forState:UIControlStateDisabled];
    [self.goForwardBtn addTarget:self action:@selector(goForwardClick) forControlEvents:UIControlEventTouchUpInside];
    [self.goForwardBtn sizeToFit];

    self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reloadBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [self.reloadBtn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadBtn sizeToFit];

    self.navigationItem.rightBarButtonItems= @[[[UIBarButtonItem alloc] initWithCustomView:self.goBackBtn],
                                               [[UIBarButtonItem alloc] initWithCustomView:self.goForwardBtn],
                                               [[UIBarButtonItem alloc] initWithCustomView:self.reloadBtn],
    ];
    
}
- (void)goBackBtnClick
{
    
    [self.webView goBack];
}
- (void)goForwardClick
{
    [self.webView goForward];
}
- (void)reloadClick
{
    [self.webView reload];
}
//每当将加载请求的时候调用该方法，返回YES 表示加载该请求，返回NO 表示不加载该请求
//可以在该方法中拦截请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //设置是否能够前进和回退
    self.goBackBtn.enabled = webView.canGoBack;
    self.goForwardBtn.enabled = webView.canGoForward;
    return YES;
}
//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求

-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"%s",__func__);
}
//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"document.title";
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:js];
//    NSLog(@"%s",__func__);
}
//网页加载失败调用该方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"%s",__func__);
}
-(UIWebView*)webView
{
    if (!_webView){
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _webView;
}
@end
