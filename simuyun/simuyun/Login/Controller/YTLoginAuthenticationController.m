//
//  YTLoginAuthenticationController.m
//  simuyun
//
//  Created by Luwinjay on 15/12/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLoginAuthenticationController.h"
#import "AutocompletionTableView.h"
#import "CoreTFManagerVC.h"
#import "YTOrgnazationModel.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "YTAuthenticationModel.h"
#import "YTAuthenticationStatusController.h"
#import "YTUserInfoTool.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "YTTabBarController.h"
#import "CALayer+Transition.h"
#import "YTFatherModel.h"
#import "YTCustomPickerView.h"
#import "SubLBXScanViewController.h"

#define maginTop 64

@interface YTLoginAuthenticationController ()<AutocompletionTableViewDelegate, YTScanDelegate>

/**
 *  客户名称
 *
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameLable;

/**
 *  机构名称
 *
 */
@property (weak, nonatomic) IBOutlet UITextField *mechanismNameLable;

/**
 *  申请认证
 *
 */
- (IBAction)applyClick:(UIButton *)sender;

/**
 *  机构列表
 *
 */
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
/**
 *  机构模型数组
 *
 */@property (nonatomic, strong) NSArray *orgnazations;

/**
 *  机构名称数组
 *
 */
@property (nonatomic, strong) NSMutableArray *orgnaNames;


- (IBAction)pushMainClick;

- (IBAction)tuijianrenClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tuijianrenField;

/**
 *  推荐人模型数组
 *
 */@property (nonatomic, strong) NSArray *fathers;

/**
 *  推荐人姓名数组
 *
 */
@property (nonatomic, strong) NSMutableArray *fatherNames;

@property (weak, nonatomic) IBOutlet UIImageView *lineView;

/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;


- (IBAction)ScanClick:(id)sender;

@end

@implementation YTLoginAuthenticationController



- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏
    [self setupNav];
    
    // 修改textField占位文字颜色
    [self.userNameLable setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.mechanismNameLable setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.tuijianrenField setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self loadOrgnazations];
    
    [self animationLine];
    // 开启定时器
    [self timerOn];
}

// 动画
- (void)animationLine
{
    [UIView animateWithDuration:1.5 animations:^{
        self.lineView.hidden = NO;
        self.lineView.y += 88;
    } completion:^(BOOL finished) {
        self.lineView.hidden = YES;
        self.lineView.y = 3;
    }];
}


/**
 *  加载机构信息
 *
 */
- (void)loadOrgnazations
{
    [SVProgressHUD showWithStatus:@"正在加载机构信息" maskType:SVProgressHUDMaskTypeClear];
    [YTHttpTool get:YTOrgnazations params:nil success:^(id responseObject) {
        self.orgnazations = [YTOrgnazationModel objectArrayWithKeyValuesArray:responseObject];
        // 遍历json
        for (NSDictionary *dict in responseObject) {
            [self.orgnaNames addObject:dict[@"party_name"]];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
    }];
}

- (IBAction)applyClick:(UIButton *)sender {
    if (self.userNameLable.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    YTOrgnazationModel *selectedOrgna = nil;
    for (YTOrgnazationModel *orgna in self.orgnazations) {
        if ([orgna.party_name isEqualToString:self.mechanismNameLable.text]) {
            selectedOrgna = orgna;
        }
    }
    if (selectedOrgna == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择正确的机构"];
        return;
    }
    // 判断是否输入推荐人
    YTFatherModel *selectedFather = nil;
    if (self.tuijianrenField.text.length > 0) {
        for (YTFatherModel *father in self.fathers) {
            if ([father.name isEqualToString:self.tuijianrenField.text]) {
                selectedFather = father;
            }
        }
    }
    
    [SVProgressHUD showWithStatus:@"正在认证" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisersId"] = [YTAccountTool account].userId;
    dict[@"realName"] = self.userNameLable.text;
    dict[@"orgId"] = selectedOrgna.party_id;
    if (selectedFather != nil) {
        dict[@"fatherId"] = selectedFather.adviserId;
    }
    dict[@"authenticationType"] = @"0";
    [YTHttpTool post:YTAuthAdviser params:dict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [YTUserInfoTool userInfo].adviserStatus = 2;
        [self transitionTabBarVC];
    } failure:^(NSError *error) {
    }];
}

/**
 *  转场到主界面
 */
- (void)transitionTabBarVC
{
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = [[YTTabBarController alloc] init];
    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeCube subType:TransitionSubtypesFromRight curve:TransitionCurveEaseOut duration:0.75f];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
}
/**
 *  设置导航栏状态
 */
- (void)setupNav
{
    self.title = @"认证理财师";
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 隐藏子控件
//    [self navigationBarWithHidden:YES];

}



#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    
    self.tuijianrenField.text = nil;
    return self.orgnaNames;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    // 获取推荐人列表
    [self loadfather:self.mechanismNameLable.text];
}

// 加载推荐人
- (void)loadfather:(NSString *)orgName
{
    [SVProgressHUD showWithStatus:@"正在加载推荐人信息" maskType:SVProgressHUDMaskTypeClear];
    YTOrgnazationModel *selectedOrgna = nil;
    for (YTOrgnazationModel *orgna in self.orgnazations) {
        if ([orgna.party_name isEqualToString:self.mechanismNameLable.text]) {
            selectedOrgna = orgna;
        }
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orgId"] = selectedOrgna.party_id;
    [YTHttpTool get:YTReferee params:param success:^(id responseObject) {
        self.fathers = [YTFatherModel objectArrayWithKeyValuesArray:responseObject];
        // 遍历json
        [self.fatherNames removeAllObjects];
        [self.fatherNames addObject:@"无"];
        for (NSDictionary *dict in responseObject) {
            [self.fatherNames addObject:dict[@"name"]];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
    }];
}


#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mechanismNameLable addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.userNameLable inputView:nil name:@"" insetBottom:20];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.mechanismNameLable inputView:nil name:@"" insetBottom:140];
        return @[tfm1, tfm2];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}


#pragma mark - lazy
- (NSArray *)orgnazations
{
    if (!_orgnazations) {
        _orgnazations = [[NSArray alloc] init];
    }
    return _orgnazations;
}

- (NSMutableArray *)orgnaNames
{
    if (!_orgnaNames) {
        _orgnaNames = [[NSMutableArray alloc] init];
    }
    return _orgnaNames;
}
- (NSArray *)fathers
{
    if (!_fathers) {
        _fathers = [[NSArray alloc] init];
    }
    return _fathers;
}

- (NSMutableArray *)fatherNames
{
    if (!_fatherNames) {
        _fatherNames = [[NSMutableArray alloc] init];
    }
    return _fatherNames;
}

- (IBAction)pushMainClick {
    [self transitionTabBarVC];
    
}

- (IBAction)tuijianrenClick:(id)sender {
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }

    if (self.fathers.count == 0 && self.mechanismNameLable.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入机构"];
        return;
    }

    YTCustomPickerView *addressPickerView = [[YTCustomPickerView alloc]init];
    addressPickerView.types = self.fatherNames;
    addressPickerView.block = ^(YTCustomPickerView *view,UIButton *btn,NSString *selectType){
        if ([selectType isEqualToString:@"无"]) {
            self.tuijianrenField.text = nil;
        } else {
            self.tuijianrenField.text = selectType;
        }
    };
    NSString *type = self.tuijianrenField.text;
    if (type.length == 0) {
        type = nil;
    }
    [addressPickerView showWithSlectedType:type];
    
}

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        [options setValue:@2 forKey:@"style"];
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.mechanismNameLable inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    return _autoCompleter;
}

/**
 *  隐藏/显示navgatinonBar的子控件
 */
- (void)navigationBarWithHidden:(BOOL)hidden
{
    NSArray *list=self.navigationController.navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=hidden;
        }
    }
}

/*
 *  新开一个定时器
 */
-(void)timerOn{
    
    [self timerOff];
    
    if(self.timer!=nil) return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    //记录
    self.timer = timer;
    
}

/*
 *  关闭定时器
 */
-(void)timerOff{
    
    //关闭定时器
    [self.timer invalidate];
    
    //清空属性
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ScanClick:(id)sender {

    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.isQQSimulator = YES;
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)closePage
{
    [self transitionTabBarVC];
}

@end
