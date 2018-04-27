//
//  BGTableViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "BGTableViewCell.h"

@interface BGTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation BGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self collectionView];
    [self.collectionView layoutIfNeeded];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.showType == ContractInfoShowTypeVertical) {
       return self.dataArr.count;
    }
    return [[[self.dataArr firstObject] allKeys] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType == ContractInfoShowTypeVertical){
        RoomInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KRoomInfoCollectionViewCellID forIndexPath:indexPath];
        NSDictionary *dict = self.dataArr[indexPath.row];
        cell.titleLabel.text = dict[@"title"];
        cell.contentLabel.text = dict[@"data"];
        return cell;
    }else{
        HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KHistoryCollectionViewCellID forIndexPath:indexPath];
        cell.cellType = self.infotypeNum.integerValue;
        cell.dataArr = self.dataArr;
        cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.indexRow];
        return cell;
    }
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
//        flowLayout.itemSize = CGSizeMake(KHistoryCollectionViewCellWidth, KHistoryCollectionViewCellHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (self.showType == ContractInfoShowTypeVertical) {
            flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH/2, KRoomInfoCollectionViewCellHeight);
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }else{
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(KHistoryCollectionViewCellWidth, KHistoryCollectionViewCellHeight);
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = KBGGreenColor;
        [_collectionView registerNib:[UINib nibWithNibName:KHistoryCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KHistoryCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:KRoomInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KRoomInfoCollectionViewCellID];
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
