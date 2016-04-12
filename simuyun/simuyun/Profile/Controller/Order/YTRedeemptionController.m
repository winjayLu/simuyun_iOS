//
//  YTRedeemptionController.m
//  simuyun
//
//  Created by Luwinjay on 16/4/12.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTRedeemptionController.h"
#import "TZTestCell.h"

// 赎回申请

@interface YTRedeemptionController () <UICollectionViewDelegate, UICollectionViewDataSource>

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *mainView;

/**
 *  倒计时视图
 */
@property (nonatomic, weak) UIView *endTimeView;

/**
 *  截止赎回时间Lable
 */
@property (nonatomic, weak) UILabel *endTimeLable;

#pragma 账户信息视图

/**
 *  初始化账户信息视图
 */
@property (nonatomic, weak) UIView *AccountView;

/**
 *  客户姓名Lable
 */
@property (nonatomic, weak) UILabel *custNameLable;

/**
 *  赎回帐号Lable
 */
@property (nonatomic, weak) UILabel *redeemBankAccountLable;

/**
 *  帐号开户行Lable
 */
@property (nonatomic, weak) UILabel *bankNameLable;

#pragma 账户信息视图

/**
 *  账户信息视图
 */
@property (nonatomic, weak) UIView *RedeemView;

/**
 *  赎回金额Lable
 */
@property (nonatomic, weak) UILabel *redeemAmtLable;

/**
 *  图片选择View
 */
@property (nonatomic, weak) UICollectionView *photoView;


#pragma 底部视图

/**
 *  初始化底部视图
 */
@property (nonatomic, weak) UIView *bottomView;

/**
 *  文件视图
 */
@property (nonatomic, weak) UIView *fileView;

/**
 *  赎回说明View
 */
@property (nonatomic, weak) UIView *descriptionView;

/**
 *  选中的照片数组
 */
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end

@implementation YTRedeemptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 初始化滚动视图
    [self setupScrollView];
    
    // 初始化倒计时视图
    [self setupEndTimeView];
    
    // 初始化账户信息视图
    [self setupAccountView];
    
    // 初始化赎回信息视图
    [self setupRedeemView];
    
    // 初始化图片选择视图
    [self setupPhotoView];
    
    // 初始化底部视图
    [self setupBottomView];
}


#pragma mark - 初始化方法
/**
 *  初始化滚动视图
 */
- (void)setupScrollView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.height - 64)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

/**
 *  初始化倒计时视图
 */
- (void)setupEndTimeView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = YTColor(246, 246, 246);
    container.frame = CGRectMake(0, 0, DeviceWidth, 40);
    [self.mainView addSubview:container];
    self.endTimeView = container;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, container.height - 1, DeviceWidth, 1);
    [container addSubview:line];
    
    // 文本
    UILabel *text = [[UILabel alloc] init];
    text.frame = container.bounds;
    text.font = [UIFont systemFontOfSize:12];
    text.textColor = YTColor(51, 51, 51);
    text.text = @"本次申请赎回截止时间还剩";
    text.textAlignment = NSTextAlignmentCenter;
    [container addSubview:text];
    self.endTimeLable = text;
}

/**
 *  初始化账户信息视图
 */
- (void)setupAccountView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.endTimeView.frame), DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.AccountView = container;
    
    // lable左边距
    CGFloat maginX = 35;
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"账户信息";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.frame = CGRectMake(maginX, 15, title.width, title.height);
    [container addSubview:title];

    // 小红点
    UIImageView *redView = [[UIImageView alloc] init];
    redView.image = [UIImage imageNamed:@""];
    redView.size = redView.image.size;
    redView.center = title.center;
    redView.x = title.x - 10 - redView.image.size.width;
    [container addSubview:redView];
    
    // 客户姓名
    UILabel *custNameLable = [self createDarkGrayLable];
    custNameLable.text = @"客户姓名：";
    [custNameLable sizeToFit];
    custNameLable.x = 35;
    custNameLable.y = CGRectGetMaxY(title.frame) + 10;
    [container addSubview:custNameLable];
    self.custNameLable = custNameLable;
    
    // 赎回帐号
    UILabel *redeemBankAccountLable = [self createDarkGrayLable];
    redeemBankAccountLable.text = @"赎回帐号：";
    [redeemBankAccountLable sizeToFit];
    redeemBankAccountLable.x = 35;
    redeemBankAccountLable.y = CGRectGetMaxY(custNameLable.frame) + 10;
    [container addSubview:redeemBankAccountLable];
    self.redeemBankAccountLable = redeemBankAccountLable;
    
    // 所属银行
    UILabel *bankNameLable = [self createDarkGrayLable];
    bankNameLable.text = @"所属银行：";
    [bankNameLable sizeToFit];
    bankNameLable.x = 35;
    bankNameLable.y = CGRectGetMaxY(redeemBankAccountLable.frame) + 10;
    [container addSubview:bankNameLable];
    self.bankNameLable = bankNameLable;
    
    // 修改容器高度
    container.height = CGRectGetMaxY(bankNameLable.frame) + 15;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, container.height - 1, DeviceWidth, 1);
    [container addSubview:line];
}

/**
 *  初始化赎回信息视图
 */
- (void)setupRedeemView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.AccountView.frame), DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.RedeemView = container;
    // lable左边距
    CGFloat maginX = 35;
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"赎回信息";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.frame = CGRectMake(maginX, 15, title.width, title.height);
    [container addSubview:title];
    
    // 小红点
    UIImageView *redView = [[UIImageView alloc] init];
    redView.image = [UIImage imageNamed:@""];
    redView.size = redView.image.size;
    redView.center = title.center;
    redView.x = title.x - 10 - redView.image.size.width;
    [container addSubview:redView];
    
    // 赎回金额
    UILabel *redeemAmtLable = [self createDarkGrayLable];
    redeemAmtLable.text = @"赎回金额：";
    [redeemAmtLable sizeToFit];
    redeemAmtLable.x = 35;
    redeemAmtLable.y = CGRectGetMaxY(title.frame) + 10;
    [container addSubview:redeemAmtLable];
    self.redeemAmtLable = redeemAmtLable;
    
    // 赎回材料
    UILabel *redeemDescription = [self createDarkGrayLable];
    redeemDescription.text = @"赎回材料：";
    [redeemDescription sizeToFit];
    redeemDescription.x = 35;
    redeemDescription.y = CGRectGetMaxY(redeemAmtLable.frame) + 10;
    [container addSubview:redeemDescription];
    
    // 修改容器高度
    container.height = CGRectGetMaxY(redeemDescription.frame) + 10;
}

/**
 *  初始图片选择视图
 */
- (void)setupPhotoView
{
    CGFloat margin = 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWh = (self.view.width - 2 * margin - 4) / 3 - margin;
    layout.itemSize = CGSizeMake(itemWh, itemWh);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    UICollectionView *photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.RedeemView.frame), self.view.width - 2 * margin, itemWh + margin * 2) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    photoView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    photoView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    photoView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    photoView.dataSource = self;
    photoView.delegate = self;
    [self.mainView addSubview:photoView];
    self.photoView = photoView;
#warning 注册Cell
    [photoView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}


/**
 *  初始化底部视图
 */
- (void)setupBottomView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.photoView.frame) + 10, DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.bottomView = container;
    
#warning 文件资源可有可无  或 多个文件
    // 文件资源View
    UIView *fileView = [[UIView alloc] init];
    fileView.frame = CGRectMake(0, 0, DeviceWidth, 40);
    fileView.backgroundColor = [UIColor redColor];
    [container addSubview:fileView];
    self.fileView = fileView;
    
#warning 确认是否100%存在
    // 赎回说明View
    UIView *descriptionView = [[UIView alloc] init];
    descriptionView.frame = CGRectMake(0, fileView.height, DeviceWidth, 40);
    descriptionView.backgroundColor = [UIColor blueColor];
    [container addSubview:descriptionView];
    self.fileView = descriptionView;
    
    // 邮件获取赎回材料按钮
    UIButton *getEmail = [[UIButton alloc] init];
    getEmail.backgroundColor = YTColor(91, 168, 243);
    [getEmail setTitle:@"邮件获取赎回材料" forState:UIControlStateNormal];
    [getEmail.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [getEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getEmail.layer.cornerRadius = 10;
    getEmail.layer.masksToBounds = YES;
    getEmail.frame = CGRectMake(10, CGRectGetMaxY(descriptionView.frame) + 20, self.view.width - 20, 44);
    [getEmail addTarget:self action:@selector(getEmailClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:getEmail];
    
    // 提交赎回按钮
    UIButton *redeemBtn = [[UIButton alloc] init];
    redeemBtn.backgroundColor = YTNavBackground;
    [redeemBtn setTitle:@"提交赎回" forState:UIControlStateNormal];
    [redeemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [redeemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    redeemBtn.layer.cornerRadius = 10;
    redeemBtn.layer.masksToBounds = YES;
    redeemBtn.frame = CGRectMake(10, CGRectGetMaxY(getEmail.frame) + 10, self.view.width - 20, 44);
    [redeemBtn addTarget:self action:@selector(redeemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:redeemBtn];
    
    // 修改容器高度
    container.height = CGRectGetMaxY(redeemBtn.frame) + 20;
    
    // 修改滚动范围
    self.mainView.contentSize = CGSizeMake(DeviceWidth, CGRectGetMaxY(container.frame));
}


/**
 *  获取详细资料
 */
- (void)getEmailClick
{
    
}

/**
 *  提交赎回
 */
- (void)redeemBtnClick
{

}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
    } else {
        cell.imageView.image = self.selectedPhotos[indexPath.row];
    }
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _selectedPhotos.count) [self pickPhotoButtonClick:nil];
//}

/**
 *  创建灰色lable
 */
- (UILabel *)createDarkGrayLable
{
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = YTColor(102, 102, 102);
    return lable;
}

#pragma mark - lazy
- (NSArray *)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
