//
//  BaseTextView.h
//  test
//
//  Created by 盒子 on 2018/8/10.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BaseTextViewDidChange)(NSString *allText,NSString *newText);

@interface BaseTextView : UITextView

- (BaseTextView *(^)(NSString *))placeholder;

- (BaseTextView *(^)(UIColor *))placeholderColor;

- (BaseTextView *(^)(UIFont *))placeholderFont;

- (BaseTextView *(^)(BOOL))needShowTextNumber;

- (BaseTextView *(^)(NSInteger))maxTextCount;

- (BaseTextView *(^)(UIColor *))maxTextColor;

- (BaseTextView *(^)(NSInteger))currentTextCount;

- (BaseTextView *(^)(UIColor *))currentTextColor;

- (BaseTextView *(^)(UIFont *))tipTextFont;


@property (nonatomic, copy) BaseTextViewDidChange baseTextViewDidChange;  // 文字改变
@end
