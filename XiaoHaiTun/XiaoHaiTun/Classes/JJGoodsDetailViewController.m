//
//  JJGoodsDetailViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJGoodsDetailViewController.h"
#import "UIBarButtonItem+Fast.h"
#import "JJGoodsDetailBottomMenu.h"
#import <ReactiveCocoa.h>
#import "JJGoodsOrderConfirmViewController.h"
#import "User.h"
#import "HFNetWork.h"
#import <MJExtension.h>
#import "MBProgressHUD+gifHUD.h"
#import "XPWebView.h"
//#import "MXNavigationBarManager.h"
#import "UIViewController+ModelLogin.h"
#import "JJTabBarController.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import "UINavigationBar+Awesome.h"
#import "Pingpp.h"
#import "Util.h"
#import "JJPaySuccessViewController.h"
#import "UIStoryboard+JJEasyCreate.h"
#import "UIViewController+Alert.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "JJShopCarCellModel.h"

@interface JJGoodsDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
//webView
@property (nonatomic, strong) XPWebView *webView;

//菜单栏
//@property (nonatomic, strong) JJGoodsDetailBottomMenu *bookView;

//客服
@property (nonatomic, strong) UIButton *servicePeopleBtn;

//收藏按钮
@property (nonatomic, strong)  UIBarButtonItem *collectButton;
//@property(nonatomic,assign)BOOL collectBtnIsSelected;
//分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareButton;
//当前webView网页地址的URL
//@property (nonatomic, copy) NSString *webViewurl;

//@property (strong, nonatomic) JSContext *context;

@end

@implementation JJGoodsDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    NSLog(@"%s",__func__);
}
- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self basicSet];
    
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    if ([User getUserInformation]) {
        [self goodsIsCollectRequest];
    }
    // Do any additional setup after loading the view.
}

//创建基本视图
- (void)initBaseView {
    [self createWebView];
    [self createMenuView];
}
//创建webView
- (void)createWebView {
    self.webView = [[XPWebView alloc]init];
    //    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    //    self.webView.backgroundColor = [UIColor redColor];
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/goods/%@",DEVELOP_BASE_URL,self.goodsID]]]];
    self.webView.remoteUrl = [NSString stringWithFormat:@"%@/h5/goods/%@",DEVELOP_BASE_URL,self.goodsID];
    //    [self.webView setRemoteUrl:[NSString stringWithFormat:@"http://orange.dev.attackt.com/h5/goods/%@",self.goodsID]];
    DebugLog(@"%@",[NSString stringWithFormat:@"%@/h5/goods/%@",DEVELOP_BASE_URL,self.goodsID]);
    self.webView.delegate = self;
    
}
//创建底部菜单栏
- (void)createMenuView {
    @weakify(self)
    //    self.bookView = [JJGoodsDetailBottomMenu goodsDetailBottomMenu];
    //    //立即下单按钮点击
    //    [[self.bookView.bookNowButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
    //        @strongify(self);
    //        JJGoodsOrderConfirmViewController *goodsOrderConfirmViewController = [[JJGoodsOrderConfirmViewController alloc]init];
    //        [self.navigationController pushViewController:goodsOrderConfirmViewController animated:YES];
    //    }];
    //    //购物车按钮点击
    //    [[self.bookView.shopCartButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
    //        @strongify(self);
    //        [self.tabBarController setSelectedIndex:2];
    //        [self.navigationController popToRootViewControllerAnimated:NO];
    //    }];
    //    //首页按钮点击
    //    [[self.bookView.homeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
    //        @strongify(self);
    //        [self.tabBarController setSelectedIndex:0];
    //        [self.navigationController popToRootViewControllerAnimated:NO];
    //    }];
    //
    //    [self.view addSubview:self.bookView];
    //    [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.bottom.right.equalTo(self.view);
    //        make.height.equalTo(@49);
    //    }];
    //    [self.bookView.joinShopCart addTarget:self action:@selector(joinShopCart:) forControlEvents:UIControlEventTouchUpInside];
    
    //客服
    self.servicePeopleBtn = [[UIButton alloc]init];
    self.servicePeopleBtn.hidden = YES;
    [self.servicePeopleBtn setImage:[UIImage imageNamed:@"Service_People"] forState:UIControlStateNormal];
    [self.view addSubview:self.servicePeopleBtn];
    [self.servicePeopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.view).with.offset(-59 + 30 *KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@(46 * KWIDTH_IPHONE6_SCALE));
    }];
    
}



//基本设置
- (void)basicSet {
    //    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //    //收藏
    //    UIBarButtonItem *collectBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Collect_White"] style:UIBarButtonItemStylePlain target:self action:@selector(collectBtnClick:)];
    //    NSLog(@"%@",collectBtn.customView);
    ////    [collectBtn ]
    //
    //    //分享
    //    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Share_White"] style:UIBarButtonItemStylePlain target:self action:@selector(collectBtnClick:)];
    
    // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
    //    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Nav_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIBarButtonItem *collectButton = [UIBarButtonItem itemImage:@"Nav_Collect_White" highlightedImage:@"Nav_Collect_Highlighted" target:self action:@selector(collectBtnClick:)];
    self.collectButton = collectButton;
    collectButton.customView.width = 30;
    UIButton *collectBtn = collectButton.customView;
    [collectBtn setImage:[UIImage imageNamed:@"Nav_Collect_Highlighted"] forState:UIControlStateSelected];
    //    collectBtn.selected = self.model.is_collect;
    
    UIBarButtonItem *shareButton = [UIBarButtonItem itemImage:@"Nav_Share_White" highlightedImage:@"Nav_Share_White" target:self action:@selector(shareBtnClick:)];
    self.shareButton = shareButton;
    shareButton.customView.width = 30;
    
    self.navigationItem.rightBarButtonItems = @[shareButton,collectButton];
}
//#pragma mark - 重写leftBarButtonItem触发方法(webVIew内部返回)
//- (void)back {
////    if(![self.webView canGoBack]) {
////        [self.navigationController popViewControllerAnimated:YES];
////    } else {
////        [self.webView goBack];
////    }
////    NSRange range ;
////    NSString *suffix = nil;
////    if([self.webView.request.URL.absoluteString hasPrefix:@"http://orange.dev.attackt.com/h5/goods/"]) {
////        range = [self.webView.request.URL.absoluteString rangeOfString:@"http://orange.dev.attackt.com/h5/goods/"];
////        suffix = [self.webView.request.URL.absoluteString substringFromIndex:range.length];
////    }
////
////
////
////    if(([self.webViewurl hasPrefix:@"http://orange.dev.attackt.com/h5/goods/"] && [self ismathNumberWithString:suffix]) || ([self.webView.request.URL.absoluteString hasPrefix:@"http://orange.dev.attackt.com/h5/goods/"]  && [self.webViewurl hasSuffix:@"#"])) {
////        [self.navigationController popViewControllerAnimated:YES];
////        return;
////    }else if([self.webView canGoBack]){
////        [self.webView goBack];
////        return;
////    }
//    if(![self isGoodsDetail] && [self.webView canGoBack]) {
//        [self.webView goBack];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//
//}

////判断当前是否为商品详情页
//- (BOOL)isGoodsDetail {//http://orange.dev.attackt.com/h5/goods/35  或http://orange.dev.attackt.com/h5/goods/35#
//    NSRange range ;
//    NSString *suffix = nil;
//    if([self.webView.request.URL.absoluteString hasPrefix:@"http://orange.dev.attackt.com/h5/goods/"]) {
//        range = [self.webView.request.URL.absoluteString rangeOfString:@"http://orange.dev.attackt.com/h5/goods/"];
//        suffix = [self.webView.request.URL.absoluteString substringFromIndex:range.length];
//
//        if([self.webView.request.URL.absoluteString hasSuffix:@"#"]) {
//            NSString *suffix2 = [suffix substringToIndex:suffix.length-1];
//            if([self ismathNumberWithString:suffix2]) {
//                return YES;
//            }
//        }
//
//        if([self ismathNumberWithString:suffix]) {
//            return YES;
//        } else {
//            return NO;
//        }
//
//    }
//
//
//
//    return NO;
//}

//判断一个字符串是否是纯数字
- (BOOL)ismathNumberWithString:(NSString *)string {
    NSString *mystring = string;
    NSString *regex = @"^[0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:mystring] == YES) {
        //implement
    }
    return [predicate evaluateWithObject:mystring];
}

#pragma mark - 收藏及分享

- (void)goodsIsCollectRequest {
    NSDictionary * params = nil;
    params = @{@"goods_id" : self.goodsID , @"user_id" : [User getUserInformation].userId};
    //发送收藏活动请求
    NSString * isCollectGoodsRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ISCOLLECT_GOODS];
    [HFNetWork postWithURL:isCollectGoodsRequesturl params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        
        UIButton *collectBtn = self.collectButton.customView;
        NSNumber *isCollect = response[@"is_collect"];
        BOOL isCollectBool = isCollect.boolValue;
        collectBtn.selected = isCollectBool;
        //        self.collectBtnIsSelected = isCollectBool;
        
    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}

#pragma mark - 按钮点击事件

//收藏商品
- (void)collectBtnClick:(UIButton *)btn{
    //未登录时
    if(![User getUserInformation]) {
        [self modelToLoginVC];
        return;
    }
    
    UIButton *collectBtn = self.collectButton.customView;
    NSDictionary * params = nil;
    //若已经收藏
    if(collectBtn.selected) {
        if([User getUserInformation]){
            params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.goodsID , @"action_id" : @2 };
        }else{
            params = @{@"item_id" : self.goodsID , @"action_id" : @2 };
        }
        
    }else{//若未收藏
        if([User getUserInformation]){
            params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.goodsID , @"action_id" : @1 };
        }else{
            params = @{ @"item_id" : self.goodsID , @"action_id" : @1 };
        }
    }
    
    //发送收藏商品请求
    NSString * addCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_COLLECT_EDIT];
    [HFNetWork postWithURL:addCartRequesturl params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        //若已经收藏
        if(collectBtn.selected) {
            [MBProgressHUD showHUDWithDuration:1.0 information:@"取消收藏成功" hudMode:MBProgressHUDModeText];
        }else{//若未收藏
            [MBProgressHUD showHUDWithDuration:1.0 information:@"添加收藏成功" hudMode:MBProgressHUDModeText];
        }
        UIButton *collectBtn = self.collectButton.customView;
        //        NSLog(@"%ld",collectBtn.selected);
        collectBtn.selected = !collectBtn.selected;
        //        self.collectBtnIsSelected = collectBtn.selected;
        //        self.model.is_collect = !self.model.is_collect;
        //        NSLog(@"%ld",collectBtn.selected);
        
    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

- (void)shareBtnClick:(UIButton *)btn{
    
    //1、创建分享参数
    NSArray* imageArray = @[self.picture];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //        NSLog(@"%@ ",self.name);
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/goods/%@",DEVELOP_BASE_URL,self.goodsID]]
                                          title:self.name
                                           type:SSDKContentTypeAuto];
        //        // 定制新浪微博的分享内容
        //        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容" title:self.model.name image:self.model.picture url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        //         //定制微信好友的分享内容
        //        [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:self.model.name url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:self.model.picture musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        //        [shareParams SSDKSetupQQParamsByText:@"定制QQ分享内容" title:self.model.name url:nil thumbImage:nil image:self.model.picture type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];//QQ好友
        
        
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[/*@(SSDKPlatformTypeSinaWeibo),*/@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}

//#pragma mark - UIWebViewDelegate  JSExport Methods
//UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSLog(@" %s  %@",__func__,webView.request.URL.absoluteString);
////    self.webViewurl = webView.request.URL.absoluteString;
////    if([self isGoodsDetail]){
////        self.collectButton.customView.hidden = NO;
////        self.shareButton.customView.hidden = NO;
////    }else{
////        self.collectButton.customView.hidden = YES;
////        self.shareButton.customView.hidden = YES;
////    }
////    self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    NSLog(@"%p",self.context);
////    self.context[@"androidObj"] = self;
//
//}
//
//
//
////1.开始加载的时候调用
//-(void)webViewDidStartLoad:(UIWebView *)webView
//{
//    NSLog(@" %s  %@",__func__,webView.request.URL.absoluteString);
//    JSContext *context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSLog(@"%p",self.context);
//    context[@"androidObj"] = self;
////    NSLog(@"webViewDidStartLoad");
////    JSContext *context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    NSLog(@"%p",self.context);
////    context[@"iosObj"] = self;
////    NSLog(@"%s   %@",__func__,webView.request.URL.absoluteString);
//
//}
//
////每次加载请求的时候会先带哟
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSLog(@" %s  %@",__func__,webView.request.URL.absoluteString);
////    self.context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    NSLog(@"%p",self.context);
////    self.context[@"androidObj"] = self;
////    NSLog(@" %s  %@",__func__,webView.request.URL.absoluteString);
////    if (self.context == nil){
////    JSContext *context =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    NSLog(@"%p",self.context);
////    context[@"androidObj"] = self;
//
//    return YES;
//}

#pragma mark - GoodsDetailJSExport
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    //    ctx[@"sayHello"] = ^{
    //
    //        dispatch_async( dispatch_get_main_queue(), ^{
    //
    //            UIAlertView* av = [[UIAlertView alloc] initWithTitle: @"Hello, World!"
    //                                                         message: nil
    //                                                        delegate: nil
    //                                               cancelButtonTitle: @"OK"
    //                                               otherButtonTitles: nil];
    //
    //            [av show];
    //        });
    //    };
    
    ctx[@"androidObj"] = self;
}

- (void)confirmOrderWithGoodsID:(NSString *)goodsID goodsSkuID:(NSString *)goodsSkuID num:(NSString *)number userID:(NSString *)userID{
    //未登录时
    if(![User getUserInformation]) {
        [self modelToLoginVC];
        return;
    }
    DebugLog(@"goodid:%@ goodskuid:%@ number:%@ userID",goodsID,goodsSkuID,number,userID);
    //发送获取下单商品信息请求
    NSString * getOrderGoodsURL = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_GET_ORDER_GOODS];
    NSDictionary *params = @{@"goods_id" : goodsID , @"goods_sku_id" : goodsSkuID , @"number" : number };
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [HFNetWork postWithURL:getOrderGoodsURL params:params success:^(id response) {
            [MBProgressHUD hideHUD];
            if (![response isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
            if (codeValue) {
                NSString *codeMessage = [response objectForKey:@"error_msg"];
                [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
                return ;
            }
            NSArray<JJShopCarCellModel *> *modelArray = [JJShopCarCellModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            JJGoodsOrderConfirmViewController *goodsOrderConfirmVC = [[JJGoodsOrderConfirmViewController alloc]init];
            goodsOrderConfirmVC.selectedModelArray = modelArray;
            
            for(JJShopCarCellModel *model in modelArray) {
                model.goods_sku_id = goodsSkuID;
                goodsOrderConfirmVC.allPayMoney = goodsOrderConfirmVC.allPayMoney + model.price * model.number;
            }
            [self.navigationController pushViewController:goodsOrderConfirmVC animated:YES];
            
        } fail:^(NSError *error) {
            //        [self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUD];
            NSInteger errCode = [error code];
            DebugLog(@"errCode = %ld", errCode);
            [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        }];
        
        
    });
    
    
}

//返回首页
- (void)backToMain {
    DebugLog(@"%s    %@",__func__,[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [tabbarController setSelectedIndex:0];
    });
}
//返回购物车
- (void)backToCart {
    DebugLog(@"%s   %@",__func__,[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        JJTabBarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [tabbarController setSelectedIndex:2];
    });
}
//改变标题头title
- (void)changeTitle:(NSString *)name {
    DebugLog(@"--%@-- %s    %@",name,__func__,[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        if([name isEqualToString:@"\n商品详情\n"]) {
            self.navigationItem.title = self.name;
            self.collectButton.customView.hidden = NO;
            self.shareButton.customView.hidden = NO;
        }else{
            self.navigationItem.title = name;
            self.collectButton.customView.hidden = YES;
            self.shareButton.customView.hidden = YES;
        }
    });
}
//加入购物车
- (void)joinCartWithGoodsSkuID:(NSString *)goodsSkuID goodsID:(NSString *)goodsID num:(NSString *)number{
    DebugLog(@"%s    %@",__func__,[NSThread currentThread]);
    if(![User getUserInformation]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self modelToLoginVC];
        });
        
        return ;
    }
    //发送添加购物车请求
    NSString * addCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_ADD];
    NSDictionary *params = @{@"user_id" : [User getUserInformation].userId , @"goods_id" : goodsID , @"num" : @(number.integerValue) , @"goods_sku_id" : goodsSkuID};
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUD:nil];
    });
    [HFNetWork postNoTipWithURL:addCartRequesturl params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        [MBProgressHUD showHUDWithDuration:1.0 information:@"添加购物车成功" hudMode:MBProgressHUDModeText];
        //发出加入购物车通知
        [[NSNotificationCenter defaultCenter]postNotificationName:ShopCartNotification object:nil];
    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"error= %@", error);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//给h5用户id
- (NSString *)getUserID {
    DebugLog(@"%s    %@",__func__,[NSThread currentThread]);
    DebugLog(@"123");
    if(![User getUserInformation]){
        //如果未登录
        dispatch_async(dispatch_get_main_queue(), ^{
            [self modelToLoginVC];
        });
        return @"";
    }
    DebugLog(@"userid------=%@",[User getUserInformation].userId);
    //如果未登陆
    return [User getUserInformation].userId;
}
//获取订单charge
- (void)placeOrder:(NSString *)charge {
    DebugLog(@"charge = %@    %@",charge,[NSThread currentThread]);
    
    NSString *urlSchemeStr = nil;
    NSDictionary *dictCharge = [Util JsonStringToDictionary:charge];
    //        if (paymentType == PaymentTypeWechat) {
    //            urlSchemeStr = WeiChatAppId;
    //        } else if (paymentType == PaymentTypeAlipay) {
    //
    //        } else if (paymentType == PaymentTypeCard) {
    //
    //        }
    weakSelf(weakSelf);
    [Pingpp createPayment:dictCharge
           viewController:weakSelf
             appURLScheme:urlSchemeStr
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
                   DebugLog(@"支付成功");
                   //                   [self showAlertWithTitle:@"支付成功" message:@"" cancelTitle:@"确定"];
                   
                   JJPaySuccessViewController *paySuccessViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"paySuccess"];
                   paySuccessViewController.type = 1;
                   //                       paySuccessViewController.model = self.model;
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.navigationController pushViewController:paySuccessViewController animated:YES];
                   });
               } else {
                   // 支付失败或取消
                   DebugLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                   [self showAlertWithTitle:@"支付失败" message:[error getMsg] cancelTitle:@"确定"];
               }
           }];
}
//余额支付成功
- (void)dealOrderBlancePay {
    NSLog(@"%s",__func__);
    [self requestToUserData];
    [self pushToPaySuccessVC];
}
//余额支付成功后发出用户资料请求
- (void)requestToUserData {
    NSString * userDataRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_USER_DATA];
    [HFNetWork getNoTipWithURL:userDataRequesturl params:nil success:^(id response) {
        //        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            //            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        User *user = [User mj_objectWithKeyValues:response[@"user"]];
        user.token = [User getUserInformation].token;
        [User saveUserInformation:user];
    } fail:^(NSError *error) {
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        //        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//余额支付成功跳到支付成功页
- (void)pushToPaySuccessVC {
    JJPaySuccessViewController *paySuccessViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"paySuccess"];
    paySuccessViewController.type = 1;
    //    paySuccessViewController.model = self.model;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:paySuccessViewController animated:YES];
    });
}

//提示
- (void)showMsg:(NSString *)message {
    NSLog(@"%@",message);
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDWithDuration:1.0 information:message hudMode:MBProgressHUDModeText];
    });
    
}

#pragma mark - UIScrollerViewDelegate & UIWebViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
//    UIColor * color = NORMAL_COLOR;
//    CGFloat offsetY = scrollView.contentOffset.y;
////    NSLog(@"%lf",offsetY);
//    if (offsetY < 100) {
//        CGFloat alpha = MIN(1, 1 - ((100  - offsetY) / 100));
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    } else {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
//    }
//}

//}

@end
