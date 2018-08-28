//
//  QSTextView.h
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSTextViewDefine.h"

@interface QSTextView : UITextView

#pragma mark - 占位placeholder相关的属性
/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 占位文字字体
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;


@end
