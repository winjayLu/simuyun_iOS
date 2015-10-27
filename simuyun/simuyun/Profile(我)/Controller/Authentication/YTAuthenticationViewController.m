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
 *  机构列表
 *
 */
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
/**
 *  机构模型数组
 *
 */
@property (nonatomic, strong) NSArray *orgnazations;
/**
 *  机构名称数组
 *
 */
@property (nonatomic, strong) NSMutableArray *orgnaNames;

@end

@implementation YTAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取机构信息
    [self loadOrgnazations];
    self.view.frame = CGRectMake(0, maginTop, DeviceWidth, DeviceHight - maginTop);
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


#pragma mark - lazy

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
#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{


    return self.orgnaNames;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    NSLog(@"%@", self.orgnaNames[index]);
    NSLog(@"sss%@", self.orgnazations[index]);
}

#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, maginTop, DeviceWidth, DeviceHight - maginTop);
    [self.mechanismNameLable addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.mechanismNameLable inputView:nil name:@"" insetBottom:120];
        return @[tfm1];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
