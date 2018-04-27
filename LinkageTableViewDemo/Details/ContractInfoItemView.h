//
//  ContractInfoView.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/26.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractInfoItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *setImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
