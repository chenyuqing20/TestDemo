//
//  ViewController.m
//  test
//
//  Created by 盒子 on 2018/6/1.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "ViewController.h"
#import "JDDAlertView.h"
#import "TableController.h"
#import "JDDBannerView.h"
#import "Masonry.h"
#import "JDDPageControl.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) CGFloat contentOffset;
@property (strong,nonatomic) NSArray *bannerList;

@property (strong,nonatomic) JDDBannerView *bannerView;
@property (strong,nonatomic) JDDPageControl *pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _bannerList = @[@"3(0)",@"1",@"2",@"3",@"1(4)"];
    _bannerList = @[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644077758,3194768429&fm=200&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528381529463&di=ccf6df079030e2c83e65e20a6c2ee985&imgtype=0&src=http%3A%2F%2Fpic1.cxtuku.com%2F00%2F10%2F24%2Fb544b2c80936.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528382157258&di=aaa873c8043165ec024c0a9f5a059019&imgtype=0&src=http%3A%2F%2Fdown1.sucaitianxia.com%2Fpsd02%2Fpsd222%2Fpsds55427.jpg"];
    
//    self.bannerView = [[JDDBannerView alloc] init];
//    self.bannerView.imageList = self.bannerList;
//    self.bannerView.isAutomaticScroll = YES;
//    self.bannerView.automaticTime = 2.0;
//    self.bannerView.selectDotColor = [UIColor lightGrayColor];
//    self.bannerView.nomalDotColor = [UIColor groupTableViewBackgroundColor];
//    self.bannerView.defaultImage = [UIImage imageNamed:@"discover_banner_default"];
//    [self.view addSubview:_bannerView];
    
    
    UIView *pageView = [[UIView alloc] init];
    pageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pageView];
    
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.height.equalTo(pageView.mas_width);
        make.center.equalTo(self.view);
    }];
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self yAnimation:pageView];
    });
}

- (void)yAnimation:(UIView *)view {
    CABasicAnimation* rotationAnimation;
    //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    //旋转角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    //每次旋转的时间（单位秒）
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = 0;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)buttonClick:(id)sender {
    [self showAlert];
    
}

- (void)showAlert{
    JDDAlertView *alert = [[JDDAlertView alloc] initJDDAlertWithTitle:nil andMessage:@"打开列表页吗?"]
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


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset >= self.contentOffset * 2) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
