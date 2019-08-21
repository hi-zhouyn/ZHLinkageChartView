//
//  ZHTitleCollectionViewCell.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHTitleCollectionViewCell.h"
#import "Masonry.h"

@interface ZHTitleCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ZHTitleCollectionViewCell

- (void)setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    if (showBorder && !self.contentView.layer.cornerRadius) {
        self.titleLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 2.f;
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 0.5f;
    }
}

- (void)setNameStr:(NSString *)nameStr
{
    _nameStr = nameStr;
    self.titleLabel.text = nameStr;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _titleLabel;
}

@end
