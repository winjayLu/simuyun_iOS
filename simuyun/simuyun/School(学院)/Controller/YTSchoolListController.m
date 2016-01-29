//
//  YTSchoolListController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/28.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolListController.h"
#import "YTSchoolTableViewCell.h"
#import "MJExtension.h"
#import "YTAccountTool.h"
#import "YTDataHintView.h"
#import "MJRefresh.h"
#import "YTVedioModel.h"
#import "YTTabBarController.h"

@interface YTSchoolListController () <vedioLikeDelegate>

@property (nonatomic, strong) NSMutableArray *vedios;

/**
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;

/**
 *  选中的video
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation YTSchoolListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type){
        self.title = self.type;
    } else {
        self.title = @"其他视频";
    }
    // 设置颜色
    self.tableView.backgroundColor = [UIColor whiteColor];
//    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadVedios)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    // 上拉加载
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVedios)];
    
    // 初始化提醒视图
    [self setupHintView];
    
}

/**
 *  初始化提醒视图
 */
- (void)setupHintView
{
    YTDataHintView *hintView =[[YTDataHintView alloc] init];
    CGPoint center = CGPointMake(self.tableView.centerX, self.tableView.centerY - 89);
    [hintView showLoadingWithInView:self.tableView center:center];
    self.hintView = hintView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vedios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"schoolListCell";
    YTSchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTSchoolTableViewCell schoolCell];
        cell.coverImageView.layer.cornerRadius = 5;
        cell.coverImageView.layer.masksToBounds = YES;
        cell.coverImageView.layer.borderWidth = 1.0f;
    }
    NSLog(@"%zd",indexPath.row);
    cell.vedio = self.vedios[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playVedio:self.vedios[indexPath.row]];
    self.selectedIndex = indexPath.row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}
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
                player.delegate = self;
                player.vedio = vedio;
                [self presentViewController:player animated:YES completion:nil];
                
            }
        }
    }
}

/**
 *  点赞后更新列表数据
 */
- (void)likeChangData
{
    ((YTVedioModel *)(self.vedios[self.selectedIndex])).isLiked = 1;
    ((YTVedioModel *)(self.vedios[self.selectedIndex])).likes += 1;
    [self.tableView reloadData];
}



#pragma mark - 获取数据
- (void)loadVedios
{
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = @"0";
    param[@"limit"] = @"10";
    param[@"type"] = self.type;
    [YTHttpTool get:YTVideos params:param
            success:^(NSDictionary *responseObject) {
                [self.tableView.footer resetNoMoreData];
                self.vedios = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
                if([ self.vedios count] < 10)
                {
                    [self.tableView.footer noticeNoMoreData];
                }
                // 刷新表格
                [self.tableView reloadData];
                // 结束刷新状态
                [self.tableView.header endRefreshing];
                [self.hintView changeContentTypeWith:self.vedios];
            } failure:^(NSError *error) {
                // 结束刷新状态
                [self.tableView.header endRefreshing];
                [self.hintView ContentFailure];
            }];
}

/**
 *  加载更多视频
 */
- (void)loadMoreVedios
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = [NSString stringWithFormat:@"%zd", self.vedios.count];
    param[@"limit"] = @"10";
    param[@"type"] = self.type;
    [YTHttpTool get:YTVideos params:param success:^(id responseObject) {
        NSArray *array = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
        if(array.count == 0)
        {
            [self.tableView.footer noticeNoMoreData];
            return;
        }
        [self.tableView.footer endRefreshing];
        [self.vedios addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)vedios
{
    if (!_vedios) {
        _vedios = [[NSMutableArray alloc] init];
    }
    return _vedios;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
