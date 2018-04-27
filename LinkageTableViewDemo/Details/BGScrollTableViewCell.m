//
//  BGScrollTableViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/25.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "BGScrollTableViewCell.h"


@interface BGScrollTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation BGScrollTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self collectionView];
//        [self.collectionView layoutIfNeeded];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoBGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KContractInfoBGCollectionViewCellID forIndexPath:indexPath];
    cell.cellType = self.infotypeNum.integerValue;
    cell.dataArr = self.dataArr;
    cell.indexPath = indexPath;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"daunj");
}


- (void)setIndexRow:(NSInteger)indexRow
{
    _indexRow = indexRow;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        NSInteger count = [[[self.dataArr firstObject] allKeys] count];
        flowLayout.itemSize = CGSizeMake(KContractInfoBGCollectionViewCellWidth * count, KContractInfoBGCollectionViewCellHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ContractInfoBGCollectionViewCell class] forCellWithReuseIdentifier:KContractInfoBGCollectionViewCellID];
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _collectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
