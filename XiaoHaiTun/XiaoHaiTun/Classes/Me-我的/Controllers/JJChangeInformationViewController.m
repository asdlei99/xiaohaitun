//
//  JJChangeInformationViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChangeInformationViewController.h"
#import "User.h"
#import "JJInformationPictureCell.h"
#import "JJInformationOtherCell.h"
#import <UIImageView+WebCache.h>
#import "DatePickerView.h"
#import "JJInformationOtherCell.h"
#import "UIActionSheet+XPKit.h"
#import "JJUpdateNameController.h"
#import <LBXAlertAction.h>
#import "LBXScanWrapper.h"
#import "UIImage+XPKit.h"
#import "HFNetWork.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJCityPickerView.h"
#import "JJCity.h"
#import <AFNetworking.h>

@interface JJChangeInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//头像地址
//@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, strong) UIImage *iconImage;


//user_id
@property (nonatomic, copy) NSString *user_id;
//图片路径
@property (nonatomic, copy) NSString *avatar;
//手机号
@property (nonatomic, copy) NSString *mobile;
//昵称
@property (nonatomic, copy) NSString *nickname;
//性别
@property (nonatomic, copy) NSString *gender;
//宝宝姓名
@property (nonatomic, copy) NSString *baby_name;
//生日
@property (nonatomic, copy) NSString *birthday;
//城市id
@property (nonatomic, copy) NSString *city;
//baby性别
@property (nonatomic, copy) NSString *baby_gender;
//baby生日
@property (nonatomic, copy) NSString *baby_birthday;

//选择城市pickerView
@property (nonatomic, strong) JJCityPickerView *cityPickerView;

@end

@implementation JJChangeInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改资料";
    self.tableView.backgroundColor = RGBA(238, 238, 238, 1);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    DebugLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));

    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";

    User *user = [User getUserInformation];
    self.user_id = user.userId;
    self.avatar = user.avatar;
    self.mobile = user.mobile;
    self.nickname = user.nickname;
    self.gender = user.gender.stringValue;
    self.baby_name = user.baby_name;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:user.baby_birthday];
    NSString* birthString=[formatter stringFromDate:date];
    self.birthday = birthString;
    
    self.city = user.city.stringValue;
    self.baby_gender= user.baby_gender.stringValue;
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:user.baby_birthday];
    NSString* birthString1=[formatter stringFromDate:date1];
    self.baby_birthday = birthString;
    
}



#pragma mark - UITableViewDataSource || UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 3;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [User getUserInformation];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld_%ld", (long)indexPath.section, (long)indexPath.row] forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0://Section 0
        {
            switch (indexPath.row) {
                case 0:
                {
                    //头像
                    JJInformationPictureCell *cel = cell;
                    DebugLog(@"1");
                   [ cel.pictureView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"me_icon"]];
                    break;
                }
                case 1:
                {
                    //昵称
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"2");
                    cel.descriptLabel.text = user.nickname;
                    break;
                }
                case 2:
                {
                    //手机号码
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"3");
                    cel.descriptLabel.text = user.mobile;
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        case 1://Section 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    //性别
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"4");
                    cel.descriptLabel.text = user.gender.intValue == 1? @"男":@"女";
                    break;
                }
                case 1:
                {
                    //出生日期
                    JJInformationOtherCell *cel = cell;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:user.birthday];
                    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyy-MM-dd";
                    NSString* birthString=[formatter stringFromDate:date];
                    cel.descriptLabel.text = birthString;
                    
                   
//                    NSDate *now = [NSDate date];
//                    NSLog(@"now date is: %@", now);
//                    
//                    NSCalendar *calendar = [NSCalendar currentCalendar];
//                    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//                    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
//                    
//                    int year = [dateComponent year];
//                    int month = [dateComponent month];
//                    int day = [dateComponent day];
//                    int hour = [dateComponent hour];
//                    int minute = [dateComponent minute];
//                    int second = [dateComponent second];
//                    
//                    NSLog(@"year is: %d", year);
//                    NSLog(@"month is: %d", month);
//                    NSLog(@"day is: %d", day);
//                    NSLog(@"hour is: %d",hour);
//                    NSLog(@"minute is: %d", minute);
//                    NSLog(@"second is: %d", second);
                    
             
                    
                    break;
                }
                    
                    
                case 2:
                {
                    //城市
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"6");
                    NSArray *cityArray = [JJCity getcityArrayInformation];
                    for(JJCity * city in cityArray) {
                        if([city.cityID isEqualToString:self.city]) {
                            cel.descriptLabel.text = city.cityName;
                            break;
                        }
                    }
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2://Section 2
        {
            switch (indexPath.row) {
                case 0:
                {
                    //宝宝姓名
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"7");
                    cel.descriptLabel.text = user.baby_name;
                    break;
                }
                case 1:
                {
                    //宝宝性别
                    JJInformationOtherCell *cel = cell;
                    DebugLog(@"8");
                    cel.descriptLabel.text = user.baby_gender.intValue == 1? @"男":@"女";
                    break;
                }

                case 2:
                {
                    //宝宝生日
                    JJInformationOtherCell *cel = cell;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:user.baby_birthday];
                    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyy-MM-dd";
                    NSString* birthString=[formatter stringFromDate:date];
                    cel.descriptLabel.text = birthString;

                    break;
                }

                default:
                    break;
            }
            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath .row == 0) {
        return 82;
    }
    return 49;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"个人信息";
    }
    if(section == 2){
        return @"孩子信息";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
//    view.backgroundColor = [UIColor redColor];
        
        UIButton *saveBtn = [[UIButton alloc]init];
        [view addSubview:saveBtn];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.backgroundColor = NORMAL_COLOR;
        [saveBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:0];
        [saveBtn addTarget:self action:@selector(saveUpdate:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).with.offset(20);
            make.right.equalTo(view).with.offset(-20);
            make.height.equalTo(@42);
        }];
        
        return view;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 0.1;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 2){
        return 80;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    switch (indexPath.section) {
        case 0://Section 0
        {
            switch (indexPath.row) {
                case 0:
                {
                    //打开相册
                    [self openPhoto];
                    break;
                }
                case 1:
                {
                    JJUpdateNameController *updateNameChontroller = [[JJUpdateNameController alloc]init];
                    updateNameChontroller.name = self.nickname;
                    weakSelf(weakSelf);
                    updateNameChontroller.updateBlock = ^(NSString * name){
                        ((JJInformationOtherCell *)cell).descriptLabel.text = name;
                        weakSelf.nickname = name;
                    };
                    [self.navigationController pushViewController:updateNameChontroller animated:YES];
                    break;
                }
                case 2:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        case 1://Section 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    //选择性别
                    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* alertAction=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ((JJInformationOtherCell *)cell).descriptLabel.text = @"男";
                        self.gender = @"1";
                    }];
                    UIAlertAction* alertAction1=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ((JJInformationOtherCell *)cell).descriptLabel.text = @"女";
                        self.gender = @"2";
                    }];
                    UIAlertAction* alertAction2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:alertAction];
                    [alertController addAction:alertAction1];
                    [alertController addAction:alertAction2];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    break;
                }
                case 1:
                {
                    //修改生日
                    [self birthdayChooseAction];
                    break;
                }
                case 2:
                {
                     [self.cityPickerView showPickerWithCityName:@""];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
            
        case 2://Section 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    JJUpdateNameController *updateNameChontroller = [[JJUpdateNameController alloc]init];
                    updateNameChontroller.name = self.baby_name;
                    weakSelf(weakSelf);
                    updateNameChontroller.updateBlock = ^(NSString * name){
                        ((JJInformationOtherCell *)cell).descriptLabel.text = name;
                        weakSelf.baby_name = name;
                    };
                    [self.navigationController pushViewController:updateNameChontroller animated:YES];
                    break;
                }
                case 1:
                {
                    //选择性别
                    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* alertAction=[UIAlertAction actionWithTitle:@"男孩" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ((JJInformationOtherCell *)cell).descriptLabel.text = @"男孩";
                        self.baby_gender = @"1";
                    }];
                    UIAlertAction* alertAction1=[UIAlertAction actionWithTitle:@"女孩" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ((JJInformationOtherCell *)cell).descriptLabel.text = @"女孩";
                        self.baby_gender = @"2";
                    }];
                    UIAlertAction* alertAction2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:alertAction];
                    [alertController addAction:alertAction1];
                    [alertController addAction:alertAction2];
                    [self presentViewController:alertController animated:YES completion:nil];

                    break;
                }
                case 2:
                {
                    //修改宝宝生日
                    [self babyBirthdayChooseAction];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - 点击触发事件

//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}


//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    JJInformationPictureCell * cel = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cel.pictureView.image = image;
    self.iconImage = image;
    
//    [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf scanResultWithArray:array];
//        });
//        
//    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DebugLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --修改生日
//点击出生年月日
- (void)birthdayChooseAction {
    DatePickerView *datePicker = [[DatePickerView alloc] init];
    [datePicker showInView:self.view];
    datePicker.selectBlock = ^(NSDate* date) {
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSString* birthString=[formatter stringFromDate:date];
        JJInformationOtherCell *cel = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        cel.descriptLabel.text = birthString;
        self.birthday = birthString;
        //        DebugLog(birthString);
    };
}

//点击宝宝出生年月日
- (void)babyBirthdayChooseAction {
    DatePickerView *datePicker = [[DatePickerView alloc] init];
    [datePicker showInView:self.view];
    datePicker.selectBlock = ^(NSDate* date) {
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSString* birthString=[formatter stringFromDate:date];
        JJInformationOtherCell *cel = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
        cel.descriptLabel.text = birthString;
        self.baby_birthday = birthString;
        DebugLog(birthString);
    };
}

#pragma mark - 上传图片和修改用户信息

//更改图片
- (void)updateImage {
    
        NSString *imageBase64String = [self.iconImage base64Encoding];
        NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_UPLOAD_AVATAR];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:imageBase64String forKey:@"avatar_binary"];
        [HFNetWork postWithURL:URL params:params success:^(id response) {
            [MBProgressHUD hideHUD];
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
            User *user = [User getUserInformation];
            user.avatar = response[@"avatar_url"];
            self.avatar = response[@"avatar_url"];
            [User saveUserInformation:user];
            
            //修改用户资料请求
            [self requesrWithUserMessage];
            DebugLog(@"登陆成功%@",response);
        } fail:^(NSError *error) {
            [MBProgressHUD hideHUD];
            //        _logInBtn.enabled = YES;
            [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
            // 修改用户资料请求
            [self requesrWithUserMessage];
        }];
}

//保存修改
- (void)saveUpdate:(id)sender {
    //若iconImage有值,则表示有更换图片
    if(self.iconImage) {
        [self updateImage];
        return ;
    }
    [self requesrWithUserMessage];
}

////修改用户资料请求
- (void)requesrWithUserMessage {
    
    User *user = [User getUserInformation];
    NSString *url = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL,API_USER_UPDATE];
    DebugLog(@"%@",url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = self.user_id;
    params[@"avatar"] = self.avatar;
    params[@"mobile"] = self.mobile;
    params[@"nickname"] = self.nickname;
    params[@"gender"] = self.gender;
    params[@"baby_name"] = self.baby_name;
    params[@"birthday"] = self.birthday;
    params[@"city"] = self.city;
    params[@"baby_gender"] = self.baby_gender;
    params[@"baby_birthday"] = self.baby_birthday;
    
    [HFNetWork postWithURL:url params:params success:^(id response) {
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
        
        User *user = [User getUserInformation];
        user = [User mj_objectWithKeyValues:response[@"user"]];
        user.token = response[@"token"];
        [User saveUserInformation:user];
        [MBProgressHUD showHUDWithDuration:1.0 information:@"用户资料修改成功" hudMode:MBProgressHUDModeText];
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        DebugLog(@"%@",error);
        NSInteger errorCode = [error code];
        DebugLog(@"errorCode == %ld", (long)errorCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
    
}


#pragma mark - 懒加载
//地址选择
- (JJCityPickerView *)cityPickerView {
    if (!_cityPickerView) {
        _cityPickerView = [[JJCityPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        JJInformationOtherCell *cel = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        __weak typeof(self) weakself = self;
        _cityPickerView.completion = ^(JJCity *city) {
            
            cel.descriptLabel.text = city.cityName;
            weakself.city = city.cityID;
        };
        [self.navigationController.view addSubview:_cityPickerView];
    }
    return _cityPickerView;
}
@end
