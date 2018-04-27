//
//  LinkageTableViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/2.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KLinkageTableViewCellID       @"LinkageTableViewCell"
#define KLinkageTableViewCellHeight   70
#define KLinkageTableViewCellWidth    100

@interface LinkageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *physicalFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nominalFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *physicalFloor1Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *physicalFloor1LabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *physicalFloorLabelBottomConstraint;

@end
