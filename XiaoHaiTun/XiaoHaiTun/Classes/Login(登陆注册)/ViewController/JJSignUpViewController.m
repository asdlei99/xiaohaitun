//
//  JJSignUpViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/4.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSignUpViewController.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>
#import "JJInPutTextField.h"
#import "JKCountDownButton.h"
#import <ShareSDK/ShareSDK.h>
#import "Util.h"
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import "User.h"
//#import "JJUserInformationManager.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJAddInformationViewController.h"
//#import "MXNavigationBarManager.h"
#import "JJHobbyModel.h"
#import <MJExtension.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UINavigationBar+Awesome.h"
#import "XPWebView.h"
#import "JJUserProtocolViewController.h"
#import "JPUSHService.h"
#import "JJCity.h"


#define PASSWORD_LIMITATION_LONG      20
#define PASSWORD_LIMITATION_SHORT     6

typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeQQ = 0,
    LoginTypeWechat,
    LoginTypeWeibo
};

@interface JJSignUpViewController ()

/**-----------------------三方登陆的账号信息---------------------------------*/

@property (nonatomic, copy) NSString *infoID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *icon;

/**--------------------------------------------------------*/

//用户登陆Label
@property (nonatomic, strong)UILabel *titleLabel;

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

//注册按钮
@property (nonatomic, strong) UIButton *signUpBtn;

//用户协议
@property (nonatomic, strong) UIButton *userProtocolBtn;


//QQ登陆按钮
@property (nonatomic, strong) UIButton *QQBtn;

//微信登陆按钮
@property (nonatomic, strong) UIButton *WXBtn;

//微博登陆按钮
@property (nonatomic, strong) UIButton *WBBtn;


//以下为跳转到宝宝的爱好控制器所需的参数
//电话号码
@property (nonatomic, copy )NSString* mobile;

//验证码
@property (nonatomic, copy)NSString* v_code;

//密码
@property (nonatomic, copy)NSString* password;

//宝宝爱好模型数组
@property (nonatomic, strong) NSArray<JJHobbyModel *> *hobbyModelsArray;

@end

@implementation JJSignUpViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MXNavigationBarManager reStore];
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
    
//    //监听RAC
//    [self racObserve];
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
    [self.navigationController popViewControllerAnimated:YES];
    
}

//创建视图控件
- (void)setupViews {
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    //用户登陆Label
    [self.view addSubview:self.titleLabel];
    
    //手机号码
    [self.view addSubview:self.phoneTextField];
    
    //验证码
       [self.view addSubview:self.codeTextField];
  
    //密码
    [self.view addSubview:self.passwordTextField];
    
    //获取验证码按钮
    [self.view addSubview:self.countDownBtn];
    
    //获取验证码按钮左端竖线
    UIView *verticalLine = [[UIView alloc]init];
    [self.view addSubview:verticalLine];
    verticalLine.backgroundColor = RGB(238, 238, 238);
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.bottom.equalTo(self.codeTextField.mas_bottom);
        make.width.equalTo(@1);
        make.right.equalTo(self.countDownBtn.mas_left);
    }];
    
    
    
    //注册按钮
    self.signUpBtn = [[UIButton alloc]init];
    [self.view addSubview:_signUpBtn];
    [_signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_signUpBtn setBackgroundColor:NORMAL_COLOR];
    [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:4 andWidth:0];
    [_signUpBtn addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
    _signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(30);
        make.height.equalTo(@42);
    }];
    
    //发送语音验证码
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
        make.top.equalTo(self.signUpBtn.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
    }];
    [notReceiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(voiceBackView);
        make.right.equalTo(self.voiceBtn.mas_left);
    }];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(voiceBackView);
        
    }];
    
    
    UIView *protocolView = [[UIView alloc]init];
    [self.view addSubview:protocolView];
    [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(notReceiveLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *protocolLabel = [[UILabel alloc]init];
    [protocolLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"*注册即代表您同意" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentCenter];
    //用户许可协议按钮
    self.userProtocolBtn = [[UIButton alloc]init];
    [self.userProtocolBtn setTitle:@"<<用户服务协议>>" forState:UIControlStateNormal];
    [self.userProtocolBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [self.userProtocolBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [protocolView addSubview:self.userProtocolBtn];
    [protocolView addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(protocolView);
        make.right.equalTo(self.userProtocolBtn.mas_left);
    }];
    [self.userProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(protocolView);
    }];
    [self.userProtocolBtn addTarget:self action:@selector(pushToUserProtocol) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    //显示一些没用的展示View
    [self setupOtherView];
}

#pragma mark - 进入用户许可协议
- (void)pushToUserProtocol {
    JJUserProtocolViewController *userProtocolVC = [[JJUserProtocolViewController alloc]init];
    userProtocolVC.url = [NSString stringWithFormat:@"%@/service_agreement",DEVELOP_BASE_URL];
    [self.navigationController pushViewController:userProtocolVC animated:YES];
}

////监听手机号码
//- (void)racObserve {
//    [self.phoneTextField.textField.rac_textSignal subscribeNext:^(NSString x) {
//        
//    } ];
//}

#pragma mark - QQ微信微博三方登陆事件

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
            DebugLog(@"infoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            self.infoID = infoId;
            self.nickName = nickName;
            self.icon = icon;
            [self thirtyPartyLoginWithType:LoginTypeQQ];
        }];
    } else if (type == LoginTypeWechat) {
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            NSString *infoId = user.uid;//用户标识
            NSString *nickName = user.nickname; //昵称
            NSString *icon = user.icon;//头像
            NSString *token = user.credential.token;//用户令牌
            DebugLog(@"infoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
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
            NSString *token = user.credential.token;//用户令牌
            DebugLog(@"infoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            DebugLog(@"infoId: %@ nickName:%@ icon:%@ token:%@", infoId, nickName, icon, token);
            self.infoID = infoId;
            self.nickName = nickName;
            self.icon = icon;
            [self thirtyPartyLoginWithType:LoginTypeWeibo];
        }];
    }

}

// 第三方登录
- (void)thirtyPartyLoginWithType:(LoginType)type {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_OTHER_SIGNUP];
    DebugLog(@"URL = %@", URL);
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
    DebugLog(@"thirty_params:%@", params);
    /**
     成功返回
     {
     "error_code": 0,
     "token": "xxasdfadfasdfasdfasdfafasdfxxxx",
     "user": {
     "user_id": 1001,
     "nickname": "rockl2e",
     "moblie": "121212129",
     "gender": 1,
     "birthday": "20011001",
     "avatar": "http://asdfasdfasdfasdfasdf.jpg",
     "is_bind_mobile": 1
     }
     }
     
     失败返回
     {
     "error_code": 1,
     "error_msg": "请填入微信unionid或微博uid活qquid",
     }
     */
//    if (![Util isNetWorkEnable]) {//先判断网络状态
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"网络连接不可用" hudMode:MBProgressHUDModeText];
//        return;
//    }
//    [MBProgressHUD showHUD:nil];
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        DebugLog(@"%@",response);
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
                
    } fail:^(NSError *error) {
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}
-(void)gotoMainView {
    DebugLog(@"%@",self.tabBarController);
    [self dismissViewControllerAnimated:YES completion:^{
        
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

#pragma mark - 验证码按钮点击
- (void)sendCodeAction:(UIButton *)button {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    [self requestForVerifyCode];
}

//点击获取验证码
- (void)requestForVerifyCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SEND_V_CODE];
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
//        _countDownBtn.enabled = YES;
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

- (void)sendVoiceCodeAction:(UIButton *)btn {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
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


#pragma mark - 点击注册按钮
- (void)signUpAction {
    if (!_phoneTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:_phoneTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (!_codeTextField.textField.text.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入验证码" hudMode:MBProgressHUDModeText];
        return;
        
    }
    
    if ([Util isNumberAndChar:_codeTextField.textField.text]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"验证码错误" hudMode:MBProgressHUDModeText];
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
    
    //发出校验验证码请求
    [self requestToCheckCode];
}

//发出校验验证码请求
- (void)requestToCheckCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHECK_V_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneTextField.textField.text forKey:@"mobile"];
//    [params setObject:self.passwordTextField.textField.text forKey:@"password"];
    [params setObject:self.codeTextField.textField.text forKey:@"v_code"];
    
    [HFNetWork postWithURL:URL params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            NSString *result = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            DebugLog(@"result:%@", result);
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        NSInteger userStatus = [[response objectForKey:@"user_status"]integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        if(userStatus == 1) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"该号码已经注册过!" hudMode:MBProgressHUDModeText];
            return ;
        }
        //爱好数组
       self.hobbyModelsArray = [JJHobbyModel mj_objectArrayWithKeyValuesArray:response[@"hobbys"]];
        
        DebugLog(@"%@",response);
        //前往宝宝的爱好页面
        [self gotoAddInformation];
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errorCode = [error code];
        DebugLog(@"errorCode == %ld", (long)errorCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];

}


//前往宝宝的爱好页面
- (void)gotoAddInformation {
    JJAddInformationViewController *addInformationViewController = [[JJAddInformationViewController alloc]init];
    //手机号码
    self.mobile = self.phoneTextField.textField.text;
    //密码
    self.password = self.passwordTextField.textField.text;
    //验证码
    self.v_code = self.codeTextField.textField.text;
    
    
    addInformationViewController.mobile = self.phoneTextField.textField.text;
    addInformationViewController.password = self.passwordTextField.textField.text;
    addInformationViewController.v_code = self.codeTextField.textField.text;
   
    addInformationViewController.hobbyModelsArray = self.hobbyModelsArray;
    
    [self.navigationController pushViewController:addInformationViewController animated:YES];
}

//触摸屏幕键盘弹下来
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTextField.textField endEditing:YES];
    [_codeTextField.textField endEditing:YES];
    [_passwordTextField.textField endEditing:YES];
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
//titleLabel
- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        [self.view addSubview:_titleLabel];
        [_titleLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:24] text:@"新用户注册" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _titleLabel.frame = CGRectMake(0, 69 * KHEIGHT_IPHONE6_SCALE, SCREEN_WIDTH, 33);
    }
    return _titleLabel;
}

- (JJInPutTextField *)phoneTextField {
    if(!_phoneTextField) {
        _phoneTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(14, 139, SCREEN_WIDTH - 14, 33) WithPlaceholder:@"手机号码" delegate:self];
        [self.view addSubview:_phoneTextField];
        _phoneTextField.textField.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _phoneTextField;
}


//验证码textField
- (JJInPutTextField *)codeTextField {
    if(!_codeTextField) {
        _codeTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"验证码" delegate:self];
        [self.view addSubview:_codeTextField];
        _codeTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.left.equalTo(self.view).with.offset(14);
            make.top.equalTo(self.phoneTextField.mas_bottom).with.offset(14);
            make.height.equalTo(@33);
        }];
    }
    return _codeTextField;
}


//验证码按钮
- (JKCountDownButton *)countDownBtn {
    if(!_countDownBtn) {
        _countDownBtn = [[JKCountDownButton alloc]init];
        [self.view addSubview:_countDownBtn];
        [_countDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        //    _countDownBtn.backgroundColor = [UIColor greenColor];
        [_countDownBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        _countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_countDownBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            if (!self.phoneTextField.textField.text.length) {
                [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
                return;
            }else if (![Util isMobileNumber:self.phoneTextField.textField.text]) {
                [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
                return;
            }
            
            sender.enabled = NO;
            [self.codeTextField.textField becomeFirstResponder];
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
            }];
        }];
        [_countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTextField.mas_bottom);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.codeTextField);
            make.width.equalTo(@92);
            
        }];
    }
    return _countDownBtn;
}


//密码textField
- (JJInPutTextField *)passwordTextField {
    if(!_passwordTextField) {
        _passwordTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 33) WithPlaceholder:@"请设置6-20位登录密码" delegate:self];
        _passwordTextField.eyeBtn.hidden = NO;
        [self.view addSubview:_passwordTextField];
        _passwordTextField.textField.secureTextEntry = YES;
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.left.equalTo(self.view).with.offset(14);
            make.top.equalTo(_codeTextField.mas_bottom).with.offset(14);
            make.height.equalTo(@33);
        }];
    }
    return _passwordTextField;
}
- (void)setupOtherView {
    //快速登陆label
    UILabel* quickLabel = [[UILabel alloc]init];
    [self.view addSubview:quickLabel];
    [quickLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"快速登录" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentCenter];
    [quickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_QQBtn.mas_top).with.offset(-(30 * KHEIGHT_IPHONE6_SCALE));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@17);
    }];
    
    //左端线条
    UIView * leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = RGBA(238, 238, 238, 1);
    [self.view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12);
        make.right.equalTo(quickLabel.mas_left).with.offset(-12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];
    
    //右端线条
    UIView * rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = RGBA(238, 238, 238, 1);
    [self.view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-12);
        make.left.equalTo(quickLabel.mas_right).with.offset(12);
        make.height.equalTo(@1);
        make.centerY.equalTo(quickLabel.mas_centerY);
    }];
    

}
@end
