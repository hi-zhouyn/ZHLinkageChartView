//
//  InfoCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/3.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KInfoCollectionViewCellID      @"InfoCollectionViewCell"
#define KInfoCollectionViewCellHeight  90

@interface InfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
