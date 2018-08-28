//
//  JDDBannerView.m
//  test
//
//  Created by 盒子 on 2018/6/6.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "JDDBannerView.h"
#import "JDDBannerViewCell.h"
#import "JDDPageControl.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define MaxSection 100

@interface JDDBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) JDDPageControl *pageControl;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation JDDBannerView
- (instancetype)init{
    if (self == [super init]) {
        [self setupSubviews];
        [self setLayout];
        
    }
    return self;
}
- (void)setNomalDotColor:(UIColor *)nomalDotColor {
    _nomalDotColor = nomalDotColor;
    _pageControl.pageIndicatorTintColor = self.nomalDotColor;
}
- (void)setSelectDotColor:(UIColor *)selectDotColor {
    _selectDotColor = selectDotColor;
    _pageControl.currentPageIndicatorTintColor = _selectDotColor;;
}
- (void)setImageList:(NSArray *)imageList{
    _imageList = imageList;
    _pageControl.numberOfPages = _imageList.count;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSection/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}
- (void)setupSubviews{

    _currentSelectIndex = _nomalSelectIndex + 1;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[JDDBannerViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    _pageControl = [[JDDPageControl alloc] init];
    _pageControl.numberOfPages = self.imageList.count;
    _pageControl.currentPageIndicatorTintColor = self.selectDotColor;
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];

}

- (void)setLayout {
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(16);
    }];
}
- (void)setAutomaticTime:(NSInteger)automaticTime {
    _automaticTime = automaticTime;
    if (_isAutomaticScroll && _automaticTime > 0) {
        [self startAutomaticScroll];
    }
}
- (void)setIsAutomaticScroll:(BOOL)isAutomaticScroll {
    _isAutomaticScroll = isAutomaticScroll;
    
}
#pragma mark - AutomaticScroll
/**
 开始自动滚动
 */
- (void)startAutomaticScroll {
    [self endAutomaticScroll];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_automaticTime target:self selector:@selector(automaticMove) userInfo:nil repeats:YES];
}
- (void)endAutomaticScroll {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)automaticMove {
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSection/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.imageList.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
   
}
#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSection;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageList.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"cell";
    JDDBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:_imageList[indexPath.row]] placeholderImage:_defaultImage];
    return cell;
}

#pragma mark - UIScrollView Delegate
#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endAutomaticScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startAutomaticScroll];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index =  (int)(offset / [UIScreen mainScreen].bounds.size.width) % self.imageList.count;
    if (index >= self.imageList.count ) {
        index = 0;
    }
    _pageControl.currentPage =  index;
    _currentSelectIndex = index;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
