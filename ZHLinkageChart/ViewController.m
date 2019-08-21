//
//  ViewController.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "ZHLinkageChartView.h"
#import "TopSelectView.h"
#import "LinqToObjectiveC.h"
#import "Masonry.h"
#import "ZHItemModel.h"

@interface ViewController ()<TopSelectViewDelegate,ZHLinkageChartViewDelegate>
@property (nonatomic, strong) TopSelectView *topView;
@property (nonatomic, strong) ZHLinkageChartView *chartView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ZHLinkageChart";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self getQueryWithLayersCount:40 topLayers:35];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)selectAction:(NSIndexPath *)indexPath
{
    [self.chartView speedSelectIndexPath:indexPath];
}

//点击事件回调
- (void)linkageChartViewDidSelect:(ZHLinkageChartView *)chartView type:(ZHLinkageChartViewSelectType)type indexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    NSLog(@"type:%ld,section:%ld,row:%ld,index:%ld",type,indexPath.section,indexPath.row,index);
}

/** 处理数据并进行传值 */
- (void)getQueryWithLayersCount:(NSInteger)layersCount topLayers:(NSInteger)topLayers
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"layer" ofType:@"geojson"];
    NSString *layerJson = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *jsonArr = [ZHItemModel mj_objectArrayWithKeyValuesArray:layerJson];
    
    ZHItemModel *layerModel = [[ZHItemModel alloc] init];
    //总楼层
    layerModel.layersCount = layersCount;
    layerModel.topLayers = topLayers;
    
    //key :按照unitNum属性 升序排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unitNum" ascending:YES];
    //unitNum 相同 按照uIndex属性 升序排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"uIndex" ascending:YES];
    //uIndex 相同 按照onNominalLayer属性 降序排序
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"onNominalLayer" ascending:NO];
    //给数组添加排序规则
    [jsonArr sortUsingDescriptors:@[sort,sort1,sort2]];
    //    NSLog(@"dataArr:%@",[AppHouseInfoModel mj_keyValuesArrayWithObjectArray:dataArr]);
    
    NSDictionary *dict = [jsonArr linq_groupBy:^id(id item) {
        ZHItemModel *model = (ZHItemModel *)item;
        return [NSString stringWithFormat:@"%ld",model.unitNum];
    }];
    
    //key排序
    NSMutableArray *unitKeysArr = [NSMutableArray array];
    for (NSString *key in dict.allKeys) {
        [unitKeysArr addObject:[NSNumber numberWithInteger:key.integerValue]];
    }
    NSArray *allUnitKeys = [unitKeysArr linq_sort];
    for (NSNumber *unitKey in allUnitKeys) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSDictionary *unitDict = [[dict objectForKey:unitKey.stringValue] linq_groupBy:^id(id item) {
            ZHItemModel *tempModel = (ZHItemModel *)item;
            return [NSString stringWithFormat:@"%ld",tempModel.uIndex];
        }];
        //key排序
        NSMutableArray *indexKeysArr = [NSMutableArray array];
        for (NSString *key in unitDict.allKeys) {
            [indexKeysArr addObject:[NSNumber numberWithInteger:key.integerValue]];
        }
        NSArray *allIndexKeys = [indexKeysArr linq_sort];
        for (NSNumber *indexKey in allIndexKeys) {
            NSMutableArray *allLayerArr = [NSMutableArray array];
            NSMutableArray *layerArr = [unitDict objectForKey:indexKey.stringValue];
            for (int i = 0; i < layersCount; i ++) {
                ZHItemModel *placeholderModel = [[ZHItemModel alloc] init];
                NSInteger layer = topLayers - i;
                if (layer <= 0 && topLayers > 0) {
                    layer = layer - 1;
                }
                placeholderModel.physicLayers = layer;
                for (ZHItemModel *layerModel in layerArr) {
                    //符合判断条件赋值，不再展示空值
                    if (layerModel.lowerNominalLayer <= layer
                        && layer <= layerModel.highNominalLayer) {
                        placeholderModel = layerModel;
                        break;
                    }
                }
                [allLayerArr addObject:placeholderModel];
            }
            //去重保存 避免因为楼层合并出现重复值多的问题
            NSArray *distinctLayers = [allLayerArr linq_distinct];
            if (distinctLayers.count) {
                [tempArr addObject:distinctLayers];
            }
        }
        [dataArr addObject:tempArr];
    }
    //    NSLog(@"modelArr:%@",self.houseArr);
    //传入数据
    self.topView.allKeysArr = allUnitKeys;
    self.chartView.itemModel = layerModel;
    self.chartView.allKeysArr = allUnitKeys;
    self.chartView.dataArr = dataArr;
}

- (TopSelectView *)topView
{
    if (!_topView) {
        _topView = [[TopSelectView alloc] initWithFrame:CGRectZero];
        _topView.zh_delegate = self;
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(KTopSelectViewHeight);
        }];
    }
    return _topView;
}

- (ZHLinkageChartView *)chartView
{
    if (!_chartView) {
        _chartView = [[ZHLinkageChartView alloc] initWithFrame:CGRectZero];
        _chartView.zh_delegate = self;
        [self.view addSubview:_chartView];
        [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _chartView;
}

@end
