//
//  BGCollectionViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/4.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "BGCollectionViewCell.h"
#import "UIView+XIBInstance.h"
#import "LMJVerticalFlowLayout.h"
#import "InfoCollectionViewCell.h"
#import "Masonry.h"



static NSInteger hCount = 3;

@interface BGCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,LMJVerticalFlowLayoutDelegate>
{
    InfoCollectionViewCell *cell;
}
@end

@implementation BGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 1;
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        return 119 ;
    }
    return 119 * hCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:KInfoCollectionViewCellID forIndexPath:indexPath];
    BOOL isNow = NO;
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        cell.numLabel.text = [NSString stringWithFormat:@"%ld0%ld",119 - indexPath.row,self.indexPath.row + 1];
        if (self.floorNum == 119 - indexPath.row) {
            isNow = YES;
        }
    }else{
        cell.numLabel.text = [NSString stringWithFormat:@"%ld0%ld",self.floorNum,indexPath.row + 1];
        if (self.roomNum - 1 == indexPath.row) {
            isNow = YES;
        }
    }
//    cell.typeLabel.text = self.scale < 1?nil:@"商品房";
    cell.numLabel.font = [UIFont systemFontOfSize:self.fontScale<1?10:13];
    cell.typeLabel.font = [UIFont systemFontOfSize:self.fontScale<1?8:11];
    cell.infoLabel.text = self.fontScale < 1?nil:@"住宅\n混合结构\n实：50.00";
    if (self.selNow && isNow) {
        [UIView animateWithDuration:1 animations:^{
            cell.backgroundColor = [UIColor redColor];
        }];
        [UIView animateWithDuration:2.5 animations:^{
            cell.backgroundColor = kSetHEXColor(0x0F9B4A);
            self.selNow = NO;
        }];
    }else{
        cell.backgroundColor = kSetHEXColor(0x0F9B4A);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%ld",indexPath.row);
}

- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor && (indexPath.row == 1 || indexPath.row == 12)) {
        return (itemWidth * 2 + 4);
    }
    return itemWidth;
}

- (UIEdgeInsets)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        return UIEdgeInsetsMake(4, 0, 4, 0);
    }
    return UIEdgeInsetsMake(4, 8, 4, 8);
}

- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        return 1;
    }
    return hCount;
}

- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        return 4;
    }
    return 4;
}

- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellType == BGCollectionViewCellTypeAllFloor){
        return 4 ;
    }
    return 4;
}

- (void)setFloorNum:(NSInteger)floorNum
{
    _floorNum = floorNum;
    [self.collectionView reloadData];
}

- (void)setRoomNum:(NSInteger)roomNum
{
    _roomNum = roomNum;
    [self.collectionView reloadData];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self.collectionView reloadData];
}


- (void)setCellType:(BGCollectionViewCellType)cellType
{
    _cellType = cellType;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.flowLayout = (UICollectionViewFlowLayout *)[[LMJVerticalFlowLayout alloc] initWithDelegate:self];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:KInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KInfoCollectionViewCellID];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self.contentView);
        }];
    }
    return _collectionView;
}

@end
