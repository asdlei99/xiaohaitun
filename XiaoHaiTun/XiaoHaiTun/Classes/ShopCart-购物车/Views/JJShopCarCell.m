//
//  JJShopCarCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJShopCarCell.h"
#import "HFNetWork.h"
#import "User.h"
#import "MBProgressHUD+gifHUD.h"
#import <MJExtension.h>
#import "JJShopCarCellModel.h"
#import <UIImageView+WebCache.h>
#import "UIButton+Enlarge.h"
#import "UIView+XPKit.h"
#import "UIView+viewController.h"
#import "UIViewController+ModelLogin.h"

//typedef NS_ENUM(NSInteger, ChangeCartNumberType) {
//    ChangeCartNumberAdd = 0,
//    ChangeCartNumberReeduce
//};

@interface JJShopCarCell ()

//是否选中按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
//衣服图片
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
//描述label
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
//规格描述
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

//价格label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//加按钮
@property (weak, nonatomic) IBOutlet UIButton *AddBtn;
//减按钮
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
//数量label
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//总价
@property (nonatomic, assign)CGFloat allMoney;//暂时用不着


@end

@implementation JJShopCarCell

- (void)setModel:(JJShopCarCellModel *)model{
    _model = model;
//    model.cover = [NSString stringWithFormat:@"%@imageView2/1/w/192/h/192",model.cover];
    self.chooseBtn.selected = model.selected;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.descriptLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", @(model.price).stringValue];
    self.numberLabel.text = @(model.number).stringValue;
    self.skuLabel.text = model.goods_sku_str;
    self.subtractBtn.enabled = (model.number > 1);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
    //增加按钮的可点击区域
    [self.AddBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [self.subtractBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [self.numberLabel createBordersWithColor:RGB(222, 222, 222) withCornerRadius:0 andWidth:1 ];
    
    //选中按钮
    [self.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //加号按钮
    [self.AddBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside ] ;
    
    //减号按钮
    [self.subtractBtn addTarget:self action:@selector(reduce:) forControlEvents:UIControlEventTouchUpInside ];
    
}

//加号按钮点击
- (void)addBtnClick:(UIButton *)btn{
    if(![User getUserInformation]){
        [self.viewController modelToLoginVC];
        return ;
    }
    //发起网络请求
    [self addEditCartRequestWithNumber:(self.model.number + 1)];
}

//减号按钮点击
-(void)reduce:(UIButton *)btn{
    if(![User getUserInformation]){
        [self.viewController modelToLoginVC];
        return ;
    }
    if(self.model.number <= 1){
        return ;
    }
    //发起网络请求
    [self reduceEditCartRequestWithNumber:(self.model.number - 1)];
    
    
}
//选中按钮点击
- (void)chooseBtnClick:(UIButton *)btn{
    self.model.selected = !self.model.selected;
    btn.selected = !btn.selected;
    if(self.chooseBtnBlock){
        self.chooseBtnBlock(btn.selected);
    }
    
    if(btn.selected){
        if(self.addMoneyBlock){
            self.addMoneyBlock(self.model.price * self.model.number);
        }
        return;
    }
    if(!btn.selected){
        if(self.reduceMoneyBlock){
            self.reduceMoneyBlock(self.model.price * self.model.number);
        }
        return;
    }
    return;
}

#pragma mark - 发起网络请求
//减
- (void)reduceEditCartRequestWithNumber:(NSInteger)number {
    //发送编辑购物车请求
    NSString * addCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_ADDOREDIT];
    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.model.goodsID , @"count" : @(number) , @"edit" : @"1"};
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
        
        self.model.number--;
        self.numberLabel.text = @(self.model.number).stringValue;
        if(self.model.number >1){
            self.subtractBtn.enabled = YES;
        }else{
            self.subtractBtn.enabled = NO;
        }
        if(self.model.selected){
            //减少价格
            //        [self calculateMoney];
            if(self.reduceMoneyBlock){
                self.reduceMoneyBlock(self.model.price);
            }
        }
    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

//加
- (void)addEditCartRequestWithNumber:(NSInteger)number {
    //发送编辑购物车请求
    NSString * addCartRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_CART_ADDOREDIT];
    NSDictionary * params = @{@"user_id" : [User getUserInformation].userId , @"item_id" : self.model.goodsID , @"count" : @(number) , @"edit" : @"1"};
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
        
        self.model.number++;
        self.numberLabel.text = @(self.model.number).stringValue;
        if(self.model.number >1){
            self.subtractBtn.enabled = YES;
        }else{
            self.subtractBtn.enabled = NO;
        }
        if(self.model.selected){
            //增加价格
            //        [self calculateMoney];
            if(self.addMoneyBlock){
                self.addMoneyBlock(self.model.price);
            }
        }

    } fail:^(NSError *error) {
        //        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}

@end
