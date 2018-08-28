//
//  JDDBannerView.h
//  test
//
//  Created by 盒子 on 2018/6/6.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDDBannerClickHandler)(NSInteger index);

typedef NS_ENUM(NSInteger,AlignmentType){
    Alignment_Left,
    Alignment_Center,
    Alignment_Right
};

@interface JDDBannerView : UIView

@property (nonatomic,copy) JDDBannerClickHandler bannerClickHandler;

// 默认选中项
@property (nonatomic,assign) NSInteger nomalSelectIndex;

// 当前选中项
@property (nonatomic,assign) NSInteger currentSelectIndex;

// 默认图片
@property (nonatomic,strong) UIImage *defaultImage;

// 选中项dot颜色
@property (nonatomic,strong) UIColor *selectDotColor;

// 非选中项dot颜色
@property (nonatomic,strong) UIColor *nomalDotColor;

// 是否自动滚动
@property (nonatomic,assign) BOOL isAutomaticScroll;

// 自动滚动时间(秒)
@property (nonatomic,assign) NSInteger automaticTime;

// 是否循环滚动
@property (nonatomic,assign) BOOL isLoop;

// 图片
@property (nonatomic,strong) NSArray *imageList;
@end
