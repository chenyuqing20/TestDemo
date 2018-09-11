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

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

extern int ffmpeg_main(int argc, char * argv[]);

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

/**
 获取每一秒的帧图

 @param videoPath 视频路径
 @return 图片数组
 */
- (NSArray *) getVideoPreViewImage:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    int second = 0;
    NSLog(@"duration.value%.2lld  duration.timescale=%.2d",asset.duration.value,asset.duration.timescale);
    second = floor(asset.duration.value / asset.duration.timescale); // 获取视频总时长,单位秒
    NSMutableArray *coverArray = [[NSMutableArray alloc] init];
    for (int i=0; i<second; i++) {
        CMTime time = CMTimeMakeWithSeconds(i, i);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *img = [[UIImage alloc] initWithCGImage:image];
        if (img) {
            [coverArray addObject:img];
        }
        CGImageRelease(image);
    }
    return coverArray;
}
- (void)ffmpegGetVideoPreViewImage:(NSString *)videoPath {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *movie = (char *)[BundlePath(@"ta.mp4") UTF8String];
        char *outPic = (char *)[DocumentPath(@"%05d.jpg") UTF8String];
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-r",
            "10",
            outPic
        };
//        ffmpeg_main(sizeof(a)/sizeof(*a), a);
    });
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
