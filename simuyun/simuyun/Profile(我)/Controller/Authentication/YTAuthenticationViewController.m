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


#define maginTop 64

@interface YTAuthenticationViewController () <AutocompletionTableViewDelegate>

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

@end

@implementation YTAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"理财师认证";
    // 获取机构信息
    [self loadOrgnazations];
    self.view.frame = CGRectMake(0, maginTop, DeviceWidth, DeviceHight - maginTop);
    // 初始化左侧返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackClick)];
}

- (void)blackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  加载机构信息
 *
 */
- (void)loadOrgnazations
{
    [YTHttpTool get:YTOrgnazations params:nil success:^(id responseObject) {
        self.orgnazations = [YTOrgnazationModel objectArrayWithKeyValuesArray:responseObject];
        // 遍历json
        for (NSDictionary *dict in responseObject) {
            [self.orgnaNames addObject:dict[@"party_name"]];
        }
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
    [SVProgressHUD showWithStatus:@"正在认证" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisersId"] = [YTAccountTool account].userId;
    dict[@"realName"] = self.userNameLable.text;
    dict[@"orgId"] = selectedOrgna.party_id;
    [YTHttpTool post:YTAuthAdviser params:dict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        YTAuthenticationModel *authen = [[YTAuthenticationModel alloc] init];
        authen.realName = self.userNameLable.text;
        authen.orgName = self.mechanismNameLable.text;
        authen.submitTime = responseObject[@"submitTime"];
        YTAuthenticationStatusController *authVc = [[YTAuthenticationStatusController alloc] init];
        authVc.authen = authen;
        [self updateUserInfo];
        
        [self.navigationController pushViewController:authVc animated:YES];
        
    } failure:^(NSError *error) {
    }];
    
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


    return self.orgnaNames;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mechanismNameLable addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:self.userNameLable inputView:nil name:@"" insetBottom:20];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.mechanismNameLable inputView:nil name:@"" insetBottom:120];
        return @[tfm1, tfm2];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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
