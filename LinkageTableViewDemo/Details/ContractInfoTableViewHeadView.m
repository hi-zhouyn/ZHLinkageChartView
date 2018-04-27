//
//  ContractInfoTableViewHeadView.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "ContractInfoTableViewHeadView.h"
#import "Common.h"

@implementation ContractInfoTableViewHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self.contentView setborderWithBorderColor:[UIColor whiteColor] Width:0.5];
        self.isOpen = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTapAction)];
        [self.contentView addGestureRecognizer:tap];
        [self foldImageView];
    }
    return self;
}

- (UIImageView *)foldImageView
{
    if (!_foldImageView) {
        _foldImageView = [[UIImageView alloc] init];
        _foldImageView.image = [UIImage imageNamed:@"fold"];
        [self.contentView addSubview:_foldImageView];
        [_foldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(16);
        }];
    }
    return _foldImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.foldImageView.mas_right).offset(6);
//            make.right.equalTo(self.contentView).offset(-8);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

- (void)headViewTapAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewTapAction:)]) {
        [self.delegate headViewTapAction:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
