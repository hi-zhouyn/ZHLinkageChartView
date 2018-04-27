//
//  ContractInfoBGCollectionViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/26.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "ContractInfoBGCollectionViewCell.h"

@interface ContractInfoBGCollectionViewCell ()
//@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ContractInfoBGCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    [self createShowViewWithIndexPath:indexPath];
}

- (void)createShowViewWithIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *view in self.contentView.subviews) {
//        if ([view isKindOfClass:[ContractInfoItemView class]]) {
            [view removeFromSuperview];
//        }
    }
    
    NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.row]:nil;
    InfoModel *model = [[InfoModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    NSMutableArray *arr = [self getDataArrWithModel:model];
    NSInteger i = indexPath.row;

    for (int j = 0; j < [[dict allKeys] count]; j ++) {
        ContractInfoItemView *infoView = [ContractInfoItemView instanceView];
        infoView.nameLabel.text = arr[j];
        if (!i) {
            infoView.backgroundColor = KDarkGreenColor;
            infoView.setImageView.hidden = YES;
        }else{
            infoView.backgroundColor = KLightGreenColor;
            if (!j && self.cellType == ContractInfoTypeHistory) {
                infoView.setImageView.hidden = NO;
            }else{
                infoView.setImageView.hidden = YES;
            }
        }
        [infoView setborderWithBorderColor:KLineGreenColor Width:0.3];
        [self.contentView addSubview:infoView];
        [self.viewArr addObject:infoView];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(KContractInfoBGCollectionViewCellWidth);
            make.left.mas_equalTo(KContractInfoBGCollectionViewCellWidth * j);
        }];
    }
}

- (NSMutableArray *)getDataArrWithModel:(InfoModel *)model
{
    switch (self.cellType) {
        case ContractInfoTypeHistory:
            return [NSMutableArray arrayWithObjects:model.set,model.state,model.date,model.mode,model.num,model.filenum,model.name,model.remark, nil];
            break;
        case ContractInfoTypeRoom:
            return [NSMutableArray arrayWithObjects:model.use,model.structure,model.structurearea,model.truearea,model.sharearea, nil];
            break;
        case ContractInfoTypeMoney:
            return [NSMutableArray arrayWithObjects:model.num,model.bank,model.account,model.much,model.idnum,model.date,model.refund, nil];
            break;
        case ContractInfoTypeDocument:
            return [NSMutableArray arrayWithObjects:model.name,model.type,model.pagenum,model.much,model.fontnum, nil];
            break;
        default:
            return nil;
            break;
    }
}

- (NSMutableArray *)viewArr
{
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}


@end
