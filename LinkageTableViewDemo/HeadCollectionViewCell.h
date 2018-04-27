//
//  HeadCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/8.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KHeadCollectionViewCellID       @"HeadCollectionViewCell"
#define KHeadCollectionViewCellHeight   55

@interface HeadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
