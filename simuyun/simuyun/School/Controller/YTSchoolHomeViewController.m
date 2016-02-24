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
#import "YTPlayerViewController.h"
#import "YTTabBarController.h"
#import "YTSchoolListController.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"
#import "CoreArchive.h"


@interface YTSchoolHomeViewController () <headerViewDelegate, groomViewDelegate>
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
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    if (DeviceWidth < 375.0f) {
        layout.itemSize = CGSizeMake(vedioWidth, vedioWidth * 0.849 + 10);
    } else {
        layout.itemSize = CGSizeMake(vedioWidth, vedioWidth * 0.849 + 4);
    }
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
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
                // 存储获取到的数据
                NSString *oldScrollGroom = [responseObject JsonToString];
                [CoreArchive setStr:oldScrollGroom key:@"oldScrollGroom"];
                // 加载其他视频
                [self loadOtherVedio];
                [self.collectionView.footer resetNoMoreData];
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
                // 存储获取到的数据
                NSString *oldScrollOther = [responseObject JsonToString];
                [CoreArchive setStr:oldScrollOther key:@"oldScrollOther"];
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
            header.headerDelegate = self;
            [reusableView addSubview:header];
            self.headerView = header;
            // 初始化推荐视频
            YTGroomVedioView *groomView = [[YTGroomVedioView alloc] initWithVedios:self.groomVedios];
            groomView.frame = CGRectMake(0, CGRectGetMaxY(header.frame), DeviceWidth, [self groomHeight]);
            [reusableView addSubview:groomView];
            groomView.groomDelegate = self;
            self.groomView = groomView;
            self.reusableView = reusableView;
            return reusableView;
        }
    }
    
    return nil;
}
- (CGFloat)groomHeight
{
    CGFloat aspectRatio = 0.0;
    if (iPhone4 || iPhone5) {
        aspectRatio = 1.164;
    } else if(iPhone6)
    {
        aspectRatio = 1.10;
    } else {
        aspectRatio = 1.08;
    }
    return aspectRatio * DeviceWidth;
}


-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
    return CGSizeMake(DeviceWidth, headerHeight + [self groomHeight]);
}
#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YTVedioModel *vedio = self.otherVedios[indexPath.row];
    [self playVedio:vedio];
    return YES;
}


#pragma mark - subViewDelegate
/**
 *  播放视频
 */
- (void)playVedio:(YTVedioModel *)vedio
{
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        if (tabBar != nil) {
            FloatView *floatView = tabBar.floatView;
            YTPlayerViewController *player = tabBar.playerVc;
            if (player != nil && [player.vedio.videoId isEqualToString:vedio.videoId] ) {
                tabBar.floatView.boardWindow.hidden = YES;
                 [self presentViewController:player animated:YES completion:nil];
            } else {
                [floatView removeFloatView];
                tabBar.playerVc = nil;
                tabBar.floatView = nil;
                YTPlayerViewController *player = [[YTPlayerViewController alloc] init];
                player.vedio = vedio;
                [self presentViewController:player animated:YES completion:nil];
                
            }
        }
    }
}


/**
 *  打开列表页
 */
- (void)plusVedioList:(NSString *)type
{
    YTSchoolListController *list = [[YTSchoolListController alloc] init];
    list.type = type;
    list.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:list animated:YES];
}

/**
 *  播放视频
 */
- (void)playVedioWithVedio:(YTVedioModel *)vedio
{
    [self playVedio:vedio];
}

/**
 *  查看更多视频
 */
- (void)plusList
{
    [self plusVedioList:nil];
}


#pragma mark - lazy

- (NSMutableArray *)groomVedios
{
    if (!_groomVedios) {
        // 获取历史数据
        NSString *oldScrollGroom = [CoreArchive strForKey:@"oldScrollGroom"];
        if (oldScrollGroom != nil) {
            _groomVedios = [YTVedioModel objectArrayWithKeyValuesArray:[oldScrollGroom JsonToValue]];
        } else {
            _groomVedios = [[NSMutableArray alloc] init];
            for (int i = 0; i < 5; i++) {
                YTVedioModel *vedio = [[YTVedioModel alloc] initWithTitle:@"正在加载" image:nil shortName:@"正在加载中..."];
                [_groomVedios addObject:vedio];
            }
        }
    }
    return _groomVedios;
}

- (NSMutableArray *)otherVedios
{
    if (!_otherVedios) {
        // 获取历史数据
        NSString *oldScrollOther = [CoreArchive strForKey:@"oldScrollOther"];
        if (oldScrollOther != nil) {
            _otherVedios = [YTVedioModel objectArrayWithKeyValuesArray:[oldScrollOther JsonToValue]];
        } else {
            _otherVedios = [[NSMutableArray alloc] init];
        }
    }
    return _otherVedios;
}



@end
