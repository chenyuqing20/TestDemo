//
//  JDDPageControl.m
//  test
//
//  Created by 盒子 on 2018/6/7.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "JDDPageControl.h"

@implementation JDDPageControl
- (instancetype)init {
    if (self == [super init]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}
//- (void)layoutSubviews {
//
//}
- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    for (int i=0; i < self.subviews.count; i++) {
        UIImageView *imageView = (UIImageView *)self.subviews[i];
        CGSize size = CGSizeMake(10, 2);
        [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
