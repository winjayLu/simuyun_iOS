//
//  YTBindingPhoneController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBindingPhoneController.h"
#import "JKCountDownButton.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "YTAuthenticationViewController.h"
#import "YTUserInfoTool.h"
#import "NSString+Password.h"
#import "CoreTFManagerVC.h"
#import "YTAuthenticationModel.h"
#import "YTAuthenticationStatusController.h"
#import "AutocompletionTableView.h"
#import "YTOrgnazationModel.h"
#import "YTFatherModel.h"
#import "YTCustomPickerView.h"


@interface YTBindingPhoneController () <AutocompletionTableViewDelegate>

// 姓名
@property (weak, nonatomic) IBOutlet UITextField *userNameLable;
// 机构名称
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
// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
// 验证码
@property (weak, nonatomic) IBOutlet UITextField *yanzhenField;

// 发送验证码
- (IBAction)sendYanzheng:(JKCountDownButton *)sender;

/**
 *  验证码
 */
@property (nonatomic, copy) NSString *captcha;

// 验证码按钮
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;

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


@end

@implementation YTBindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证理财师";
    // 获取机构信息
    [self loadOrgnazations];
    
    self.sendBtn.backgroundColor = YTColor(215, 58, 46);
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendYanzheng:(JKCountDownButton *)sender {
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    // 本地验证
    if (self.phoneField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    // 设置倒计时时长
    sender.enabled = NO;
    [sender startWithSecond:60];
    // 修改按钮的标题
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后重发",second];
        self.sendBtn.backgroundColor = YTColor(208, 208, 208);
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    
    // 向服务器发送验证码
    [self sendRegisterNumber];
    
}

/**
 *  申请认证
 *
 */
- (IBAction)applyClick:(UIButton *)sender
{
    // 校验
    if (![self checkout]) return;
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
    dict[@"phoneNum"] = self.phoneField.text;
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
        YTAuthenticationStatusController *authVc = [[YTAuthenticationStatusController alloc] init];
        authVc.authen = authen;
        [self updateUserInfo];
        [self.navigationController pushViewController:authVc animated:YES];
    } failure:^(NSError *error) {
    }];
    
}


/**
 *  发送验证码
 */
- (void)sendRegisterNumber
{
    NSDictionary *dict = @{@"phone" : self.phoneField.text, @"checkPhoneDuplicate" : @1};
    [YTHttpTool post:YTCaptcha params:dict success:^(id responseObject) {
        self.captcha = responseObject[@"captcha"];
    } failure:^(NSError *error) {
        [self.sendBtn stop];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
}

// 校验
- (BOOL)checkout{
    
    if (self.userNameLable.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return NO;
    } else if (self.mechanismNameLable.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入机构名称"];
        return NO;
    } else if (self.phoneField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    } else if (self.yanzhenField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return NO;
    } else if(![self.captcha isEqualToString:self.yanzhenField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return NO;
    }
    return YES;
}

// 修改用户信息
- (void)updateUserInfo
{
    [YTCenter postNotificationName:YTUpdateUserInfo object:nil];
    YTUserInfo *userInfo =[YTUserInfoTool userInfo];
    userInfo.phoneNumer = self.phoneField.text;
    [YTUserInfoTool saveUserInfo:userInfo];
}

#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    [self.mechanismNameLable addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:self.userNameLable inputView:nil name:@"" insetBottom:5];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.mechanismNameLable inputView:nil name:@"" insetBottom:130];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.phoneField inputView:nil name:@"" insetBottom:10];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.yanzhenField inputView:nil name:@"" insetBottom:60];
        TFModel *tfm5=[TFModel modelWithTextFiled:self.tuijianLabel inputView:nil name:@"" insetBottom:130];
        return @[tfm1, tfm2, tfm3, tfm4, tfm5];
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
#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{

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
        for (NSDictionary *dict in responseObject) {
            [self.fatherNames addObject:dict[@"name"]];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
    }];
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


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}

/*

 */




- (IBAction)tuijianrenClick:(id)sender {
    
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    YTCustomPickerView *addressPickerView = [[YTCustomPickerView alloc]init];
    addressPickerView.types = self.fatherNames;
    addressPickerView.block = ^(YTCustomPickerView *view,UIButton *btn,NSString *selectType){
        self.tuijianLabel.text = selectType;
    };
    NSString *type = self.tuijianLabel.text;
    if (type.length == 0) {
        type = nil;
    }
    [addressPickerView showWithSlectedType:type];
}
@end
