//
//  YTCollectionViewController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolHomeViewController.h"
#import "YTSchoolHeaderView.h"
#import "YTGroomVedioView.h"
#import "MJRefresh.h"
#import "YTSchoolCollectionCell.h"
#import "YTAccountTool.h"
#import "YTVedioModel.h"


@interface YTSchoolHomeViewController ()
/**
 *  推荐视频数组
 */
@property (nonatomic, strong) NSMutableArray *groomVedios;

/**
 *  推荐视频数组
 */
@property (nonatomic, strong) NSMutableArray *otherVedios;

/**
 *  顶部视图的容器
 */
@property (nonatomic, weak) UICollectionReusableView *reusableView;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTGroomVedioView *groomView;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTSchoolHeaderView *headerView;

@end

@implementation YTSchoolHomeViewController

static NSString * const reuseIdentifier = @"schoolCell";

static NSString * const headerIdentifier = @"headerCell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((DeviceWidth - 32) * 0.5, 146);
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 15, 8);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[YTSchoolCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 设置下拉刷新上拉加载
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadVedio)];
    // 上拉加载
    self.collectionView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVedio)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadVedio];
}

#pragma mark - 加载数据
/**
 *  加载视频
 */
- (void)loadVedio
{
    // 加载推荐视频
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTRecommended params:param
            success:^(NSDictionary *responseObject) {
                self.groomVedios = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
                // 加载其他视频
                [self loadOtherVedio];
            } failure:^(NSError *error) {
                // 结束刷新状态
                [self.collectionView.header endRefreshing];
            }];
}
/**
 *  加载其他视频
 */
- (void)loadOtherVedio
{
    // 加载推荐视频
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = @"0";
    param[@"limit"] = @"8";
    [YTHttpTool get:YTVideos params:param
            success:^(NSDictionary *responseObject) {
                self.otherVedios = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
                // 结束刷新状态
                [self.collectionView reloadData];
                [self.collectionView.header endRefreshing];
            } failure:^(NSError *error) {
                // 结束刷新状态
                [self.collectionView.header endRefreshing];
            }];
}

/**
 *  加载更多视频
 *
 */
- (void)loadMoreVedio
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = [NSString stringWithFormat:@"%zd", self.otherVedios.count];
    param[@"limit"] = @"8";
    [YTHttpTool get:YTVideos params:param
            success:^(NSDictionary *responseObject) {
                NSArray *result = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
                if(result.count == 0)
                {
                    [self.collectionView.footer noticeNoMoreData];
                    return;
                }
                [self.otherVedios addObjectsFromArray:result];
                // 结束刷新状态
                [self.collectionView reloadData];
                [self.collectionView.footer endRefreshing];
            } failure:^(NSError *error) {
                // 结束刷新状态
                [self.collectionView.footer endRefreshing];
            }];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.otherVedios.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTSchoolCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.vedio = self.otherVedios[indexPath.row];
    return cell;
}

/**
 *  初始化headerView
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (self.reusableView)
        {
            self.headerView.vedio = self.groomVedios[0];
            self.groomView.vedios = self.groomVedios;
            return self.reusableView;
        } else {
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
            // 初始化顶部视图
            CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
            YTSchoolHeaderView *header = [[YTSchoolHeaderView alloc] init];
            header.frame = CGRectMake(0, 0, DeviceWidth, headerHeight);
            header.vedio = self.groomVedios[0];
            [reusableView addSubview:header];
            self.headerView = header;
            // 初始化推荐视频
            YTGroomVedioView *groomView = [[YTGroomVedioView alloc] initWithVedios:self.groomVedios];
            groomView.frame = CGRectMake(0, CGRectGetMaxY(header.frame), DeviceWidth, groomView.selfHeight);
            [reusableView addSubview:groomView];
            self.groomView = groomView;
            self.reusableView = reusableView;
            return reusableView;
        }
    }
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
    CGFloat groomHeight = 410;
    return CGSizeMake(DeviceWidth, headerHeight + groomHeight);
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma mark - lazy

- (NSMutableArray *)groomVedios
{
    if (!_groomVedios) {
        _groomVedios = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            YTVedioModel *vedio = [[YTVedioModel alloc] initWithTitle:@"sss" image:@"SchoolBanner" shortName:@"我是子标题我是子标题我是子标题我是子标题我是子标题"];
            [_groomVedios addObject:vedio];
        }
    }
    return _groomVedios;
}

- (NSMutableArray *)otherVedios
{
    if (!_otherVedios) {
        _otherVedios = [[NSMutableArray alloc] init];
    }
    return _otherVedios;
}



@end
