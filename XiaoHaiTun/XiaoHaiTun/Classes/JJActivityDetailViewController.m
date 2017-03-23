//
//  JJActivityDetailViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityDetailViewController.h"
#import "UIBarButtonItem+Fast.h"
#import "JJActivityDetailBookView.h"
#import <ReactiveCocoa.h>
#import "JJActivityOrderConfirmViewController.h"
#import "MJRefresh.h"
//#import "MXNavigationBarManager.h"
#import "JJActivityDetailCell.h"
//#import "JJActivityCell.h"
#import "JJDetailAddressTableViewCell.h"
#import "JJActivityDetailPriceCell.h"
#import "JJActivityRelateGoodsCell.h"
#import "HFNetWork.h"
#import <MJExtension.h>
#import "MBProgressHUD+gifHUD.h"
#import "Util.h"
#import "JJActivityTableViewCellModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "User.h"
#import "UIViewController+ModelLogin.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "UINavigationBar+Awesome.h"
#import "UIView+XPKit.h"
#import "TCADView.h"

#define SCROLL_VIEW_HEIGHT    (SCREEN_HEIGHT - 49 - NAVIGATION_HEIGHT_64)

static NSString * const PriceCellID = @"PriceCellIdentifier";
static NSString * const CellID = @"CellIdentifier";
static NSString * const AddressID = @"AddressIdentifier";

static NSString * const RelateGoodsID = @"RelateGoodsIdentifier";

@interface JJActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TCAdViewDelegate>

@property (nonatomic, strong) JJActivityDetailBookView *activityDetailBookView;

//数据模型
@property (nonatomic, strong) JJActivityTableViewCellModel *model;
//客服
@property (nonatomic, strong) UIButton *servicePeopleBtn;
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (strong, nonatomic) UITableView *subTableView;
@property (strong, nonatomic) UIWebView *webView;

//头视图(应该是轮播图)
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) TCADView *adView;


//收藏按钮
@property (nonatomic, strong)  UIBarButtonItem *collectButton;
//分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareButton;

@end

@implementation JJActivityDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.tableView.delegate = self;
    //    [self initBarManager];
    //        [self scrollViewDidScroll:self.subTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    self.tableView.delegate = nil;
    //    [MXNavigationBarManager reStore];
    //    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建视图
    [self initBaseView];
    //基本设置
    [self basicSet];
    //注册
    [self regist];
    //发送请求
    [self requestWithActivityDetail];
    
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}


//创建基本视图
- (void)initBaseView {
    
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.subTableView];
    [self.bgScrollView addSubview:self.webView];
    [self setSubTableViewRefreshFooter];
    [self setWebViewRefreshHeader];
    
    self.activityDetailBookView = [JJActivityDetailBookView activityDetailBookView];
    [self.view addSubview:self.activityDetailBookView];
    [self.activityDetailBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    self.servicePeopleBtn = [[UIButton alloc]init];
    self.servicePeopleBtn.hidden = YES;
    [self.servicePeopleBtn setImage:[UIImage imageNamed:@"Service_People"] forState:UIControlStateNormal];
    [self.view addSubview:self.servicePeopleBtn];
    [self.servicePeopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.activityDetailBookView.mas_top).with.offset(-10 *KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@(46 * KWIDTH_IPHONE6_SCALE));
    }];
}

#pragma mark - 懒加载
- (UIScrollView *)bgScrollView
{
    
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT_64, SCREEN_WIDTH,  SCROLL_VIEW_HEIGHT)];
        /*
         底层ScrollView必须scrollEnabled = NO
         */
        _bgScrollView.scrollEnabled = NO;
        _bgScrollView.backgroundColor = RGBA(238, 238, 238, 1);
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCROLL_VIEW_HEIGHT * 2);
    }
    return _bgScrollView;
}

- (UITableView *)subTableView
{
    if (!_subTableView) {
        _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT ) style:UITableViewStyleGrouped];
        _subTableView.backgroundColor = RGBA(238, 238, 238, 1);
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.rowHeight = 60;
    }
    return _subTableView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView.backgroundColor = [UIColor purpleColor];
//        [_webView setOpaque:NO];
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor greenColor];
        _webView.scrollView.backgroundColor = [UIColor yellowColor];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCROLL_VIEW_HEIGHT , SCREEN_WIDTH, SCROLL_VIEW_HEIGHT )];
        //        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}


//基本设置
- (void)basicSet {
    @weakify(self)
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *collectButton = [UIBarButtonItem itemImage:@"Nav_Collect_White" highlightedImage:@"Nav_Collect_White" target:self action:@selector(collectBtnClick:)];
    self.collectButton = collectButton;
    collectButton.customView.width = 30;
    UIButton *collectBtn = self.collectButton.customView;
    [collectBtn setImage:[UIImage imageNamed:@"Nav_Collect_Highlighted"] forState:UIControlStateSelected];
    
    UIBarButtonItem *shareButton = [UIBarButtonItem itemImage:@"Nav_Share_White" highlightedImage:@"Nav_Share_White" target:self action:@selector(shareBtnClick:)];
    self.shareButton = shareButton;
    shareButton.customView.width = 30;
    self.navigationItem.rightBarButtonItems = @[shareButton,collectButton];
    
    [[self.activityDetailBookView.bookNowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        if(![User getUserInformation]){
            [self modelToLoginVC];
        }else{
            JJActivityOrderConfirmViewController *activityOrderConfirmViewController = [[JJActivityOrderConfirmViewController alloc]init];
            activityOrderConfirmViewController.model = self.model;
            [self.navigationController pushViewController:activityOrderConfirmViewController animated:YES];
        }
        
    }];
}

//注册
- (void)regist {
    [self.subTableView registerClass:[JJActivityDetailPriceCell class] forCellReuseIdentifier:PriceCellID];
    [self.subTableView registerNib:[UINib nibWithNibName:@"JJActivityDetailCell" bundle:nil] forCellReuseIdentifier:CellID];
    [self.subTableView registerNib:[UINib nibWithNibName:@"JJDetailAddressTableViewCell" bundle:nil] forCellReuseIdentifier:AddressID];
    [self.subTableView registerClass:[JJActivityRelateGoodsCell class] forCellReuseIdentifier:RelateGoodsID];
}

//发送活动详情请求
- (void)requestWithActivityDetail {
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ACTIVITY_DETAIL];
    NSDictionary * params = nil;
    //    NSLog(@"%@",[User getUserInformation].userId);
    if([User getUserInformation]){
        params = @{@"activity_id" : self.activityID , @"user_id" : [User getUserInformation].userId};
    }else{
        params = @{@"activity_id" : self.activityID};
    }
    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
        [MBProgressHUD hideHUD];
        DebugLog(@"%@",response);
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) {
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        JJActivityTableViewCellModel *model = [JJActivityTableViewCellModel mj_objectWithKeyValues:response[@"details"]];
        self.model = model;
        self.navigationItem.title = self.model.name;
        [self.subTableView reloadData];
        UIButton *collectBtn = self.collectButton.customView;
        collectBtn.selected = self.model.is_collect;
//                self.model.content =
//        NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;}</style></head>%@",SCREEN_WIDTH - 10 , self.model.content];
        
//        [self.webView loadHTMLString:self.model.content baseURL:nil];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.content]]];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
        
    }];
}

#pragma mark - 收藏分享按钮点击

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
            params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.model.activityID , @"action_id" : @2 ,@"is_activity" : @1};
        }else{
            params = @{ @"item_id" : self.model.activityID , @"action_id" : @2 ,@"is_activity" : @1};
        }
    }else{//若未收藏
        if([User getUserInformation]){
            params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.model.activityID , @"action_id" : @1 ,@"is_activity" : @1};
        }else{
            params = @{ @"item_id" : self.model.activityID , @"action_id" : @1 ,@"is_activity" : @1};
        }
    }
    
    //发送收藏活动请求
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
        DebugLog(@"%ld",collectBtn.selected);
        collectBtn.selected = !collectBtn.selected;
        DebugLog(@"%ld",collectBtn.selected);
        
    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

- (void)shareBtnClick:(UIButton *)btn{
    if(!self.model) {
        return ;
    }
    //1、创建分享参数
    NSArray* imageArray = @[self.model.cover];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        DebugLog(@"%@ ",self.model.name);
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/activity/%@",DEVELOP_BASE_URL,self.activityID]]
                                          title:self.model.name
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.model.items.count <= 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 5;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            JJActivityDetailPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:PriceCellID forIndexPath:indexPath];
            
            priceCell.name = self.model.name;
            priceCell.price = self.model.price;
            priceCell.limit = self.model.limit;
            return priceCell;
        }
        if(indexPath.row == 1) {
            JJActivityDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
            detailCell.imageIcon.image = [UIImage imageNamed:@"Detail_Time"];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.model.start_time.integerValue];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.model.end_time.integerValue];
            
            NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyy年MM月dd日";
            NSString* startString=[formatter stringFromDate:startDate];
            NSString* endString=[formatter stringFromDate:endDate];
            
            detailCell.titleNameLabel.text = [NSString stringWithFormat:@"%@-%@",startString,endString];
            
            return detailCell;
        }
        if(indexPath.row == 2) {
            JJActivityDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
            detailCell.imageIcon.image = [UIImage imageNamed:@"Detail_Age"];
            detailCell.titleNameLabel.text = @"";
            detailCell.titleNameLabel.text = self.model.age;
            return detailCell;
        }
        if(indexPath.row == 3){
            JJDetailAddressTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:AddressID forIndexPath:indexPath];
            addressCell.addressLabel.text = self.model.address;
            addressCell.titleNameLabel.text = self.model.merchant;
            return addressCell;
        }
        if(indexPath.row == 4){
            JJActivityDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
            detailCell.imageIcon.image = [UIImage imageNamed:@"Detail_Mobile"];
            detailCell.titleNameLabel.text = @"";
            detailCell.titleNameLabel.text = self.model.phone;
            [detailCell whenTapped:^{
                NSString *allString = [NSString stringWithFormat:@"tel:%@",self.model.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            }];
            return detailCell;
        }
    }
    JJActivityRelateGoodsCell *RelateGoddsCell = [tableView dequeueReusableCellWithIdentifier:RelateGoodsID forIndexPath:indexPath];

    RelateGoddsCell.modelArray = self.model.items;
    return RelateGoddsCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        
        self.adView = [[TCADView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250 * KWIDTH_IPHONE6_SCALE)];
        _adView.displayTime = 3;
        _adView.delegate = self;
        [self.adView setDataArray:self.model.pictures];
        if(self.model.pictures.count <= 1) {
            [self.adView.pageControl setHidden:YES];
            
        }else{
            [self.adView setUserInteractionEnabled:YES];
            [self.adView perform];
        }
        return self.adView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 250 * KWIDTH_IPHONE6_SCALE;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if(section == 1){
    //        return 49;
    //    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            if(self.model.limit.floatValue == 0) {
                return 130 * KWIDTH_IPHONE6_SCALE;
            }else{
                return 150 * KWIDTH_IPHONE6_SCALE;
            }
            //120
        }
        if(indexPath.row == 3){
            return 63 * KWIDTH_IPHONE6_SCALE;
        }
        return 44 * KWIDTH_IPHONE6_SCALE;
    } else {
        return 253 * KWIDTH_IPHONE6_SCALE;
    }
}


#pragma mark - ADViewDelegate
#pragma mark - Delegate
- (void)adView:(TCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL
{
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //    imageView.image = [UIImage imageNamed:imageURL];
}




#pragma mark - SetUp
- (void)setSubTableViewRefreshFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        //        [weakSelf.bgScrollView scrollRectToVisible:CGRectMake(0, self.webView.top - NAVIGATION_HEIGHT_64, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT - NAVIGATION_HEIGHT_64) animated:YES];
        [weakSelf.bgScrollView setContentOffset:CGPointMake(0, SCROLL_VIEW_HEIGHT) animated:YES];
        [weakSelf.subTableView.mj_footer endRefreshing];
        //        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bing.com"]]];
        //        [weakSelf.webView loadHTMLString:@"我的<b>iPhone</b>程序" baseURL:nil];
    }];
    refreshFooter.arrowView.image = nil;
    [refreshFooter setTitle:@"上拉查看图文详情" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"上拉查看图文详情" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"上拉查看图文详情" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"上拉查看图文详情" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"上拉查看图文详情" forState:MJRefreshStateNoMoreData];
    // 隐藏状态
    //    refreshFooter.stateLabel.hidden = YES;
    self.subTableView.mj_footer = refreshFooter;
}
- (void)setWebViewRefreshHeader
{
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //                [weakSelf.bgScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT) animated:YES];
        [weakSelf.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [weakSelf.webView.scrollView.mj_header endRefreshing];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshHeader setTitle:@"下拉回到商品信息" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"下拉回到商品信息" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"下拉回到商品信息" forState:MJRefreshStateRefreshing];
    [refreshHeader setTitle:@"下拉回到商品信息" forState:MJRefreshStateWillRefresh];
    [refreshHeader setTitle:@"下拉回到商品信息" forState:MJRefreshStateNoMoreData];
    self.webView.scrollView.mj_header = refreshHeader;
}




@end
