//
//  ZHItemCollectionViewCell.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHItemCollectionViewCell.h"
#import "Masonry.h"

@interface ZHItemCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@end

@implementation ZHItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 2.f;
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3f];
    }
    return self;
}

- (void)updateDataWithTitle:(nullable NSString *)title info:(nullable NSString *)info tag:(NSInteger)tag
{
    self.titleLabel.text = title;
    self.infoLabel.text = info;
    self.placeholderImageView.hidden = title.length;
    if (tag) {
        self.contentView.backgroundColor = title.length ? [[UIColor greenColor] colorWithAlphaComponent:0.3f] : [UIColor whiteColor];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-7);
        }];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = [UIColor darkTextColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        }];
    }
    return _infoLabel;
}

- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nullplaceholder"]];
//        _placeholderImageView.backgroundColor = [UIColor whiteColor];
        _placeholderImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_placeholderImageView];
        [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _placeholderImageView;
}

@end
