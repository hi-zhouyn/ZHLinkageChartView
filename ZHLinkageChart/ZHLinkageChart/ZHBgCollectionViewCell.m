//
//  ZHBgCollectionViewCell.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHBgCollectionViewCell.h"
#import "Masonry.h"
#import "ZHItemCollectionViewCell.h"
#import "ZHItemModel.h"

@interface ZHBgCollectionViewCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>

@end

@implementation ZHBgCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self collectionView];
    }
    return self;
}

- (void)setItemArr:(NSArray *)itemArr
{
    _itemArr = itemArr;
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.zh_itemDelegate && [self.zh_itemDelegate respondsToSelector:@selector(itemCollectionViewDidScroll:)]) {
        [self.zh_itemDelegate itemCollectionViewDidScroll:scrollView];
    }
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHItemCollectionViewCell class]) forIndexPath:indexPath];
    if (self.itemArr.count > indexPath.row) {
        ZHItemModel *infoModel = self.itemArr[indexPath.row];
        [cell updateDataWithTitle:infoModel.houseName info:infoModel.layoutName tag:1];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(self.indexPath, indexPath.row);
    }
    if (self.zh_itemDelegate && [self.zh_itemDelegate respondsToSelector:@selector(itemDidSelectIndexPath:index:)]) {
        [self.zh_itemDelegate itemDidSelectIndexPath:self.indexPath index:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArr.count > indexPath.row) {
        //处理表格合并
        ZHItemModel *infoModel = self.itemArr[indexPath.row];
        NSInteger difference = infoModel.highNominalLayer - infoModel.lowerNominalLayer + 1;
        CGFloat height = KITEMHEIGHT * difference + KSPACE * (difference - 1);
        return CGSizeMake(KITEMWIDTH, height);
    }
    return CGSizeMake(KITEMWIDTH, KITEMHEIGHT);
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = KSPACE;
        flowLayout.minimumInteritemSpacing = KSPACE;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, KSPACE, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZHItemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHItemCollectionViewCell class])];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _collectionView;
}


@end
