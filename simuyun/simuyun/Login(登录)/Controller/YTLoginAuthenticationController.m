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

#define maginTop 64

@interface YTLoginAuthenticationController ()<AutocompletionTableViewDelegate>

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


@end

@implementation YTLoginAuthenticationController



- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏
    [self setupNav];
    
    // 修改textField占位文字颜色
    [self.userNameLable setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.mechanismNameLable setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self loadOrgnazations];
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
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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

- (IBAction)pushMainClick {
    [self transitionTabBarVC];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
