//
//  FloorTableViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/8.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "FloorTableViewCell.h"
#import "InfoCollectionViewCell.h"
#import "Masonry.h"

@interface FloorTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation FloorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 111;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KInfoCollectionViewCellID forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%ld",indexPath.row);
}



- (void)setScale:(CGFloat)scale
{
    _scale = scale;
//    [self.collectionView layoutIfNeeded];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(KInfoCollectionViewCellHeight, KInfoCollectionViewCellHeight);
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:KInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KInfoCollectionViewCellID];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right);
        }];
    }
    return _collectionView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
