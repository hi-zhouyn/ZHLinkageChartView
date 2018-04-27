//
//  RoomDetailsViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/20.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "RoomDetailsViewController.h"
#import "SGPagingView.h"
#import "ContractHeadView.h"
#import "UIView+XIBInstance.h"
#import "Masonry.h"
#import "RoomInfoViewController.h"
#import "StateViewController.h"
#import "HistoryViewController.h"
#import "ChangedViewController.h"
#import "AppDelegate.h"

@interface RoomDetailsViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>
@property (nonatomic, strong) ContractHeadView *topView;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@end

@implementation RoomDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGGreenColor;
    self.navigationItem.title = @"房屋详细信息";
    [self pageContentView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (SGPageContentView *)pageContentView
{
    if (!_pageContentView) {
        NSArray *titleArr = @[@"房屋信息",@"有效业务状态",@"房屋业务历史",@"不动产单元号变化"];
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
//        configure.indicatorStyle = SGIndicatorStyleDefault;
        configure.spacingBetweenButtons = 25;
        configure.titleSelectedColor = [UIColor whiteColor];
        configure.indicatorStyle = SGIndicatorStyleCover;
        configure.indicatorColor = KDarkGreenColor;
//        configure.indicatorHeight = 25;
//        configure.indicatorBorderWidth = 1;
////        configure.indicatorBorderColor = KDarkGreenColor;
//        configure.indicatorCornerRadius = 4;
        
        self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, KContractHeadViewHeight, self.view.frame.size.width, 45) delegate:self titleNames:titleArr configure:configure];
        self.pageTitleView.isOpenTitleTextZoom = YES;
        self.pageTitleView.backgroundColor = KDarkGreenColor;
        [self.view addSubview:self.pageTitleView];
        [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(45);
        }];
        RoomInfoViewController *infoVC = [[RoomInfoViewController alloc] init];
        StateViewController *stateVC = [[StateViewController alloc] init];
        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
        ChangedViewController *changeVC = [[ChangedViewController alloc] init];
        NSArray *vcArr = @[infoVC,stateVC,historyVC,changeVC];
        CGFloat contentViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame) - kNavbarAndStatusHieght;
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:vcArr];
        _pageContentView.delegatePageContentView = self;
        [self.view addSubview:_pageContentView];
        [_pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pageTitleView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _pageContentView;
}


- (ContractHeadView *)topView
{
    if (!_topView) {
        _topView = [ContractHeadView instanceView];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(KContractHeadViewHeight);
        }];
    }
    return _topView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
