//
//  HistoryCollectionViewCell.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "HistoryCollectionViewCell.h"
#import "AppDelegate.h"
#import "InfoModel.h"

@interface HistoryCollectionViewCell ()
@property (nonatomic, strong) NSMutableArray *contentArr;
@end

@implementation HistoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.userInteractionEnabled = YES;
    self.contentLabel.userInteractionEnabled = NO;
    [self.contentView setborderWithBorderColor:KLineGreenColor Width:0.3];
}



- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.section]:nil;
    InfoModel *model = [[InfoModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    self.contentLabel.text = [self getDataArrWithModel:model][indexPath.row];
    self.setImageView.hidden = YES;
    if (!indexPath.section) {
        self.setImageView.hidden = YES;
        self.backgroundColor = KDarkGreenColor;
    }else{
        self.backgroundColor = KLightGreenColor;
        if (self.cellType == HistoryCollectionViewCellTypeHistory) {
            self.setImageView.hidden = indexPath.row;
        }
    }
}

- (NSMutableArray *)getDataArrWithModel:(InfoModel *)model
{
    switch (self.cellType) {
        case HistoryCollectionViewCellTypeHistory:
            return [NSMutableArray arrayWithObjects:model.set,model.state,model.date,model.mode,model.num,model.filenum,model.name,model.remark, nil];
            break;
        case HistoryCollectionViewCellTypeRoom:
            return [NSMutableArray arrayWithObjects:model.use,model.structure,model.structurearea,model.truearea,model.sharearea, nil];
            break;
        case HistoryCollectionViewCellTypeMoney:
            return [NSMutableArray arrayWithObjects:model.num,model.bank,model.account,model.much,model.idnum,model.date,model.refund, nil];
            break;
        case HistoryCollectionViewCellTypeDocument:
            return [NSMutableArray arrayWithObjects:model.name,model.type,model.pagenum,model.much,model.fontnum, nil];
            break;
        case HistoryCollectionViewCellTypeChanged:
            return [NSMutableArray arrayWithObjects:model.num,model.date,model.beforechange,model.changed, nil];
            break;
        default:
            return nil;
            break;
    }
}

@end
