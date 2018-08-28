//
//  TodayViewController.m
//  WidgetDemo
//
//  Created by 盒子 on 2018/6/22.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Masonry.h"

#define JDD_WidgetSmallHeight 110
#define JDD_WidgetBigHeight 400

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic,strong) UIView *bgView;
@end

@implementation TodayViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }else {
        self.preferredContentSize = CGSizeMake(JDD_ScreenWidth,JDD_WidgetBigHeight);
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JDD_ScreenWidth, self.view.frame.size.height)];
    _bgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, JDD_WidgetSmallHeight, JDD_ScreenWidth, JDD_WidgetBigHeight-JDD_WidgetSmallHeight)];
    imgView.backgroundColor = [UIColor greenColor];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    [imgView setImage:[UIImage imageNamed:@"keyboard"]];
    [_bgView addSubview:imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openApp)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)openApp {
    NSLog(@"openApp");
    [self.extensionContext openURL:[NSURL URLWithString:@"jump://"] completionHandler:^(BOOL success) {
        
    }];
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 16, 9, 0);
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize API_AVAILABLE(ios(10.0)){
    switch (activeDisplayMode)
    {
        case NCWidgetDisplayModeCompact:
            self.preferredContentSize = CGSizeMake(maxSize.width, JDD_WidgetSmallHeight);// iOS10以后 折叠时高度为固定值，没有用啦
            break;
            
        case NCWidgetDisplayModeExpanded:
            self.preferredContentSize = CGSizeMake(maxSize.width, JDD_WidgetBigHeight);
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
