//
//  UIButton+Category.h
//  JDD
//
//  Created by 盒子 on 2018/6/5.
//  Copyright © 2018年 Xmiles. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ButtonImgViewStyleTop,
    ButtonImgViewStyleLeft,
    ButtonImgViewStyleBottom,
    ButtonImgViewStyleRight,
} ButtonImgViewStyle;

@interface UIButton (Category)

/**
 设置button图片风格

 @param style style
 @param size 图片大小
 @param space 间距
 */
-(void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;

@end
