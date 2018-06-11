//
//  JDDAlertView.h
//  test
//
//  Created by 盒子 on 2018/6/1.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertHandelBlock)(NSInteger index,id data);

@interface JDDAlertView: UIView

- (JDDAlertView *(^)(UIColor *)) leftBtnBgColor;

- (JDDAlertView *(^)(UIColor *)) rightBtnBgColor;

- (JDDAlertView *(^)(UIColor *)) leftBtnTextColor;

- (JDDAlertView *(^)(UIColor *)) rightBtnTextColor;

- (JDDAlertView *(^)(float )) titleFontSize;

- (JDDAlertView *(^)(float )) messageFontSize;

- (JDDAlertView *(^)(float )) leftBtnFontSize;

- (JDDAlertView *(^)(float )) rightBtnFontSize;

- (JDDAlertView *(^)(NSString *)) leftBtnText;

- (JDDAlertView *(^)(NSString *)) rightBtnText;

@property (nonatomic,copy) AlertHandelBlock alertHandelBlock;

- (instancetype)initJDDAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)show;

- (void)hide;

@end
