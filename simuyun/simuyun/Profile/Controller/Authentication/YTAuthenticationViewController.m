//
//  YTAuthenticationViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/27.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTAuthenticationViewController.h"
#import "AutocompletionTableView.h"
#import "CoreTFManagerVC.h"
#import "YTOrgnazationModel.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "YTAuthenticationModel.h"
#import "YTAuthenticationStatusController.h"
#import "YTUserInfoTool.h"
#import "UIBarButtonItem+Extension.h"
#import "YTFatherModel.h"
#import "YTCustomPickerView.h"
#import "SubLBXScanViewController.h"


#define maginTop 64

@interface YTAuthenticationViewController () <AutocompletionTableViewDelegate, YTScanDelegate>

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
 *  推荐人
 *
 */
@property (weak, nonatomic) IBOutlet UITextField *tuijianLabel;


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

/**
 *  推荐人模型数组
 *
 */@property (nonatomic, strong) NSArray *fathers;

/**
 *  推荐人姓名数组
 *
 */
@property (nonatomic, strong) NSMutableArray *fatherNames;

/**
 *  推荐人点击
 *
 */
- (IBAction)tuijianrenClick:(id)sender;

// 标注
@property (weak, nonatomic) IBOutlet UILabel *biaozhuLable;

@end

@implementation YTAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证理财师";
    // 获取机构信息
    [self loadOrgnazations];
    self.view.frame = CGRectMake(0, maginTop, DeviceWidth, DeviceHight - maginTop);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"rightScan" target:self action:@selector(rightClick)];
    
    NSString *text = @"注意：请输入机构简称进行检索选择，如您的机构还未在私募云平台注册，请致电400-188-8848或者在App中与平台客服直接联系。（机构自有员工可不填推荐人）";
    
    //Label获取attStr式样
    self.biaozhuLable.attributedText = [self attributedStringWithStr:text];
    
}

- (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str
{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:8.0f];
    
    //根据给定长度与style设置attStr式样]
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    return attStr;
}




- (IBAction)rightClick
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.isQQSimulator = YES;
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)closePage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if (self.tuijianLabel.text.length > 0) {
        for (YTFatherModel *father in self.fathers) {
            if ([father.name isEqualToString:self.tuijianLabel.text]) {
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
        YTAuthenticationModel *authen = [[YTAuthenticationModel alloc] init];
        authen.realName = self.userNameLable.text;
        authen.orgName = self.mechanismNameLable.text;
        authen.submitTime = responseObject[@"submitTime"];
        authen.fatherName = selectedFather.name;
        YTAuthenticationStatusController *authVc = [[YTAuthenticationStatusController alloc] init];
        authVc.authen = authen;
        [self updateUserInfo];
        [self.navigationController pushViewController:authVc animated:YES];
    } failure:^(NSError *error) {}];
    
}

// 修改用户信息
- (void)updateUserInfo
{
    [YTCenter postNotificationName:YTUpdateUserInfo object:nil];
    YTUserInfo *userInfo =[YTUserInfoTool userInfo];
    userInfo.adviserStatus = 2;
    [YTUserInfoTool saveUserInfo:userInfo];
}



#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    self.tuijianLabel.text = nil;
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
            self.tuijianLabel.text = nil;
        } else {
            self.tuijianLabel.text = selectType;
        }
    };
    NSString *type = self.tuijianLabel.text;
    if (type.length == 0) {
        type = nil;
    }
    [addressPickerView showWithSlectedType:type];
}


#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mechanismNameLable addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:self.userNameLable inputView:nil name:@"" insetBottom:20];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.mechanismNameLable inputView:nil name:@"" insetBottom:130];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.tuijianLabel inputView:nil name:@"" insetBottom:20];
        
        return @[tfm1, tfm2, tfm3];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
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

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.mechanismNameLable inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    return _autoCompleter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
