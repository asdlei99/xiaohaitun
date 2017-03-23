//
//  JJEditReceiveAddressViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJEditReceiveAddressViewController.h"
#import "JJEditOrNewAddressBaseView.h"
#import "UIButton+Custom.h"
#import "HXProvincialCitiesCountiesPickerview.h"
#import "UILabel+LabelStyle.h"
#import "MBProgressHUD+gifHUD.h"
#import "HFNetWork.h"
#import "User.h"

@interface JJEditReceiveAddressViewController ()<UITextFieldDelegate>
//收货人
@property (nonatomic, strong) JJEditOrNewAddressBaseView *nameView;
//联系方式
@property (nonatomic, strong) JJEditOrNewAddressBaseView *phoneView;
//省/市/区
@property (nonatomic, strong) JJEditOrNewAddressBaseView *placeView;
//详细地址
@property (nonatomic, strong) JJEditOrNewAddressBaseView *addressView;
//省份证
@property (nonatomic, strong) JJEditOrNewAddressBaseView *identityCartView;
//设置默认地址按钮
@property (nonatomic, strong) UIButton *setDefaultAddressBtn;
//保存按钮
@property (nonatomic, strong) UIButton *saveBtn;
//删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@end

@implementation JJEditReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(238, 238, 238, 1);
    self.navigationItem.title = @"编辑收货地址";
    [self initBaseView];
}

//创建基本视图
- (void)initBaseView {
    //收货人
    self.nameView = [JJEditOrNewAddressBaseView editOrNewAddressBaseView];
    self.nameView.textField.delegate = self;
    [self.view addSubview:self.nameView];
    self.nameView.baseLabel.text = @"收货人";
    self.nameView.textField.placeholder = @"姓名";
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.height.equalTo(@50);
    }];
    
    //联系方式
    self.phoneView =[JJEditOrNewAddressBaseView editOrNewAddressBaseView];
    self.phoneView.textField.delegate = self;
    [self.view addSubview:self.phoneView];
    self.phoneView.baseLabel.text = @"联系方式";
    self.phoneView.textField.placeholder = @"手机号码";
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    //省/市/区
     self.placeView =[JJEditOrNewAddressBaseView editOrNewAddressBaseView];
    self.placeView.textField.delegate = self;
    [self.view addSubview:self.placeView];
    self.placeView.baseLabel.text = @"省/市/区";
    self.placeView.textField.placeholder = @"收货地址";
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.phoneView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    //详细地址
     self.addressView =[JJEditOrNewAddressBaseView editOrNewAddressBaseView];
    self.addressView.textField.delegate = self;
    [self.view addSubview:self.addressView];
    self.addressView.baseLabel.text = @"详细地址";
    self.addressView.textField.placeholder = @"街道地址";
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.placeView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    //省份证
     self.identityCartView =[JJEditOrNewAddressBaseView editOrNewAddressBaseView];
    self.identityCartView.textField.delegate =self;
    [self.view addSubview:self.identityCartView];
    self.identityCartView.baseLabel.text = @"身份证";
    self.identityCartView.textField.placeholder = @"商品进口清关需要提交身份证";
    [self.identityCartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addressView.mas_bottom);
        make.height.equalTo(@50);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.identityCartView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.identityCartView);
        make.height.equalTo(@2);
    }];
    
    //设置默认地址按钮
    self.setDefaultAddressBtn = [[UIButton alloc]init];
    [self.view addSubview:self.setDefaultAddressBtn];
    self.setDefaultAddressBtn.backgroundColor = [UIColor clearColor];
    [self.setDefaultAddressBtn setTitle:@"设置默认地址" forState:UIControlStateNormal];
    [self.setDefaultAddressBtn setImage:[UIImage imageNamed:@"shopCar_Normal"] forState:UIControlStateNormal];
    [self.setDefaultAddressBtn setImage:[UIImage imageNamed:@"shopCar_Select"] forState:UIControlStateSelected];
    [self.setDefaultAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.setDefaultAddressBtn setTitleColor:RGBA(153,153, 153, 1) forState:UIControlStateNormal];
    [self.setDefaultAddressBtn addTarget:self action:@selector(setDefaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setDefaultAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@135);
        make.top.equalTo(self.identityCartView.mas_bottom).with.offset(14);
        make.left.equalTo(self.view);
        
    }];
    
    
    //保存按钮
    self.saveBtn = [[UIButton alloc]init];//WithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45)];
    [self.saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:0];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_saveBtn setBackgroundColor:NORMAL_COLOR ];
    [_saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.identityCartView.mas_bottom).with.offset(59 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(@(0.9 * SCREEN_WIDTH));
        make.height.equalTo(@42);
    }];
    
    //删除按钮
    self.deleteBtn = [[UIButton alloc]init];//WithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45)];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
     [self.deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_deleteBtn createBordersWithColor:[UIColor whiteColor] withCornerRadius:6 andWidth:0];
    [_deleteBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal ];
    [_deleteBtn setBackgroundColor:[UIColor whiteColor] ];
    [_deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.saveBtn.mas_bottom).with.offset(10);
        make.width.equalTo(@(0.9 * SCREEN_WIDTH));
        make.height.equalTo(@42);
    }];

    UILabel* tipLabel = [[UILabel alloc]init];
    [self.view addSubview:tipLabel];
    [tipLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12] text:@"海关蜀黍提示:购买全球购商品需要提供收货人身份证号码" textColor:NORMAL_COLOR textAlignment:NSTextAlignmentCenter];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deleteBtn.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
    }];

    self.nameView.textField.text = self.model.shipping_user;
    self.phoneView.textField.text = self.model.mobile;
    self.placeView.textField.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.province,self.model.city,self.model.area];
    self.addressView.textField.text = self.model.address;
    self.identityCartView.textField.text = self.model.id_card;
    self.setDefaultAddressBtn.selected = self.model.is_default.boolValue;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameView.textField resignFirstResponder];
    [self.phoneView.textField resignFirstResponder];
    [self.placeView.textField resignFirstResponder];
    [self.addressView.textField resignFirstResponder];
    [self.identityCartView.textField resignFirstResponder];
}

#pragma mark Button Action
//设置默认地址
- (void)setDefaultBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}

//保存
- (void)save:(UIButton *)btn{
    
    if([self.nameView.textField.text isEqualToString:@""] ||
       [self.phoneView.textField.text isEqualToString:@""] ||
       [self.addressView.textField.text isEqualToString:@""] ||
       [self.placeView.textField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"信息填写不完善" hudMode:MBProgressHUDModeText];
        return ;
    }
    
    NSString *shipping_user = self.nameView.textField.text;
    NSString *mobile = self.phoneView.textField.text;
    NSString *address = self.addressView.textField.text;
    //分隔字符串
    NSString*string =self.placeView.textField.text;
    NSString *province = @"";
    NSString *city = @"";
    NSString *area = @"";
    if(!(string == nil || [string  isEqual: @""])){
        NSArray *array = [string componentsSeparatedByString:@" "];
        province = array[0];
        city = array[1];
        area = array[2];
    }
    NSString *id_card = self.identityCartView.textField.text;
    NSString *is_default = @(self.setDefaultAddressBtn.selected).stringValue;
    NSString *addressID = self.model.addressID;
    
    NSDictionary *params = @{@"shipping_user" : shipping_user, @"mobile" : mobile, @"province" : province, @"city" : city ,@"area" : area, @"id_card" : id_card, @"address" : address, @"is_default" : is_default, @"id" : addressID};
    
    
    // 发送编辑保存收货地址请求
    NSString * saveRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_UPDATE_SHIPPING_ADDRESS];
    
    [HFNetWork postWithURL:saveRequesturl params:params success:^(id response) {

        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"地址修改成功" hudMode:MBProgressHUDModeText];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            if (self.editBlock){
                self.editBlock();
            }
//        });
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}
//删除
- (void)delete:(UIButton *)btn{
    // 发送删除收货地址请求
    NSString * deleteRequesturl = [NSString stringWithFormat:@"%@/api/v1/user/shippingaddress/%@/delete",DEVELOP_BASE_URL,self.model.addressID];
    
    [HFNetWork getWithURL:deleteRequesturl params:nil success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
//        [MBProgressHUD showHUDWithDuration:1.0 information:@"地址删除成功" hudMode:MBProgressHUDModeText];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            if (self.editBlock){
                self.editBlock();
            }
//        });
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];

}


#pragma mark UITextFieldelgate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.placeView.textField){
        [ self.nameView.textField resignFirstResponder];
        [ self.phoneView.textField resignFirstResponder];
        [ self.placeView.textField resignFirstResponder];
        [ self.addressView.textField resignFirstResponder];
        [ self.identityCartView.textField resignFirstResponder];
        [self.regionPickerView showPickerWithProvinceName:@"" cityName:@"" countyName:@""];
        return NO;
    }

    return YES;
}

#pragma mark - 懒加载
//地址选择
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            self.placeView.textField.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}


- (void)dealloc{
    
}
@end
