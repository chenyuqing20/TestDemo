//
//  BaseTextView.m
//  test
//
//  Created by 盒子 on 2018/8/10.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "BaseTextView.h"

@interface BaseTextView ()
@property (nonatomic, strong) UILabel *placeholderView;  // 提示文字label
@property (nonatomic, strong) UILabel *tipView;  // 字数提示label
@property (nonatomic, strong) NSString *oldText;  // 改变之前的文字内容

@property (nonatomic, assign) BOOL isShowTextNumber;  // 是否显示字数label
@property (nonatomic, assign) NSInteger maxValueCount;  // 最大字数
@property (nonatomic, assign) NSInteger currentValueCount;  // 当前字数
@property (nonatomic, strong) UIColor *maxValueColor;  // 最大字数颜色
@property (nonatomic, strong) UIColor *currentValueColor;  // 当前字数颜色

@end

CGFloat const ContainerInsetSpace = 12;  // 四周间隔
NSInteger const NomalMaxValueCount = 100; // 默认最大字数 100

@implementation BaseTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.scrollEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        
        [self setTextContainerInset:UIEdgeInsetsMake(ContainerInsetSpace,ContainerInsetSpace,20,ContainerInsetSpace)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        _currentValueCount = 0;
        _maxValueCount = NomalMaxValueCount;
        _currentValueColor = [UIColor lightGrayColor];
        _maxValueColor = [UIColor lightGrayColor];
        NSString *tipStr = [NSString stringWithFormat:@"%ld/%ld",(long)_currentValueCount,(long)_maxValueCount];
        self.tipView.text = tipStr;
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UILabel *)placeholderView {
    if (!_placeholderView) {
        NSLog(@"bounds = %@",NSStringFromCGRect(self.bounds));
        _placeholderView = [[UILabel alloc] initWithFrame:CGRectMake(ContainerInsetSpace+3, ContainerInsetSpace-1, self.bounds.size.width - ContainerInsetSpace*2, 16)];
        _placeholderView.textColor = self.textColor;
        _placeholderView.font = self.font;
        _placeholderView.backgroundColor = [UIColor clearColor];
        _placeholderView.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}
- (UILabel *)tipView {
    if (!_tipView) {
        _tipView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width-ContainerInsetSpace, 14)];
        _tipView.textAlignment = NSTextAlignmentRight;
        _tipView.textColor = [UIColor lightGrayColor];
        _tipView.font = self.font;
        _tipView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tipView];
    }
    return _tipView;
}
#pragma mark - getter and setter
- (BaseTextView *(^)(NSString *))placeholder {
    return ^BaseTextView *(NSString *pla) {
        self.placeholderView.text = pla;
        return self;
    };
}
- (BaseTextView *(^)(UIColor *))placeholderColor {
    return ^BaseTextView *(UIColor *plaColor) {
        self.placeholderView.textColor = plaColor;
        return self;
    };
}
- (BaseTextView *(^)(UIFont *))placeholderFont {
    return ^BaseTextView *(UIFont *plaFont) {
        self.placeholderView.font = plaFont;
        return self;
    };
}
- (BaseTextView *(^)(BOOL))needShowTextNumber {
    return ^BaseTextView *(BOOL isShow) {
        self.isShowTextNumber = isShow;
        return self;
    };
}
- (BaseTextView *(^)(NSInteger))maxTextCount {
    return ^BaseTextView *(NSInteger maxCount) {
        self.maxValueCount = maxCount;
        [self updateTipText];
        return self;
    };
}
- (BaseTextView *(^)(UIColor *))maxTextColor {
    return ^BaseTextView *(UIColor *maxColor) {
        self.maxValueColor = maxColor;
        [self updateTipText];
        return self;
    };
}
- (BaseTextView *(^)(NSInteger))currentTextCount {
    return ^BaseTextView *(NSInteger curCount) {
        self.currentValueCount = curCount;
        [self updateTipText];
        return self;
    };
}

- (BaseTextView *(^)(UIColor *))currentTextColor{
    return ^BaseTextView *(UIColor *curColor) {
        self.currentValueColor = curColor;
        [self updateTipText];
        return self;
    };
}

- (BaseTextView *(^)(UIFont *))tipTextFont {
    return ^BaseTextView *(UIFont *tipFont) {
        self.tipView.font = tipFont;
        return self;
    };
}

- (void)updateTipText {
    [self.tipView setHidden:!_isShowTextNumber];
    if (_isShowTextNumber) {
        NSInteger currentLength = [[NSString stringWithFormat:@"%ld",(long)_currentValueCount] length];
        NSInteger maxLength = [[NSString stringWithFormat:@"%ld",(long)_maxValueCount] length];
        NSRange currentRange = NSMakeRange(0, currentLength);
        NSRange maxRange = NSMakeRange(currentLength+1, maxLength);
        NSString *tipStr = [NSString stringWithFormat:@"%ld/%ld",(long)_currentValueCount,(long)_maxValueCount];
        _tipView.text = tipStr;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:_currentValueColor range:currentRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:_maxValueColor range:maxRange];
        self.tipView.attributedText = attrStr;
    }
    
}
#pragma mark - Delegate
- (void)textDidChange:(NSNotification *)noti {
    UITextView *textView = (UITextView *)noti.object;
    NSString *toBeString = textView.text;
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= self.maxValueCount) {
                textView.text = [toBeString substringToIndex:self.maxValueCount];
            }
            [self.placeholderView setHidden:textView.text.length];
            _currentValueCount = textView.text.length;
            if (self.baseTextViewDidChange) {
                if (self.text.length >= self.oldText.length) {
                    self.baseTextViewDidChange(self.text,[self.text substringFromIndex:self.oldText.length]);
                }else {
                    self.baseTextViewDidChange(self.text,@"");
                }
            }
            _oldText = self.text;
        } else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
            [self.placeholderView setHidden:YES];
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= self.maxValueCount) {
            textView.text = [toBeString substringToIndex:self.maxValueCount];
        }
        [self.placeholderView setHidden:textView.text.length];
        _currentValueCount = textView.text.length;
        if (self.baseTextViewDidChange) {
            if (self.text.length >= self.oldText.length) {
                self.baseTextViewDidChange(self.text,[self.text substringFromIndex:self.oldText.length]);
            }else {
                self.baseTextViewDidChange(self.text,@"");
            }
        }
        _oldText = self.text;
    }
    
    [self updateTipText];
    
}

@end
