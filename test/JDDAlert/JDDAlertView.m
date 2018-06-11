//
//  JDDAlertView.m
//  test
//
//  Created by 盒子 on 2018/6/1.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "JDDAlertView.h"
#import "AlertButtonModel.h"
#import  "Masonry.h"

#define JDD_HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BUTTON_HEIGHT 44

@interface JDDAlertView(){
    
}
@property (nonatomic) UIViewController *topController;
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,assign) float messageHeight;
@property (nonatomic,strong) UIView *lineView;

@end
@implementation JDDAlertView

- (instancetype)initJDDAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    if (self == [super init]) {
        [self setupSubviews:title andMsg:message];
        [self setLayout];
    }
    return self;
}

- (void)setupSubviews:(NSString *)title andMsg:(NSString *)message {
    
    _alertView = [UIView new];
    _alertView.layer.cornerRadius = 8;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
//    _titleLabel.backgroundColor = [UIColor greenColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = title?title:@"温馨提示";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:_titleLabel];

    _messageLabel = [UILabel new];
    _messageLabel.textColor = [UIColor blackColor];
//    _messageLabel.backgroundColor = [UIColor yellowColor];
    _messageLabel.text = message?message:@"";
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:_messageLabel];

    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_alertView addSubview:_lineView];
    
    CGFloat buttonWidth = _alertView.frame.size.width / 2;
    CGFloat buttonHeight = BUTTON_HEIGHT;
    for (int i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 200, buttonWidth, buttonHeight)];
        NSString *text = i==0?@"取消":@"确定";
        button.tag = i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:text forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [_alertView addSubview:button];
    }
}

- (void)setLayout{
    
    CGFloat padding = 30;
    
    CGFloat messageLabelWidth = [UIScreen mainScreen].bounds.size.width/2 - padding;
    
    self.messageHeight = [self heightByFont:self.messageLabel.font andWidth:messageLabelWidth andText:self.messageLabel.text];
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(padding);
        make.right.equalTo(self).offset(-padding);
        make.height.mas_greaterThanOrEqualTo(120);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView);
        make.right.equalTo(self.alertView);
        make.top.equalTo(self.alertView);
        make.height.mas_equalTo(60);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alertView.mas_left).offset(20);
        make.right.mas_equalTo(self.alertView.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    if (self.messageHeight > 60) {
        [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.messageHeight);
        }];
    }
    [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120 + self.messageHeight);
    }];
    
     [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView);
        make.right.equalTo(self.alertView);
        make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(-44);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width-padding*2)/2;
    
    for (int i=0;i<self.buttons.count;i++) {
        UIButton *button = self.buttons[i];
        NSLog(@"button left = %f",i*buttonWidth);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.alertView.mas_left).offset(i*buttonWidth);
            make.width.mas_equalTo(buttonWidth);
            make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(0);
            make.height.mas_equalTo(44);
        }];
    }
}

/**
 显示弹窗
 */
- (void)show {
    [[UIApplication sharedApplication].windows.firstObject addSubview:self];
//    NSLog(@"First Object = %@",[UIApplication sharedApplication].windows.firstObject);
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].windows.firstObject);
    }];
    [_alertView setAlpha:0];
    [[UIApplication sharedApplication].windows.firstObject bringSubviewToFront:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self needsUpdateConstraints];
        [self alertAnimation];
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.alpha = 1;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    });
}


/**
 弹窗动画
 */
- (void)alertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray new];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.96, 0.96, 0.96)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
}

/**
 隐藏动画
 */
- (void)hideAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray new];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}
- (JDDAlertView *(^)(UIColor *)) leftBtnBgColor{
    
    return ^JDDAlertView *(UIColor *color) {
        if (self.buttons.count) {
            [(UIButton *)self.buttons[0] setBackgroundColor:color];
        }
        return self;
    };
    
}

- (JDDAlertView *(^)(UIColor *)) rightBtnBgColor{
    return ^JDDAlertView *(UIColor *color){
        if (self.buttons.count) {
            [(UIButton *)self.buttons[1] setBackgroundColor:color];
        }
        return self;
    };
}

- (JDDAlertView *(^)(UIColor *)) leftBtnTextColor{
    return ^JDDAlertView *(UIColor *color){
        if (self.buttons.count) {
            NSLog(@"设置颜色 %@",self.buttons[0]);
            [(UIButton *)self.buttons[0] setTitleColor:color forState:UIControlStateNormal];
        }
        return self;
    };
}

- (JDDAlertView *(^)(UIColor *)) rightBtnTextColor{
    return ^JDDAlertView *(UIColor *color){
        if (self.buttons.count) {
            [(UIButton *)self.buttons[1] setTitleColor:color forState:UIControlStateNormal];
        }
        return self;
    };
}

- (JDDAlertView *(^)(NSString *)) leftBtnText{
    return ^JDDAlertView *(NSString *leftText){
        if (self.buttons.count) {
            [(UIButton *)self.buttons[0] setTitle:leftText forState:UIControlStateNormal];
        }
        return self;
    };
}

- (JDDAlertView *(^)(NSString *)) rightBtnText{
    return ^JDDAlertView *(NSString *rightText){
        if (self.buttons.count) {
            [(UIButton *)self.buttons[1] setTitle:rightText forState:UIControlStateNormal];
        }
        return self;
    };
}

- (JDDAlertView *(^)(float )) titleFontSize{
    return ^JDDAlertView *(float size) {
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        return self;
    };
}

- (JDDAlertView *(^)(float )) messageFontSize{
    return ^JDDAlertView *(float size) {
        self.messageLabel.font = [UIFont systemFontOfSize:size];
        return self;
    };
}

- (JDDAlertView *(^)(float )) leftBtnFontSize{
    return ^JDDAlertView *(float size){
        if (self.buttons.count) {
            [[(UIButton *)self.buttons[0] titleLabel] setFont:[UIFont systemFontOfSize:size]];
        }
        return self;
    };
}

- (JDDAlertView *(^)(float )) rightBtnFontSize{
    return ^JDDAlertView *(float size){
        if (self.buttons.count) {
            [[(UIButton *)self.buttons[1] titleLabel] setFont:[UIFont systemFontOfSize:size]];
        }
        return self;
    };
}

- (CGFloat)heightByFont:(UIFont*)font andWidth:(CGFloat)width andText:(NSString *)text{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.height);
}

/**
 弹窗点击事件

 @param sender 点击按钮
 */
- (void)alertButtonClick:(UIButton *)sender{
    if (self.alertHandelBlock) {
        self.alertHandelBlock(sender.tag,sender);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }
}

/**
 弹窗隐藏
 */
- (void)hide {
    [self hideAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
