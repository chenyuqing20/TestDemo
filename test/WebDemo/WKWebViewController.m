//
//  WKWebViewController.m
//  test
//
//  Created by 盒子 on 2018/6/21.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "JDDAlertView.h"

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *wkwebView;

@property (nonatomic,strong) WKBackForwardList *webHistoryList;

@end

@implementation WKWebViewController
- (void)dealloc {
    [self removeObserver:_wkwebView forKeyPath:@"title"];
    [self removeObserver:_wkwebView forKeyPath:@"estimatedProgress"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_wkwebView) {
        // web配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        // 向oc注册js函数
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        [userController addScriptMessageHandler:self name:@"jsHandel"];
        [userController addScriptMessageHandler:self name:@"jsHandelWithParam"];
        config.userContentController = userController;
        
        _wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _wkwebView.UIDelegate = self;
        _wkwebView.navigationDelegate = self;
        _wkwebView.allowsBackForwardNavigationGestures = YES;
        _webHistoryList = _wkwebView.backForwardList;
        [self.view addSubview:_wkwebView];
    
    }
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_wkwebView loadHTMLString:htmlString baseURL:baseURL];
    
    [_wkwebView addObserver:self forKeyPath:@"title" options:0 context:nil];
    [_wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];

}

//- (WKWebView *)wkwebView {
//    if (!_wkwebView) {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
//        _wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//        _wkwebView.UIDelegate = self;
//        _wkwebView.navigationDelegate = self;
//        _wkwebView.allowsBackForwardNavigationGestures = YES;
//        _webHistoryList = _wkwebView.backForwardList;
//
//        // 向oc注册js函数
//        WKUserContentController *userController = [[WKUserContentController alloc] init];
//        [userController addScriptMessageHandler:self name:@"jsToOc"];
//        [userController addScriptMessageHandler:self name:@"jsToOcWithJsonString"];
//    }
//    return _wkwebView;
//}

- (void)ocToJs {
    NSString *ocTojs = [NSString stringWithFormat:@"ocToJs('%@')",@"盒子大名"];
    [_wkwebView evaluateJavaScript:ocTojs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"oc调用js并传参 %@ error = %@",result,error.localizedDescription);
    }];
}

#pragma mark - UIDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"wkweb - didStartProvisionalNavigation\n");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkweb - didFailProvisionalNavigation\n");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"wkweb - didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"wkweb - didFinishNavigation");
    [self ocToJs];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkweb - didFailNavigation");
}

#pragma mark - MessageHandel
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"jsHandel"]) {
        NSLog(@"js调用oc jsHandel,param = %@",message.body);
    }else if ([message.name isEqualToString:@"jsHandelWithParam"]){
        NSLog(@"js调用oc jsHandelWithParam,param = %@",message.body);
    }else if ([message.name isEqualToString:@"jsObjectToOc"]){
        
    }
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"Alert Handel");
    JDDAlertView *alert = [[JDDAlertView alloc] initJDDConfirmWithTitle:nil andMessage:message]
    .leftBtnText(@"收到")
    .rightBtnText(@"关闭")
    .titleFontSize(20)
    .messageFontSize(18)
    .leftBtnTextColor([UIColor greenColor])
    .rightBtnTextColor([UIColor redColor])
    .leftBtnFontSize(18)
    .rightBtnFontSize(18);
    [alert show];
    alert.alertHandelBlock = ^(NSInteger index, id data) {
        NSLog(@"index = %ld",(long)index);
    };
    completionHandler();
}

#pragma mark - kvo 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.title = _wkwebView.title;
    }else if ([keyPath isEqualToString:@"estimatedProgress"]){
        NSLog(@"网页加载进度 = %.2f",_wkwebView.estimatedProgress);
    }
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
