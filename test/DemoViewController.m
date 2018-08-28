//
//  DemoViewController.m
//  test
//
//  Created by 盒子 on 2018/6/12.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "DemoViewController.h"
#import "JDDAlertView.h"
#import "TableController.h"
#import "JDDBannerView.h"
#import "Masonry.h"
#import "JDDPageControl.h"
#import "BaseTextView.h"

@interface DemoViewController ()
//banner
@property (strong,nonatomic) NSArray *bannerList;
@property (strong,nonatomic) JDDBannerView *bannerView;
@property (strong,nonatomic) JDDPageControl *pageControl;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTextView];
    switch (self.type) {
        case kVC_Banner:
            [self addBannerView];
            break;
        case kVC_Alert:
            [self showAlert];
            break;
        case kVC_Animation_Y:
            [self yAnimation];
            break;
        case kVC_Animation_Z:
            [self zAnimation];
            break;
        case kVC_Animation_X:
            [self xAnimation];
            break;
        case kVC_Animation_Scale:
            [self scaleAnimation];
            break;
        case kVC_Animation_Jump:
            [self jumpAnimation];
            break;
        case kVC_AutoItem:
            [self autoItems];
            break;
        default:
            break;
    }
    
}

- (void)addTextView {
    self.automaticallyAdjustsScrollViewInsets=NO;
    BaseTextView *textView = [[BaseTextView alloc] initWithFrame:CGRectMake(16, 70, JDD_ScreenWidth-32, 100)]
    .placeholder(@"请输入内容")
    .placeholderColor([UIColor lightGrayColor])
    .placeholderFont([UIFont systemFontOfSize:15])
    .needShowTextNumber(YES)
    .maxTextCount(4)
    .tipTextFont([UIFont systemFontOfSize:12])
    .currentTextColor([UIColor redColor]);
    [textView setBackgroundColor:[UIColor yellowColor]];
    [textView.layer setCornerRadius:8];
    textView.baseTextViewDidChange = ^(NSString *allText, NSString *newText) {
        NSLog(@"allText = %@\nnewText = %@",allText,newText);
    };
    [self.view addSubview:textView];
}

//banner
- (void)addBannerView{
    _bannerList = @[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644077758,3194768429&fm=200&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528381529463&di=ccf6df079030e2c83e65e20a6c2ee985&imgtype=0&src=http%3A%2F%2Fpic1.cxtuku.com%2F00%2F10%2F24%2Fb544b2c80936.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528382157258&di=aaa873c8043165ec024c0a9f5a059019&imgtype=0&src=http%3A%2F%2Fdown1.sucaitianxia.com%2Fpsd02%2Fpsd222%2Fpsds55427.jpg"];
    
    self.bannerView = [[JDDBannerView alloc] init];
    self.bannerView.imageList = self.bannerList;
    self.bannerView.isAutomaticScroll = YES;
    self.bannerView.automaticTime = 2.0;
    self.bannerView.selectDotColor = [UIColor lightGrayColor];
    self.bannerView.nomalDotColor = [UIColor groupTableViewBackgroundColor];
    self.bannerView.defaultImage = [UIImage imageNamed:@"discover_banner_default"];
    [self.view addSubview:_bannerView];

    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}

// y轴翻转
- (void)yAnimation {
    
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.Y轴翻转
        CABasicAnimation* rotationAnimation;
        //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        //旋转角度
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
        //每次旋转的时间（单位秒）
        rotationAnimation.duration = 0.4;
        rotationAnimation.cumulative = YES;
        //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
        rotationAnimation.repeatCount = MAXFLOAT;
        [pageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
// z轴翻转
- (void)zAnimation {
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.Y轴翻转
        CABasicAnimation* rotationAnimation;
        //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //旋转角度
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        //每次旋转的时间（单位秒）
        rotationAnimation.duration = 0.4;
        rotationAnimation.cumulative = YES;
        //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
        rotationAnimation.repeatCount = MAXFLOAT;
        [pageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
// x轴翻转
- (void)xAnimation {
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.Y轴翻转
        CABasicAnimation* rotationAnimation;
        //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        //旋转角度
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI ];
        //每次旋转的时间（单位秒）
        rotationAnimation.duration = 0.4;
        rotationAnimation.cumulative = YES;
        //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
        rotationAnimation.repeatCount = MAXFLOAT;
        [pageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
// scale
- (void)scaleAnimation {
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.Y轴翻转
        CABasicAnimation* rotationAnimation;
        //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //开始比例
        rotationAnimation.fromValue = [NSNumber numberWithFloat: 1.0 ];
        //放大比例
        rotationAnimation.toValue = [NSNumber numberWithFloat: 1.5 ];
        //每次旋转的时间（单位秒）
        rotationAnimation.duration = 0.4;
        rotationAnimation.cumulative = NO;
        //返回原状
        rotationAnimation.autoreverses = YES;
        //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
        rotationAnimation.repeatCount = MAXFLOAT;
        [pageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
// alert
- (void)showAlert{
    JDDAlertView *alert = [[JDDAlertView alloc] initJDDConfirmWithTitle:nil andMessage:@"打开列表页吗?"]
    .leftBtnText(@"暂不操作")
    .rightBtnText(@"打开")
    .titleFontSize(20)
    .messageFontSize(18)
    .leftBtnTextColor([UIColor greenColor])
    .rightBtnTextColor([UIColor redColor])
    .leftBtnFontSize(18)
    .rightBtnFontSize(18);
    [alert show];
    alert.alertHandelBlock = ^(NSInteger index, id data) {
        NSLog(@"index = %ld",(long)index);
        if (index == 1) {
            TableController *tc = [[TableController alloc] init];
            [self.navigationController pushViewController:tc animated:YES];
        }
    };
    
}
// Jump
- (void)jumpAnimation {
    
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.3;
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [array addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [array addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
        animation.values = array;
        [pageView.layer addAnimation:animation forKey:@"transform"];
    });
    
}

// Masonry等间距排列
- (void)autoItems {
    UIScrollView *pageView = [[UIScrollView alloc] init];
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width*0.8/3;
    pageView.contentSize = CGSizeMake(itemWidth * 10 + 20, 140);
    pageView.layer.borderColor = [UIColor redColor].CGColor;
    pageView.layer.borderWidth = 1;
    [self.view addSubview:pageView];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(140);
    }];
    
    NSMutableArray *btnArray = [NSMutableArray new];
    for (int i = 0; i<10; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor yellowColor]];
        [pageView addSubview:btn];
        [btnArray addObject:btn];
    }
    
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pageView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(itemWidth);
    }];
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
