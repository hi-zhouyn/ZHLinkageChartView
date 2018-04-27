//
//  FloorTableViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/8.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KFloorTableViewCellID   @"FloorTableViewCell"

@interface FloorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat scale;//缩放比例
@end
