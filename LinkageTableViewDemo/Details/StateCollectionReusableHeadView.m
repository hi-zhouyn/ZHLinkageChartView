//
//  StateCollectionReusableHeadView.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "StateCollectionReusableHeadView.h"
#import "UIView+XIBInstance.h"

@implementation StateCollectionReusableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.circleView setCircleWithRadius:self.circleView.frame.size.width/2];
}

@end
