//
//  UIWebView+JavaScriptAlert.m
//  test
//
//  Created by 盒子 on 2018/6/27.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"
#import "JDDAlertView.h"

@implementation UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    JDDAlertView *alert = [[JDDAlertView alloc] initJDDAlertWithTitle:nil andMessage:message]
    .leftBtnText(@"确定")
    .rightBtnText(@"ee")
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
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    JDDAlertView *alert = [[JDDAlertView alloc] initJDDConfirmWithTitle:nil andMessage:message]
    .leftBtnText(@"取消")
    .rightBtnText(@"确定")
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
    return YES;
    
}

@end
