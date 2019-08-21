//
//  TopSelectView.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "TopSelectView.h"
#import "Masonry.h"
#import "ZHTitleCollectionViewCell.h"

@interface TopSelectView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *headCollectionView;
@end

@implementation TopSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self headCollectionView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allKeysArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHTitleCollectionViewCell class]) forIndexPath:indexPath];
    cell.nameStr = [NSString stringWithFormat:@"%@单元",self.allKeysArr[indexPath.section]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(selectAction:)]) {
        [self.zh_delegate selectAction:indexPath];
    }
}

- (UICollectionView *)headCollectionView
{
    if (!_headCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.itemSize = CGSizeMake(50, 50);
        
        _headCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _headCollectionView.showsHorizontalScrollIndicator = NO;
        _headCollectionView.delegate = self;
        _headCollectionView.dataSource = self;
        _headCollectionView.backgroundColor = [UIColor whiteColor];
        [_headCollectionView registerClass:[ZHTitleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHTitleCollectionViewCell class])];
        [self addSubview:_headCollectionView];
        [_headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(50);
        }];
    }
    return _headCollectionView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
