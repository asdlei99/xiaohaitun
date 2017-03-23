//
//  JJForgetPasswordViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/4.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJForgetPasswordViewController.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>
#import "JJInPutTextField.h"
#import "JKCountDownButton.h"
#import "MBProgressHUD+gifHUD.h"
#import "Util.h"
#import "HFNetWork.h"
//#import "MXNavigationBarManager.h"
#import "User.h"
#import <MJExtension.h>
#import "JJCity.h"
#import "UINavigationBar+Awesome.h"
#import "UIViewController+KeyboardCorver.h"


#define PASSWORD_LIMITATION_LONG      20
#define PASSWORD_LIMITATION_SHORT     6

@interface JJForgetPasswordViewController ()

@property (nonatomic, copy) NSString *mobileString;

//手机号码
@property (nonatomic, strong)JJInPutTextField * phoneTextField;

//验证码
@property (nonatomic, strong) JJInPutTextField *codeTextField;

//获取验证码按钮
@property (nonatomic, strong) JKCountDownButton *countDownBtn;

//获取语音验证码按钮
@property (nonatomic, strong) UIButton *voiceBtn;

//密码
@property (nonatomic, strong)JJInPutTextField * passwordTextField;

//修改密码按钮
@property (nonatomic, strong) UIButton *changePwdBtn;

@end

@implementation JJForgetPasswordViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MXNavigationBarManager reStore];
//    [self.navigationController.navigationBar lt_reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航条内容
    [self setupNavigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
   
    
    //创建视图控件
    [self setupViews];
    //添加键盘通知
    [self addNotification];
}

//设置导航条内容
- (void)setupNavigationBar {
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:NORMAL_COLOR];
    //    //required
//    [MXNavigationBarManager saveWithController:self];
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//    [MXNavigationBarManager setTintColor:NORMAL_COLOR];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图控件
- (void)setupViews {
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    //用户登陆Label
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] text:@"忘记密码" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 69 * KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 33);
    [self.view addSubview:titleLabel];
    
    //手机号码
    self.phoneTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(14, 139, SCREEN_WIDTH - 14, 33) WithPlaceholder:@"手机号码" delegate:self];
    _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTextField];
    
    //验证码
    self.codeTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"验证码" delegate:self];
//    _codeTextField.textField.secureTextEntry = YES;
    [self.view addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(_phoneTextField.mas_bottom).with.offset(14);
        make.height.equalTo(@33);
    }];
    
    //密码
    self.passwordTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"请设置6-20位登录密码" delegate:self];
    self.passwordTextField.eyeBtn.hidden = NO;
    _passwordTextField.textField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(_codeTextField.mas_bottom).with.offset(14);
        make.height.equalTo(@33);
    }];
    
    
    //获取验证码按钮
    self.countDownBtn = [[JKCountDownButton alloc]init];
    [self.view addSubview:_countDownBtn];
    [_countDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //    _countDownBtn.backgroundColor = [UIColor greenColor];
    [_countDownBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    _countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_countDownBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];

    [_countDownBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        if (!_phoneTextField.textField.text.length) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
            return;
        }else if (![Util isMobileNumber:_phoneTextField.textField.text]) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
            return;
        }
        [self.codeTextField.textField becomeFirstResponder];
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"(%zd秒)重新发送",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
        }];
        
    }];
    [self.countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.codeTextField);
        make.width.equalTo(@92);
        
    }];
    
    //签到按钮左端竖线
    UIView *verticalLine = [[UIView alloc]init];
    [self.view addSubview:verticalLine];
    verticalLine.backgroundColor = RGB(238, 238, 238);
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.bottom.equalTo(self.codeTextField.mas_bottom);
        make.width.equalTo(@1);
        make.right.equalTo(self.countDownBtn.mas_left);
    }];

    
    
    //修改密码按钮
    self.changePwdBtn = [[UIButton alloc]init];
    [self.view addSubview:_changePwdBtn];
    [_changePwdBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [_changePwdBtn setBackgroundColor:NORMAL_COLOR];
    [_changePwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changePwdBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:0];
    [_changePwdBtn addTarget:self action:@selector(conformButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _changePwdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_changePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(30);
        make.height.equalTo(@42);
    }];
    
    //获取语音验证码
    UILabel *notReceiveLabel = [[UILabel alloc]init];
    [notReceiveLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"如果没有收到验证码,请点击这里" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentCenter];
    self.voiceBtn = [[UIButton alloc]init];
    [self.voiceBtn setTitle:@"获取语音验证码" forState:UIControlStateNormal];
    [self.voiceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.voiceBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [_voiceBtn addTarget:self action:@selector(sendVoiceCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *voiceBackView = [[UIView alloc]init];
    [self.view addSubview:voiceBackView];
    [voiceBackView addSubview:notReceiveLabel];
    [voiceBackView addSubview:self.voiceBtn];
    [voiceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changePwdBtn.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
    }];
    [notReceiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(voiceBackView);
        make.right.equalTo(self.voiceBtn.mas_left);
    }];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(voiceBackView);
        
    }];
    
}


#pragma mark - 点击获取验证码按钮
- (void)sendCodeAction:(JKCountDownButton *)countDownButton {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    self.mobileString = _phoneTextField.textField.text;
    [self requestForVerifyCode];

}

//发送获取验证码请求
- (void)requestForVerifyCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SEND_V_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobileString = self.mobileString;
    [params setObject:mobileString forKey:@"mobile"];
    /**
     *  成功返回
     {
     "error_code": 0,
     "v_code": "1212"
     }
     */
//    if (![Util isNetWorkEnable]) {//先判断网络状态
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
//        return;
//    }
//    _countDownBtn.enabled = NO;
//    [MBProgressHUD showHUD:nil];
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        NSString *codeMessage = [response objectForKey:@"error_msg"];
        if (codeValue) { //失败返回
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        DebugLog(@"发送验证码成功:%@",response);
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

- (void)sendVoiceCodeAction:(UIButton *)btn {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    self.mobileString = _phoneTextField.textField.text;
    [self requestForVoiceCode];
}

//点击获取语音验证码
- (void)requestForVoiceCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SEND_VOICE_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobileString = _phoneTextField.textField.text;
    [params setObject:mobileString forKey:@"mobile"];
    /**
     *  成功返回
     {
     "error_code": 0,
     "v_code": "1212"
     }
     */
    //    if (![Util isNetWorkEnable]) {//先判断网络状态
    //        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
    //        return;
    //    }
    //    _countDownBtn.enabled = NO;
    //    [MBProgressHUD showHUD:nil];
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response:%@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        NSString *codeMessage = [response objectForKey:@"error_msg"];
        if (codeValue) { //失败返回
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        _countDownBtn.enabled = YES;
        NSInteger errorCode = [error code];
        DebugLog(@"errorCode = %ld", (long)errorCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

#pragma mark - 点击修改密码按钮
- (void)conformButtonAction {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (!_codeTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入验证码" hudMode:MBProgressHUDModeText];
        return;
        
    }
    if ([Util isNumberAndChar:_codeTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"验证码错误" hudMode:MBProgressHUDModeText];
        return;
    }
    
    if (!_passwordTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入密码" hudMode:MBProgressHUDModeText];
        return;
    }
    if (_passwordTextField.textField.text.length < PASSWORD_LIMITATION_SHORT || _passwordTextField.textField.text.length > PASSWORD_LIMITATION_LONG ) {
        [MBProgressHUD showHUDWithDuration:2.0 information:@"请输入长度为6-16位密码" hudMode:MBProgressHUDModeText];
        return;
    }
    [self requestForResetNewPassword];

}

//发送修改密码请求
- (void)requestForResetNewPassword {
    [self.view endEditing:YES];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_RESET_PASSWORD];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobileString = self.mobileString;
    NSString *passwordString = _passwordTextField.textField.text;
    NSString *codeString = _codeTextField.textField.text;
    [params setObject:mobileString forKey:@"mobile"];
    [params setObject:passwordString forKey:@"password"];
    [params setObject:codeString forKey:@"v_code"];
    
    /**
     *  成功返回
     {
     "error_code": 0,
     "v_code": "1212"
     }
     */
//    if (![Util isNetWorkEnable]) {//先判断网络状态
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
//        return;
//    }
//    _countDownBtn.enabled = NO;
//    [MBProgressHUD showHUD:nil];
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        NSString *codeMessage = [response objectForKey:@"error_msg"];
        if (codeValue) { //失败返回
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        [MBProgressHUD showHUDWithDuration:1.0 information:@"成功更改密码" hudMode:MBProgressHUDModeText];
        //成功返回 User信息本地存储
        User *user =[User mj_objectWithKeyValues:response[@"user"]];
        user.token = response[@"token"];
        //[[User alloc] initWithDicionary:response];
        [User saveUserInformation:user];
        
        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
        [JJCity saveCityArrayInformation:cityArray];
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
        DebugLog(@"修改密码成功%@",response);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoMainView];
        });
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        
    }];
    
}

//前往小海囤首页
-(void)gotoMainView {
//    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//触摸屏幕键盘弹下来
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTextField.textField endEditing:YES];
    [_passwordTextField.textField endEditing:YES];
}

#pragma mark  - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.passwordTextField.textField == textField) {
        if ([toBeString length] > PASSWORD_LIMITATION_LONG) {
            _passwordTextField.textField.text = [toBeString substringToIndex:PASSWORD_LIMITATION_LONG];
            return NO;
        }
    }
    
    if (self.phoneTextField.textField == textField) {
        
    }
    return YES;
}


- (void)dealloc {
    [self clearNotificationAndGesture];
}
@end
