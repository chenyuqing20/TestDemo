//
//  UIButton+Category.m
//  JDD
//
//  Created by 盒子 on 2018/6/5.
//  Copyright © 2018年 Xmiles. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

static const char BUTTON_IMAGE_STYLE;
static const char BUTTON_IMAGE_SIZE;
static const char BUTTON_IMAGE_SPACE;

@implementation UIButton (Category)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换分类的方法 layoutSubviews -> jdd_layoutSubviews
        Method m1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method m2 = class_getInstanceMethod([self class], @selector(jdd_layoutSubviews));
        method_exchangeImplementations(m1, m2);
    });
}
- (void)logAllVars {
    unsigned int outCount = 0;
    Ivar *allVars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i<outCount; i++) {
        Ivar ivar = allVars[i];
        const char * ivarName = ivar_getName(ivar);
        NSLog(@"UIButton内所有属性变量名字 %s",ivarName);
    }
}
- (void)logAllMethods {
    unsigned int outCount = 0;
    Method *allMethods = class_copyMethodList([self class], &outCount);
    for (int i = 0; i<outCount; i++) {
        SEL methodSEL = method_getName(allMethods[i]);
        const char * funtionName = sel_getName(methodSEL);
        NSLog(@"UIButton内所有方法名字 %s",funtionName);
    }
}

- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space {
    // 添加设置分类属性变量
    objc_setAssociatedObject(self, // 是要给哪个对象添加属性变量
                             &BUTTON_IMAGE_STYLE, // 属性变量标记key,取属性值时需要用到
                             @(style), // 属性变量值
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC // 属性变量策略
                             /*
                             一共有 5 个策略
                             OBJC_ASSOCIATION_ASSIGN;            assign策略
                              OBJC_ASSOCIATION_RETAIN            retain策略
                              OBJC_ASSOCIATION_COPY              copy策略
                             OBJC_ASSOCIATION_COPY_NONATOMIC;    copy,nonatomic策略
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC;  retain,nonatomic策略
                             */
                             );
    objc_setAssociatedObject(self, &BUTTON_IMAGE_SPACE, @(space), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &BUTTON_IMAGE_SIZE, NSStringFromCGSize(size), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


/**
 方法与layoutSubviews交换后，重写UI位置
 */
- (void)jdd_layoutSubviews
{
    [self jdd_layoutSubviews];
    
    // 获取上个方法中设置的成员变量 objc_getAssociatedObject(对象,属性变量标记的key)
    NSNumber *typeNum = objc_getAssociatedObject(self, &BUTTON_IMAGE_STYLE);
    
    if (typeNum) {
        NSNumber *spaceNum = objc_getAssociatedObject(self, &BUTTON_IMAGE_SPACE);
        NSString *imgSizeStr = objc_getAssociatedObject(self, &BUTTON_IMAGE_SIZE);
        CGSize imgSize = self.currentImage ? CGSizeFromString(imgSizeStr) : CGSizeZero;
        CGSize labelSize = self.currentTitle.length ? [self.currentTitle sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}] : CGSizeZero;
        
        CGFloat space = (labelSize.width && self.currentImage) ? spaceNum.floatValue : 0;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGFloat imgX = 0.0, imgY = 0.0, labelX = 0.0 , labelY = 0.0;
        
        switch (typeNum.integerValue) {
            case ButtonImgViewStyleLeft:
            {
                imgX = (width - imgSize.width - labelSize.width - space)/2.0;
                imgY = (height - imgSize.height)/2.0;
                labelX = imgX + imgSize.width + space;
                labelY = (height - labelSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeRight;
                break;
            }
            case ButtonImgViewStyleTop:
            {
                imgX = (width - imgSize.width)/2.0;
                imgY = (height - imgSize.height - space - labelSize.height)/2.0;
                labelX = (width - labelSize.width)/2;
                labelY = imgY + imgSize.height + space;
                self.imageView.contentMode = UIViewContentModeBottom;
                break;
            }
            case ButtonImgViewStyleRight:
            {
                labelX = (width - imgSize.width - labelSize.width - space)/2.0;
                labelY = (height - labelSize.height)/2.0;
                imgX = labelX + labelSize.width + space;
                imgY = (height - imgSize.height)/2.0;
                self.imageView.contentMode = UIViewContentModeLeft;
                break;
            }
            case ButtonImgViewStyleBottom:
            {
                labelX = (width - labelSize.width)/2.0;
                labelY = (height - labelSize.height - imgSize.height -space)/2.0;
                imgX = (width - imgSize.width)/2.0;
                imgY = labelY + labelSize.height + space;
                self.imageView.contentMode = UIViewContentModeTop || UIViewContentModeScaleAspectFit;
                break;
            }
            default:
                break;
        }
        self.imageView.frame = CGRectMake(imgX, imgY, imgSize.width, imgSize.height);
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    }
}
@end
