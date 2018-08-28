//
//  JDDBannerViewCell.m
//  test
//
//  Created by 盒子 on 2018/6/6.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "JDDBannerViewCell.h"
#import "Masonry.h"

@implementation JDDBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setLayout];
    }
    return self;
}

- (void)setupSubviews {
    _imgView = [UIImageView new];
    [_imgView setContentMode:UIViewContentModeScaleToFill];
    [self.contentView addSubview:_imgView];
    
    _label = [UILabel new];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    
}
- (void)setLayout {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
@end
