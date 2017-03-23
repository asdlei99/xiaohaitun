//
//  JJActivityOrderConfirmViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderConfirmViewController.h"
#import "JJActivityOrderGoodsCell.h"
#import "JJActivityOrderConfirmMessageView.h"
#import "JJRemarkInputView.h"
#import "UIViewController+KeyboardCorver.h"
#import "JJSubmitMenuView.h"
#import <ReactiveCocoa.h>
#import "JJCashierViewController.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+gifHUD.h"
#import "User.h"
#import <MJExtension.h>
#import "JJPaySuccessViewController.h"
#import "UIStoryboard+JJEasyCreate.h"
#import "NSString+XPKit.h"


@interface JJActivityOrderConfirmViewController ()
//商品LOGO
@property (nonatomic, strong) JJActivityOrderGoodsCell *activityOrderGoodsCell;
//出发日期
@property (nonatomic, strong) JJActivityOrderConfirmMessageView *activityOrderConfirmMessageView;
//联系方式
@property (nonatomic, strong) JJRemarkInputView *contactInputView;
//订单备注
@property (nonatomic, strong) JJRemarkInputView *remarkInputView;

//提交订单Menu
@property (nonatomic, strong) JJSubmitMenuView *submitMenuView;


@end

@implementation JJActivityOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self addNotification];
    
    // Do any additional setup after loading the view.
}

- (void)initBaseView {
    @weakify(self)
    
    self.navigationItem.title = @"活动订单确认";
    self.view.backgroundColor = RGBA(238, 238, 238, 1);
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.view addSubview:backView];
    
    
    self.activityOrderGoodsCell = [[JJActivityOrderGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodCell"];
    self.activityOrderGoodsCell.backgroundColor = [UIColor whiteColor];
    [backView addSubview:self.activityOrderGoodsCell];
    self.activityOrderGoodsCell.frame = CGRectMake(0, 64, SCREEN_WIDTH, 128 * KWIDTH_IPHONE6_SCALE);
    [self.activityOrderGoodsCell.activityIcon sd_setImageWithURL:[NSURL URLWithString:self.model.cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.activityOrderGoodsCell.descriptLabel.text = self.model.name;
    self.activityOrderGoodsCell.addressLabel.text =[NSString stringWithFormat:@"地址 :%@", self.model.address];
    
    self.activityOrderConfirmMessageView = [[JJActivityOrderConfirmMessageView alloc]initWithFrame:CGRectMake(0, self.activityOrderGoodsCell.bottom, SCREEN_WIDTH, 119 * KWIDTH_IPHONE6_SCALE)];
    self.activityOrderConfirmMessageView.backgroundColor = [UIColor whiteColor];
//        self.activityOrderConfirmMessageView.backgroundColor = [UIColor grayColor];
    [backView addSubview:self.activityOrderConfirmMessageView];
    self.activityOrderConfirmMessageView.goDateLabel.text = [self.model.start_time stringChangeToDate:nil];
    self.activityOrderConfirmMessageView.typeLabel.text = self.model.category ;
    self.activityOrderConfirmMessageView.payMoneyLabel.text =[NSString stringWithFormat:@"¥%@",self.model.price];
    
    
    self.contactInputView = [JJRemarkInputView remarkInputView];
    self.contactInputView.frame = CGRectMake(0, self.activityOrderConfirmMessageView.bottom, SCREEN_WIDTH, 45 * KWIDTH_IPHONE6_SCALE);
    self.contactInputView.title = @"联系方式";
    self.contactInputView.inputRemarkTextField.placeholder = @"输入手机号码";
    [backView addSubview:self.contactInputView];
    
    self.remarkInputView = [JJRemarkInputView remarkInputView];
    self.remarkInputView.inputRemarkTextField.placeholder = @"请输入文字";
    self.remarkInputView.title = @"订单备注";
    self.remarkInputView.frame = CGRectMake(0, self.contactInputView.bottom, SCREEN_WIDTH, 45 * KWIDTH_IPHONE6_SCALE);
    [backView addSubview:self.remarkInputView];
    
    //提交订单Menu
    self.submitMenuView = [JJSubmitMenuView submitMenuView];
    self.submitMenuView.allMoneyLabel.text =[NSString stringWithFormat:@"¥%@", self.model.price];
    [backView addSubview:self.submitMenuView];
    [self.submitMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(backView);
        make.height.equalTo(@49);
    }];
    [[self.submitMenuView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self submitActivityOrder];
    }];
}
//提交订单确认
- (void)submitActivityOrder {
    //号码
    NSString *mobile = self.contactInputView.inputRemarkTextField.text;
    //备注
    NSString *remark = self.remarkInputView.inputRemarkTextField.text;
    if (!mobile.length) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
        return;
    }
    if (![Util isMobileNumber:mobile]) {
        [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号"hudMode:MBProgressHUDModeText];
        return;
    }
    
    NSString * deleteCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ACTIVITY_ORDER];
    NSDictionary * params = @{@"activity_id" : self.model.activityID , @"user_id" : [User getUserInformation].userId , @"note" : remark , @"phone" : mobile};
    [HFNetWork postWithURL:deleteCartRequesturl params:params success:^(id response) {
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
        
        
        JJOrderModel *model = [JJOrderModel mj_objectWithKeyValues:response[@"value"]];
        
        if(model.total_fee == 0) {
        //跳到报名成功
            JJPaySuccessViewController *paySuccessViewController = [UIStoryboard instantiateInitialViewControllerWithStoryboardName:@"paySuccess"];
            paySuccessViewController.type = 2;
            paySuccessViewController.model = model;
            
            [self.navigationController pushViewController:paySuccessViewController animated:YES];
            paySuccessViewController.successLabel.text = @"恭喜您!报名成功";
        }else{
        //跳到收银台
        JJCashierViewController * cashierViewController = [[JJCashierViewController alloc]init];
            cashierViewController.type = 2;
        cashierViewController.model = model;
        [self.navigationController pushViewController:cashierViewController animated:YES];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
     

}




- (void)dealloc {
    [self clearNotificationAndGesture];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
