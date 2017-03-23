//
//  JJWaitGoodsTableViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWaitGoodsTableViewCell.h"
#import "UIButton+Custom.h"
#import "UIView+viewController.h"
#import "JJWaitPayViewController.h"
#import "User.h"
#import "JJLoginViewController.h"
#import "UIView+viewController.h"
#import "UIViewController+ModelLogin.h"

@interface JJWaitGoodsTableViewCell ()

//待付款
@property (nonatomic, weak) UIButton *payButton;
//待发货
@property (nonatomic, weak) UIButton *portButton;
//待收货
@property (nonatomic, weak) UIButton *receiptButton;

@end

@implementation JJWaitGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createViews];
    }
    return self;
}

- (void)createViews {
    UIButton *payButton = [[UIButton alloc]init];
    self.payButton = payButton;
    [self.payButton setTitleColor:RGB(44, 45, 49) forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [payButton setImage:[UIImage imageNamed:@"me_Pay"] forState:UIControlStateNormal];
    [payButton setTitle:@"待付款" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(gotoWaitPayVC:) forControlEvents:UIControlEventTouchUpInside];
//    [payButton verticalCenterImageAndTitle:20];
    [self.contentView addSubview:payButton];
    
    UIButton *portButton = [[UIButton alloc]init];
    self.portButton = portButton;
    [self.portButton setTitleColor:RGB(44, 45, 49) forState:UIControlStateNormal];
    portButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [portButton setImage:[UIImage imageNamed:@"me_Port"] forState:UIControlStateNormal];
    [portButton setTitle:@"待发货" forState:UIControlStateNormal];
    [portButton addTarget:self action:@selector(gotoWaitPayVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:portButton];
    
    UIButton *receiptButton = [[UIButton alloc]init];
    [receiptButton createBordersWithColor:NORMAL_COLOR withCornerRadius:2 andWidth:0];
    self.receiptButton = receiptButton;
    [self.receiptButton setTitleColor:RGB(44, 45, 49) forState:UIControlStateNormal];
    receiptButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [receiptButton setImage:[UIImage imageNamed:@"me_Receipt"] forState:UIControlStateNormal];
    [receiptButton setTitle:@"待收货" forState:UIControlStateNormal];
    [receiptButton addTarget:self action:@selector(gotoWaitPayVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:receiptButton];
}

//前往待付款发货收货页面
- (void)gotoWaitPayVC:(UIButton *)btn {
    User *user = [User getUserInformation];
    if(user == nil) {
        
        [self.viewController modelToLoginVC];
        return;
    }
    
    DebugLog(@"%@",self.viewController.class);
    JJWaitPayViewController *waitPayViewController = [[JJWaitPayViewController alloc]init];
    //判断是由哪种类型的跳转
    if(btn == self.payButton){
        waitPayViewController.goodsWaitType = 9;
    }else if(btn == self.portButton){
        waitPayViewController.goodsWaitType = 3;
    }else{
        waitPayViewController.goodsWaitType = 4;
    }
    [self.viewController.navigationController pushViewController:waitPayViewController animated:YES];
}


//-(void)initButton:(UIButton*)btn{
////    btn.backgroundColor = RandomColor;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = self.width / 3;
    CGFloat buttonHeight = self.height;
    self.payButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    
    self.portButton.frame = CGRectMake(buttonWidth, 0,buttonWidth , buttonHeight);
    
    self.receiptButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight);
    [self.payButton verticalCenterImageAndTitle:5];
    [self.portButton verticalCenterImageAndTitle:5];
    [self.receiptButton verticalCenterImageAndTitle:5];

}

@end
