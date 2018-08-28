//
//  WebViewController.m
//  test
//
//  Created by 盒子 on 2018/6/21.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JDDAlertView.h"
#import "UIWebView+JavaScriptAlert.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView setDelegate:self];
    _webView.scalesPageToFit = YES;
    [_webView setBackgroundColor:[UIColor whiteColor]];
    _webView.opaque = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:baseURL];
 
    // 进度条
    _progressView = [[UIProgressView alloc] initWithFrame:self.view.bounds];//[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 2)];
    _progressView.trackTintColor = [UIColor clearColor];
    [_progressView setTintColor:[UIColor orangeColor]];
    [self.webView addSubview:_progressView];
    [self.webView bringSubviewToFront:_progressView];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressView setProgress:0.7 animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressView setProgress:1 animated:YES];
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.progressView setProgress:0];
    });
    
    // oc调用js
    NSString *js = [NSString stringWithFormat:@"uiweb_ocTojsText(\"%@\")",@"我是oc的传过来的文本"];
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    NSString *testFromJs = [webView stringByEvaluatingJavaScriptFromString:@"uiweb_jsToOcText()"];
    NSLog(@"testFromJs = %@",testFromJs);
    
    // js调用oc
    [self loadJsObject:webView];
}
- (JSContext *)loadJsObject:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // uiweb_jsToOc()是js函数名称
    context[@"uiweb_jsToOc"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSLog(@"JS向OC传字符串 = %@",args);
        for (JSValue *jsVal in args) {
            NSLog(@"jsvalue = %@",[NSString stringWithFormat:@"%@",jsVal]);
        }
    };
    // uiweb_jsToOcWithJsonString()是js函数名称
    context[@"uiweb_jsToOcWithJsonString"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSLog(@"JS向OC传JsonString = %@",args);
        for (JSValue *jsVal in args) {
            NSString *jsonString = [NSString stringWithFormat:@"%@",jsVal];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"jsonDic = %@",jsonDic);
        }
    };
    return context;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    [webView webView:webView runJavaScriptAlertPanelWithMessage:@"测试标题" initiatedByFrame:_webView.frame];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
