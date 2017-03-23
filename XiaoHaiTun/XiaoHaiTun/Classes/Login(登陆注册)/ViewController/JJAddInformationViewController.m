//
//  JJAddInformationViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAddInformationViewController.h"
#import "JJInformationCell.h"
//#import "MXNavigationBarManager.h"
#import "JJAddInformationHeadView.h"
#import "JJInformationBirthCell.h"
#import "DatePickerView.h"
#import "HFNetWork.h"
#import "User.h"
//#import "JJUserInformationManager.h"
#import "MBProgressHUD+gifHUD.h"
#import "JJHobbyModel.h"
#import "JJInformationCell.h"
#import <ReactiveCocoa.h>
#import <MJExtension.h>
#import "JJCity.h"
#import "JJTabBarController.h"
#import "JPUSHService.h"

#define cellSpace (21 * KWIDTH_IPHONE6_SCALE)


static NSString * const informationCellIdentifier = @"informationCellIdentifier";

static NSString * const informationBirthCellIdentifier = @"informationBirthCellIdentifier";

static NSString * const informationHeadIdentifier = @"informationHeadIdentifier";

@interface JJAddInformationViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>


//宝宝爱好label
@property (nonatomic, strong) UILabel *titleLabel;

//collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

//完成按钮
@property (nonatomic, strong) UIButton *finishBtn;


/**
 *  点击完成注册需要传递的参数
 */
////电话号码
//NSString* mobile;
////验证码
//NSString* v_code;
////密码
//NSString* password;

//宝宝性别 1男/2女
@property(nonatomic,assign)NSInteger sex;

//宝宝出生日期
@property (nonatomic, copy)NSString* birthString ;

//宝宝爱好特长数组
@property (nonatomic, strong) NSMutableArray<JJHobbyModel *> *hobbySelectArray;



@end

@implementation JJAddInformationViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //创建基本视图
    [self initBaseView];
    
    //注册
    [self regist];
    
   
}


//设置导航条内容
- (void)setupNavigationBar {
    
       //required
//    [MXNavigationBarManager saveWithController:self];
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//    [MXNavigationBarManager setTintColor:NORMAL_COLOR];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建基本视图
- (void)initBaseView {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    self.titleLabel;
    [self.finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    self.collectionView ;
    
}

//注册
- (void)regist{
    //注册Cell
    [self.collectionView registerClass:[JJInformationCell class] forCellWithReuseIdentifier:informationCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JJInformationBirthCell" bundle:nil] forCellWithReuseIdentifier:informationBirthCellIdentifier];
    //注册头
    [self.collectionView registerNib:[UINib nibWithNibName:@"JJAddInformationHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:informationHeadIdentifier];
}



//点击出生年月日
- (void)birthdayChooseAction {
    DatePickerView *datePicker = [[DatePickerView alloc] init];
    [datePicker showInView:self.view];
    datePicker.selectBlock = ^(NSDate* date) {
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSString* birthString=[formatter stringFromDate:date];
        self.birthString = birthString;
        JJInformationBirthCell *cel = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        cel.birthLabel.text = birthString;
        DebugLog(birthString);
    };
}

#pragma mark - 点击完成按钮

- (void)finishAction {
    if (self.sex == 0) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择宝宝性别" hudMode:MBProgressHUDModeText];
        return;
    }
//    if(self.hobbySelectArray.count == 0){
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"请至少选择一个兴趣爱好" hudMode:MBProgressHUDModeText];
//        return;
//    }
    if(self.birthString == nil){
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请选择出生日期" hudMode:MBProgressHUDModeText];
        return;
    }
    
    [self requestToSignUp];
}

//发出注册请求
- (void)requestToSignUp {
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SIGNUP];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.mobile forKey:@"mobile"];
    [params setObject:self.password forKey:@"password"];
    [params setObject:self.v_code forKey:@"v_code"];
    [params setObject:@(self.sex) forKey:@"baby_gender"];
    DebugLog(@"%@",self.birthString);
    [params setObject:self.birthString forKey:@"baby_birthday"];
    NSMutableArray * hobbyIDArray = [NSMutableArray array];
    for(JJHobbyModel * model in self.hobbySelectArray){
        [hobbyIDArray addObject:@(model.ID)];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:hobbyIDArray options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *hobbyIDString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:hobbyIDString forKey:@"baby_hobby"];
    
    
    DebugLog(@"参数  %@",params);
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
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        //成功返回 User信息本地存储
        User *user =[User mj_objectWithKeyValues:response[@"user"]];;
        user.token = response[@"token"];
        [User saveUserInformation:user];
        
        NSArray<JJCity *> *cityArray = [JJCity mj_objectArrayWithKeyValuesArray:response[@"citys"]];
        [JJCity saveCityArrayInformation:cityArray];
        
        //发出通知
//        [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
        //注册极光
        [self networkDidSetup];
        
        
        DebugLog(@"注册成功%@",response);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"注册成功" hudMode:MBProgressHUDModeText];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoMainView];
        });
        
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errorCode = [error code];
        DebugLog(@"errorCode == %ld", (long)errorCode);
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


//前往小海囤首页
-(void)gotoMainView {

    JJTabBarController *tabbarController = (JJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:0];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - <UICollectionViewDataSource||UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return self.sexModelArray.count;
    }else if(section == 1){
        return self.hobbyModelsArray.count;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    
        JJInformationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:informationCellIdentifier forIndexPath:indexPath];
        cell.hobbyModel = self.sexModelArray[indexPath.row];
        
        
    return cell;
        
    } else if(indexPath.section == 1){
        
        JJInformationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:informationCellIdentifier forIndexPath:indexPath];
        cell.hobbyModel = self.hobbyModelsArray[indexPath.row];
        return cell;
    }else{
       
        JJInformationBirthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:informationBirthCellIdentifier forIndexPath:indexPath];
        //    [cell createBordersWithColor:RGBA(249, 249, 249, 1) withCornerRadius:0 andWidth:1];
        return cell;
    }
    return nil;
    
}

//创建header头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JJAddInformationHeadView *headerView = nil;
//    if(indexPath.section == 0 || indexPath.section == 1){
    if (kind == UICollectionElementKindSectionHeader){
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:informationHeadIdentifier forIndexPath:indexPath];
    }
    if(indexPath.section == 0) {
        headerView.headTitleLabel.text = @"我的宝宝";
    }else if (indexPath.section == 1) {
        headerView.headTitleLabel.text = @"选择兴趣爱好";
    }
//    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //处理男女只能选择一种性别问题
    if(indexPath.section == 0) {
        if(indexPath.row == 0){
            JJHobbyModel *sexModelboy = self.sexModelArray[indexPath.row];
            sexModelboy.isSelected = !sexModelboy.isSelected;
            if (sexModelboy.isSelected == YES) {
                JJHobbyModel *sexModelgirl = self.sexModelArray[1];
                sexModelgirl.isSelected = NO;
                self.sex = sexModelboy.ID;
            }else{
                self.sex = 0;
            }

        }else{
            JJHobbyModel *sexModelgirl = self.sexModelArray[indexPath.row];
            sexModelgirl.isSelected = !sexModelgirl.isSelected;
            if (sexModelgirl.isSelected == YES) {
                JJHobbyModel *sexModelboy = self.sexModelArray[0];
                sexModelboy.isSelected = NO;
                self.sex = sexModelgirl.ID;
            }else{
                self.sex = 0;
            }
        }
    }
    
    //选择兴趣爱好
    if(indexPath.section == 1){
        JJHobbyModel *model = self.hobbyModelsArray[indexPath.row];
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            [self.hobbySelectArray addObject:model];
        }else {
            [self.hobbySelectArray removeObject:model];
        }
    }
    
    if(indexPath.section == 2){
        [self birthdayChooseAction];
    }
    DebugLog(@"%ld",self.hobbySelectArray.count);
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 || indexPath.section == 1){
    CGFloat width = (SCREEN_WIDTH - (cellSpace * 4))/3;
    CGFloat height = width * (127.0 / 97) ;
   
        return CGSizeMake(width, height);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 44);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
     if(section == 0 || section == 1) {
    return CGSizeMake(SCREEN_WIDTH, 34);
     } else {
         return CGSizeMake(0, 0);
     }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, cellSpace, 38, cellSpace);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return cellSpace;
}

#pragma mark - 懒加载
- (UIView *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _titleLabel.text = @"宝宝的爱好";
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(69 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(38);
            make.bottom.equalTo(self.finishBtn.mas_top);
        }];
    }
    return _collectionView;
}

- (UIButton *)finishBtn {
    if(!_finishBtn){
        _finishBtn = [[UIButton alloc]init];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _finishBtn.backgroundColor = NORMAL_COLOR;
        [_finishBtn setImage:[UIImage imageNamed:@"tick_add_Information"] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.view addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.equalTo(@53);
        }];
    }
    return _finishBtn;
}

- (NSArray<JJHobbyModel *> *)sexModelArray {
    if (!_sexModelArray) {
        JJHobbyModel *sexModel1 = [[JJHobbyModel alloc]init];
        sexModel1.name = @"正太";
        sexModel1.ID = 1;
        sexModel1.picture = [[NSBundle mainBundle]pathForResource:@"boyy.png" ofType:nil];
        DebugLog(@"%@",sexModel1.picture);
        
        JJHobbyModel *sexModel2 = [[JJHobbyModel alloc]init];
        sexModel2.name = @"萝莉";
        sexModel2.ID = 2;
        sexModel2.picture =  [[NSBundle mainBundle]pathForResource:@"girl.png" ofType:nil];
        _sexModelArray = @[sexModel1,sexModel2];
    }
    return _sexModelArray;
}

- (NSMutableArray *)hobbySelectArray {
    if(_hobbySelectArray == nil){
        _hobbySelectArray = [NSMutableArray array];
    }
    return _hobbySelectArray;
}
@end
