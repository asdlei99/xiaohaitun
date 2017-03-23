//
//  JJLoginViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLoginViewController.h"
//#import "MXNavigationBarManager.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>
#import "JJInPutTextField.h"
#import "JJSignUpViewController.h"
#import "JJForgetPasswordViewController.h"
#import "ZYKeyboardUtil.h"
#import <ShareSDK/ShareSDK.h>
#import "Util.h"
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import "User.h"
//#import "JJUserInformationManager.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJCity.h"
#import "JJTabBarController.h"
#import "UINavigationBar+Awesome.h"
#import "JPUSHService.h"

#define PASSWORD_LIMITATION_LONG      20
#define PASSWORD_LIMITATION_SHORT     6
//#define MOBILE_LIMITATION             11


typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeQQ = 0,
    LoginTypeWechat,
    LoginTypeWeibo
};

@interface JJLoginViewController ()<UITextFieldDelegate>

/**---------------------三方登陆的账号息---------------------------------*/

@property (nonatomic, copy) NSString *infoID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *icon;
@property(nonatomic,assign) NSNumber *gender;

/**--------------------------------------------------------*/

@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;

@property (nonatomic, strong) UIView *backView;


//手机号码
@property (nonatomic, strong)JJInPutTextField * phoneTextField;
//密码
@property (nonatomic, strong)JJInPutTextField * passwordTextField;

//登陆按钮
@property (nonatomic, strong) UIButton *logInBtn;

//注册按钮
@property (nonatomic, strong) UIButton *signUpBtn;

//忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBtn;

//QQ登陆按钮
@property (nonatomic, strong) UIButton *QQBtn;

//微信登陆按钮
@property (nonatomic, strong) UIButton *WXBtn;

//微博登陆按钮
@property (nonatomic, strong) UIButton *WBBtn;


@end

@implementation JJLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航条内容
    [self setupNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MXNavigationBarManager reStore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //创建视图控件
    [self setupViews];
    
}

//设置导航条内容
- (void)setupNavigationBar {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:NORMAL_COLOR];
    //required
//    [MXNavigationBarManager saveWithController:self];
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//    [MXNavigationBarManager setTintColor:NORMAL_COLOR];
}

- (void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图控件
- (void)setupViews {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    //底层backView
    UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.backView = backView;
//    backView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backView];
    
    //用户登陆Label
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] text:@"用户登录" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 69 * KHEIGHT_IPHONE6_SCALE, SCREEN_WIDTH, 33);
    [backView addSubview:titleLabel];
    
    //手机号码
    self.phoneTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(14, 139, SCREEN_WIDTH - 14, 33) WithPlaceholder:@"手机号码" delegate:self];
    _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:_phoneTextField];
    
    //密码
    self.passwordTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"密码" delegate:self];
    self.passwordTextField.eyeBtn.hidden = NO;
    self.passwordTextField.textField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.textField.secureTextEntry = YES;
    [backView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(_phoneTextField.mas_bottom).with.offset(14);
        make.height.equalTo(@33);
    }];
    
    //登陆按钮
    self.logInBtn = [[UIButton alloc]init];
    [backView addSubview:_logInBtn];
    [_logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_logInBtn setBackgroundColor:NORMAL_COLOR];
    [_logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logInBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_logInBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:0];
     _logInBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(30);
        make.height.equalTo(@42);
    }];
    
    //注册按钮
    self.signUpBtn = [[UIButton alloc]init];
    [backView addSubview:_signUpBtn];
    [_signUpBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_signUpBtn setBackgroundColor:[UIColor whiteColor]];
    [_signUpBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [_signUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [_signUpBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:1];
    _signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(_logInBtn.mas_bottom).with.offset(12);
        make.height.equalTo(@42);
    }];
    
    //忘记密码按钮
    self.forgetBtn = [[UIButton alloc]init];
    [backView addSubview:_forgetBtn];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_forgetBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signUpBtn);
        make.top.equalTo(_signUpBtn.mas_bottom).with.offset(12);
        make.height.equalTo(@20);
    }];
    
    //QQ按钮
    self.QQBtn = [[UIButton alloc]init];
    [self.QQBtn setBackgroundImage:[UIImage imageNamed:@"Oval_QQ"] forState:UIControlStateNormal];
    [self.QQBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.QQBtn addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QQBtn];
    
    //微信按钮
    self.WXBtn = [[UIButton alloc]init];
    [self.WXBtn setBackgroundImage:[UIImage imageNamed:@"Oval_WX"] forState:UIControlStateNormal];
    [self.WXBtn setImage:[UIImage imageNamed:@"WX"] forState:UIControlStateNormal];
    [self.WXBtn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.WXBtn];
    
    //微博按钮
    self.WBBtn = [[UIButton alloc]init];
    [self.WBBtn setBackgroundImage:[UIImage imageNamed:@"Oval_WB"] forState:UIControlStateNormal];
    [self.WBBtn setImage:[UIImage imageNamed:@"WB"] forState:UIControlStateNormal];
    [self.WBBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.WBBtn];
    
    CGFloat space = (SCREEN_WIDTH - (50 * 2))/3;
    [self.WXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
//        make.right.equalTo(self.WXBtn.mas_left).with.offset(50);
        make.left.equalTo(self.view).with.offset(space);
    }];
    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
        make.right.equalTo(self.view).with.offset(-space);
//        make.centerX.equalTo(self.view.mas_centerX);
    }];
//    [self.WBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@50);
//        make.height.equalTo(@50);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 58 * KHEIGHT_IPHONE6_SCALE);
//        //        make.right.equalTo(self.WXBtn.mas_left).with.offset(50);
//        make.right.equalTo(self.view).with.offset(-space);
//    }];

    
    //快速登陆label
    UILabel* quickLabel = [[UILabel alloc]init];
    [backView addSubview:quickLabel];
    [quickLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"快速登录" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentCenter];
    [quickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_QQBtn.mas_top).with.offset(-(30 * KHEIGHT_IPHONE6_SCALE));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@17);
    }];
    
    //左端线条
    UIView * leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = RGBA(238, 238, 238, 1);
    [backView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12);
        make.right.equalTo(quickLabel.mas_left).with.offset(-12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];
    
    //右端线条
    UIView * rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = RGBA(238, 238, 238, 1);
    [backView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12);
        make.left.equalTo(quickLabel.mas_right).with.offset(12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];

    
}


//QQ登录
- (void)QQLogin {
    [self loginWithType:LoginTypeQQ];
}

//微信登录
- (void)wechatLogin {
    [self loginWithType:LoginTypeWechat];
}

//微博登录
- (void)weiboLogin {
    [self loginWithType:LoginTypeWeibo];
}


- (void)loginWithType:(LoginType)type {
    if (type == LoginTypeQQ) {
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            NSString *infoId = user.uid;//用户标识
            NSString *nickName = user.nickname; //昵称
            NSString *icon = user.icon;//头像
            NSString *token = user.credential.token;//用户令牌
            DebugLog(@"xxtiQQnfoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            self.gender = @(user.gender + 1);
            self.infoID = infoId;
            self.nickName = nickName;
            self.icon = icon;
            NSDictionary *rawData = user.rawData;
            if (rawData  && [rawData isKindOfClass:[NSDictionary  class]]) {
                self.icon = [rawData objectForKey:@"figureurl_qq_2"]; //QQ 头像
                DebugLog(@"xxtself.icon = %@", self.icon);
            }

            [self thirtyPartyLoginWithType:LoginTypeQQ];
        }];
    } else if (type == LoginTypeWechat) {
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            
            
            NSString *infoId = user.uid;//用户标识
            NSString *nickName = user.nickname; //昵称
            NSString *icon = user.icon;//头像
            NSString *token = user.credential.token;//用户令牌
            DebugLog(@"xxtWXuser:%@   error:%@   infoId: %@ nickName:%@ icon:%@ token:%@",user,error, infoId, nickName, icon, token);
            self.gender = @(user.gender + 1);
            self.infoID = infoId;
            self.nickName = nickName;
            self.icon = icon;
            [self thirtyPartyLoginWithType:LoginTypeWechat];
        }];
        
    } else if (type == LoginTypeWeibo) {
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            NSString *infoId = [NSString stringWithFormat:@"%@", user.uid];//用户标识
            NSString *nickName = [NSString stringWithFormat:@"%@", user.nickname]; //昵称
            NSString *icon = [NSString stringWithFormat:@"%@", user.icon];//头像
            SSDKGender gender = user.gender;
            self.gender = @(user.gender + 1);
            NSString *token = user.credential.token;//用户令牌
            DebugLog(@"xxtWBinfoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            DebugLog(@"WBinfoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            self.infoID = infoId;
            self.nickName = nickName;
            self.icon = icon;
            self.gender = @(gender + 1);
            [self thirtyPartyLoginWithType:LoginTypeWeibo];
        }];
    }
}


// 第三方登录
- (void)thirtyPartyLoginWithType:(LoginType)type {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_OTHER_SIGNUP];
    DebugLog(@"xxt第三方URL = %@", URL);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.infoID.length) {
        if (type == LoginTypeQQ) {
            [params setObject:self.infoID forKey:@"qq_uid"];
        } else if (type == LoginTypeWechat) {
            [params setObject:self.infoID forKey:@"wx_unionid"];
        } else if (type == LoginTypeWeibo) {
            [params setObject:self.infoID forKey:@"weibo_uid"];
        }
    }
    if (self.nickName.length) {
        [params setObject:self.nickName forKey:@"nickname"];
    }
    if (self.icon.length) {
        [params setObject:self.icon forKey:@"avatar"];
    }
    [params setObject:self.gender forKey:@"gender"];
    
    DebugLog(@"%@",params);
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"xxt第三方response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        //登录成功
        User *user =[User mj_objectWithKeyValues:response[@"user"]];
        user.token = response[@"token"];
        [User saveUserInformation:user];
        //注册极光
        [self networkDidSetup];
        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
        [JJCity saveCityArrayInformation:cityArray];
        DebugLog(@"%ld",user.baby_birthday);
        //        [NSDate dateWithTimeIntervalSince1970:user.birthday];
        //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>];
        //发出通知
        DebugLog(@"xxt登陆成功%@",response);
        //前往小海囤首页
        [self gotoMainView];
        //成功加载
        //登录成功 ，user信息本地化
//        User *user = [[User alloc] initWithDicionary:response];
//        [JJUserInformationManager saveUserInformation:user];
//        
//        //isBindMobile = 1 需要验证手机   isBindMobile = 2 不需要验证手机
//        NSInteger isBindMobile = [[[response objectForKey:@"user"] objectForKey:@"is_bind_mobile"] integerValue];
//        if (isBindMobile == 1) { //跳转到手机完善信息页面
//            DebugLog(@"isBindMobile == %ld", isBindMobile);
//            BindMobileViewController *bindMobileVC = [[BindMobileViewController alloc] init];
//            bindMobileVC.thirtyAvater = self.icon;
//            bindMobileVC.thirtyNickName = self.nickName;
//            [self.navigationController pushViewController:bindMobileVC animated:YES];
//            
//        } else if (isBindMobile == 2) { //登录成功 直接进主页
//            DebugLog(@"isBindMobile == %ld", isBindMobile);
//            [self gotoMainView];
//        }
        
    } fail:^(NSError *error) {
        NSInteger errCode = [error code];
        DebugLog(@"xxt第三方errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}


#pragma mark -- 极光推送回调方法
- (void)networkDidSetup
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@", user.userId] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"极光推送错误码+++++++：%d", iResCode);
        
        if (iResCode == 0) {
            NSLog(@"极光推送：设置别名成功, 别名：%@", user.userId);
        }
    }];
}

//点击登陆按钮
- (void)loginAction {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号"hudMode:MBProgressHUDModeText];
        return;
    }
    
    if (!_passwordTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入密码" hudMode:MBProgressHUDModeText];
        return;
    }
    if (_passwordTextField.textField.text.length < PASSWORD_LIMITATION_SHORT || _passwordTextField.textField.text.length > PASSWORD_LIMITATION_LONG ) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入长度为6-16位密码" hudMode:MBProgressHUDModeText];
        return;
        
    }
    [self requestToLogin];
    
}

//手机号登录
- (void)requestToLogin {
    [self.view endEditing:YES];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_LOGIN];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneTextField.textField.text forKey:@"mobile"];
    [params setObject:_passwordTextField.textField.text forKey:@"password"];
    /**
     成功返回
     {
     "error_code": 0,
     "token": "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
     "city": [{
     "id": 1,
     "name": "北京",
     },
     ……………………...
     ],
     "user": [
     "id": 12,
     "username": "蓝求",
     "nickname": "张三",
     "gender": 1,
     "birthday": 111212134343,
     "avatar": "http://adf2212sss.jgp",
     "baby_gender": 1,
     "city": 1,
     "baby_name":"宝宝",
     "baby_gender": 1,
     "baby_birthday": 123412341234123,
     "mobile":1852222222,
     "balance":12,
     ],
     }
     失败返回
     {
     "error_code":1,
     "error_msg":"账号密码错误",
     }
     */
     //    if (![Util isNetWorkEnable]) {//先判断网络状态
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
//        return;
//    }
//    [MBProgressHUD showHUD:nil];
//    _logInBtn.enabled = NO;
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
//        _logInBtn.enabled = YES;
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //登录失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        //登录成功
        User *user =[User mj_objectWithKeyValues:response[@"user"]];
        user.token = response[@"token"];
        [User saveUserInformation:user];
        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
        [JJCity saveCityArrayInformation:cityArray];
        DebugLog(@"%ld",user.baby_birthday);
//        [NSDate dateWithTimeIntervalSince1970:user.birthday];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>];
        //发出通知
        DebugLog(@"登陆成功%@",response);
        //前往小海囤首页
        [self gotoMainView];
        //发出加入购物车通知
        [[NSNotificationCenter defaultCenter]postNotificationName:ShopCartNotification object:nil];
    
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
//        _logInBtn.enabled = YES;
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        
    }];
    
}

-(void)gotoMainView {
    DebugLog(@"%@",self.tabBarController);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tabBarController setSelectedIndex:0];
//    });
    
}

- (void)dealloc{
    DebugLog(@"销毁了");
}
//进入注册界面
- (void)signUp {
    JJSignUpViewController *signUpViewController = [[JJSignUpViewController alloc]init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

//进入忘记密码界面
- (void)forgetPassword {
    JJForgetPasswordViewController *forgetPasswordViewController = [[JJForgetPasswordViewController alloc]init];
     [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}




//触摸屏幕键盘弹下来
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTextField.textField resignFirstResponder];
    [_passwordTextField.textField resignFirstResponder];
}

#pragma mark UITextFieldDelegate
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


#pragma mark - 懒加载

@end
