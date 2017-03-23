//
//  JJGoodsDetailViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJBaseGoodsModel.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GoodsDetailJSExport <JSExport>

JSExportAs
(joinCart  /** joinCartWithGoodsSkuID:goodsID:
            num: 作为js方法的别名 */,
 - (void)joinCartWithGoodsSkuID:(NSString *)goodsSkuID goodsID:(NSString *)goodsID num:(NSString *)number
 );
JSExportAs
(confirmOrder  /** joinCartWithGoodsSkuID:goodsID:
            num: 作为js方法的别名 */,
 - (void)confirmOrderWithGoodsID:(NSString *)goodsID goodsSkuID:(NSString *)goodsSkuID num:(NSString *)number userID:(NSString *)userID
 );
- (void)backToMain;
- (void)backToCart;
- (NSString *)getUserID;
- (void)changeTitle:(NSString *)name;
- (void)dealOrderBlancePay;
- (void)showMsg:(NSString *)message;
//JSExportAs
//(placeOrder  /** joinCartWithGoodsSkuID:goodsID:
//            num: 作为js方法的别名 */,
- (void)placeOrder:(NSString *)charge;
// );

@end


@interface JJGoodsDetailViewController : JJBaseViewController<GoodsDetailJSExport>

//@property (nonatomic, strong) JJBaseGoodsModel *model;


//商品id
@property (nonatomic, copy)NSString *goodsID;
//名称
@property (nonatomic, copy)NSString* name;
//图片
@property (nonatomic, copy)NSString* picture;

//是否收藏
//@property(nonatomic,assign)BOOL is_collect;

@end
