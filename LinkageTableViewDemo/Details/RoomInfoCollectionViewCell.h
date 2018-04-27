//
//  RoomInfoCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KRoomInfoCollectionViewCellID      @"RoomInfoCollectionViewCell"
#define KRoomInfoCollectionViewCellHeight  35

@interface RoomInfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
