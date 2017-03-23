//
//  JJMyActivityModel.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

//(0, '等待付款'),
//(1, '付款成功'),
//(2, '订单取消'),
//(3, '报名成功'),
//(4, '退款申请中'),
//(5, '退款中'),
//(6, '退款成功'),
typedef NS_ENUM(NSInteger, JJMyActivityType) {
    JJMyActivityWaitPay = 0,
    JJMyActivitySuccessPay ,
    JJMyActivityCancleOrder ,
    JJMyActivityApplySuccess ,
    JJMyActivityOrderRefoundApplying ,
    JJMyActivityOrderRefounding ,
    JJMyActivityOrderRefoundSuccess ,
    JJMyActivityOrderComplete,
    JJMyActivityOrderRefoundFail,
    JJMyActivityPayMent
};

@interface JJMyActivityModel : NSObject

//(0, '等待付款'),
//(1, '付款成功'),
//(2, '订单取消'),
//(3, '报名成功'),
//(4, '退款申请中'),
//(5, '退款中'),
//(6, '退款成功'),
//(7, '已参加')
//(8,  退款失败)
//(9,  支付中)
@property(nonatomic,assign)JJMyActivityType status;

//活动id
@property (nonatomic, strong) NSString *activity_id;

//订单号
@property (nonatomic, copy)NSString* order_num;

//活动logo
@property (nonatomic, copy)NSString* pic;

//活动名称
@property (nonatomic, copy)NSString* name;

//地点
@property (nonatomic, copy)NSString* address;
//开始时间
@property (nonatomic, copy)NSString* start_time;
//活动类别
@property (nonatomic, copy)NSString* category;
//单价
@property (nonatomic, assign)CGFloat price;
//总价
@property (nonatomic, assign)CGFloat total_fee;
//验证码
@property (nonatomic, copy)NSString* code;
//二维码地址
@property (nonatomic, copy)NSString* q_code;
//验证码是否使用
@property(nonatomic,assign)BOOL is_used;
//验证码使用时间
@property (nonatomic, copy)NSString *used_time;
//运费
@property (nonatomic, assign)CGFloat freight;
//优惠金额
@property (nonatomic, assign)CGFloat benefit;
//备注
@property (nonatomic, copy)NSString* note;

@end
