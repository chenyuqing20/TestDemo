//
//  TimerShaftController.m
//  test
//
//  Created by 盒子 on 2018/8/27.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "TimerShaftController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface TimerShaftController ()
@property (nonatomic, strong) UIScrollView *scrollView;  //
@property (nonatomic, strong) UIView *hLine;  //
@property (nonatomic, strong) UIButton *playBtn;  //
@property (nonatomic, strong) UIView *videoPreview;  //
@end

@implementation TimerShaftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _videoPreview = [[UIView alloc] init];
    _videoPreview.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_videoPreview];
    [_videoPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_offset(180);
        make.height.mas_offset(280);
    }];
    
    _playBtn = [[UIButton alloc] init];
    [_playBtn setBackgroundColor:[UIColor blueColor]];
    [_playBtn setTitle:@"play" forState:UIControlStateNormal];
    [self.view addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(80);
        make.top.equalTo(self.videoPreview.mas_bottom).offset(20);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.height.equalTo(self.playBtn);
    }];
    
    CGFloat coverWidth = 56;
    CGFloat coverHeight = 80;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ta" ofType:@"mp4"];
    NSArray *list = [self getVideoPreViewImage:path];
    [_scrollView setContentSize:CGSizeMake(coverWidth*list.count * 2, coverHeight)];
    
    CGFloat spaceWidth = coverWidth*list.count/2;
    for (int i=0; i<list.count; i++) {
        UIImage *img = list[i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [imgView setFrame:CGRectMake(spaceWidth + coverWidth*i, 0, coverWidth, coverHeight)];
        [_scrollView addSubview:imgView];
    }
    [_scrollView setContentOffset:CGPointMake(spaceWidth, 0)];
    
}

- (NSArray *) getVideoPreViewImage:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
//    gen.requestedTimeToleranceAfter = kCMTimeZero;
//    gen.requestedTimeToleranceBefore = kCMTimeZero;
    int second = 0;
    second = floor(asset.duration.value / asset.duration.timescale); // 获取视频总时长,单位秒
    NSMutableArray *coverArray = [[NSMutableArray alloc] init];
    for (int i=0; i<second; i++) {
        CMTime time = CMTimeMakeWithSeconds(0.0, i*100);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *img = [[UIImage alloc] initWithCGImage:image];
        [coverArray addObject:img];
        CGImageRelease(image);
    }
    return coverArray;
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
