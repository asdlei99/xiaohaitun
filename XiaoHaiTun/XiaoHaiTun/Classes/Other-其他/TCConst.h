#import <UIKit/UIKit.h>
//主要用于存储一些key值,通知等



/**
 *  第三方平台的keys
 */
//极光推送appKey
#define JPUSHAppKey      @"084e92403a5f5436eca9d9b6"

// 友盟统计appKey
#define UMengAppKey       @"579affc8e0f55a480100385c"

//shareSDK AppKey       XHT
#define ShareSDKAppKey    @"172e2fae8dc3e"

//ping++ AppKey
#define PingPlusAppkey    @"app_0K0qr1TmD8iHLWXL"

//新浪微博 AppKey       XHT
#define WeiboAppKey        @"734327654"
#define WeiboAppSecret     @"a50b95a0015757cf9b85cded1cb2ddb6"

//腾讯QQ Appkey       XHT
#define QQAppId            @"1105618115"
#define QQAppSecret        @"GwFFbSdJnjAvDuF6"

//微信 AppKey            XHT
#define WeiChatAppId       @"wxcdc44071a233f753"
#define WeiChatAppSecret   @"53e036a01246be5e7f994f874e92b50b"

//支付宝 Appkey
//991897864   假
//1167961008  真
#define XiaoHaiTunAPPID    @"1167961008"

//@"http://orange.dev.attackt.com" //测试
//@"https://www.dopstore.cn" //正式
//Request Base URLs  XHT
#define DEVELOP_BASE_URL        @"https://www.dopstore.cn"
#define PRODUCT_BASE_URL        @"***************************"

//发送验证码 POST  XHT
#define API_SEND_V_CODE         @"/api/v1/send_v_code"

//发送语音验证码      XHT
#define API_SEND_VOICE_CODE     @"/api/v1/send_voice_code"

//验证码校验 POST    XHT
#define API_CHECK_V_CODE        @"/api/v1/check_v_code"

//手机号注册 POST  XHT
#define API_SIGNUP              @"/api/v1/signup"

//重置密码 POST     XHT
#define API_RESET_PASSWORD      @"/api/v1/reset_password"

//手机号登录 POST  XHT
#define API_LOGIN                @"/api/v1/login"

//上传头像        XHT
#define API_UPLOAD_AVATAR        @"/api/v1/upload_avatar"

//获取用户信息      XHT
#define API_USER                 @"/api/v1/user/"

//修改用户资料    XHT
#define API_USER_UPDATE           @"/api/v1/user/update"

//用户资料
#define API_USER_DATA             [NSString stringWithFormat:@"/api/v1/user/%@",[User getUserInformation].userId]

//第三方登录      XHT
#define API_OTHER_SIGNUP          @"/api/v1/othersignup"

//本应用在苹果商店中的下载地址
#define AppleStoreAppId @"954206264"

//首页轮播图     XHT
#define API_HOME_CAROUSEL   @"/api/v1/home/carousel"

//商城推荐主题     XHT
#define API_HOME_THEME   @"/api/v1/home/theme"

//商品列表          XHT
#define API_HOME_GOODS    @"/api/v1/goods"

//亲子活动-推荐活动     XHT
#define API_HOME_ACTIVITY   @"/api/v1/home/recommended_act"

//商品分类          XHT
#define API_CATEGORY_GOODS   @"/api/v1/goods/category"

//亲子活动分类        XHT
#define API_CATEGORY_ACTIVITY  @"/api/v1/home/act_categories"

//收货地址(列表)      XHT
#define API_SHIPPING_ADDRESS  [NSString stringWithFormat:@"/api/v1/user/%@/shippingaddress",[User getUserInformation].userId]

//添加/修改,收货地址(设置成默认地址也用该接口)          XHT
#define API_UPDATE_SHIPPING_ADDRESS  [NSString stringWithFormat:@"/api/v1/user/%@/update_shippingaddress",[User getUserInformation].userId]

//获取下单商品信息
#define API_GET_ORDER_GOODS      @"/api/v1/get_order_goods"
//商品订单列表
#define API_GOODS_ORDER_LIST     @"/api/v1/goods/orders"
//商品订单详情
#define API_GOODS_ORDER_DETAIL   @"/api/v1/order/goods"
//确认收货
#define API_ORDER_CONFIRM        @"/api/v1/order/confirm"
//购物车商品下订单
#define API_CART_CREAATE_ORDER   @"/api/v1/cart/create_order"
//配送信息
#define API_LOGISTICS_MESSAGE    @"/api/v1/logistics"
//商品+活动 订单退款
#define API_ORDER_REFUND    @"/api/v1/order/refund"


//活动详情          XHT
#define API_ACTIVITY_DETAIL      @"/api/v1/home/activity_details"
//活动订单列表
#define API_ACTIVITY_ORDER_LIST    @"/api/v1/order/activity_list/"
//活动订单详情
#define API_ACTIVITY_ORDER_DETAIL   @"/api/v1/order/activity/"
//活动下订单       XHT
#define API_ACTIVITY_ORDER       @"/api/v1/order/activity"

//删除收货地址
//#define API_DELETE_SHIPPING_ADDRESS  @"/api/v1/user/shippingaddress/%@/delete"


//购物车物品查询               XHT
#define API_CART_QUERY      @"/api/v1/home/cart/query"
//购物车物品添加或编辑        XHT
#define API_CART_ADDOREDIT  @"/api/v1/home/cart/edit"
//购物车物品删除               XHT
#define API_CART_DELETE     @"/api/v1/home/cart/delete"
//购物车批量删除
#define API_CART_BATCH_DELETE   @"/api/v1/home/cart/batch_del"
//购物车添加
#define API_CART_ADD        @"/api/v1/home/cart/goods_add"
//用户收藏列表                XHT
#define API_COLLECT_QUERY   @"/api/v1/home/collection/query"
//加入或取消收藏               XHT
#define API_COLLECT_EDIT    @"/api/v1/home/collection/edit"
//批量删除收藏                XHT
#define API_COLLECT_DELETE  @"/api/v1/home/collection/batch_del"
//判断商品是否收藏              XHT
#define API_ISCOLLECT_GOODS  @"/api/v1/home/collection/goods"

//获取活动订单支付charge(活动支付)        XHT
#define API_ORDER_PAY_CHARGE  @"/api/v1/order/activity/payment"
//购物车订单支付charge(商品支付)
#define API_ORDER_CART_PAY_CHARGE  @"/api/v1/order/cart/payment"  
//充值
#define API_RECHARGE          @"/api/v1/user/recharge"


//帮助中心列表            XHT
#define API_HELP            @"/api/v1/helps"

//意见反馈              XHT
#define API_ADD_FEEDBACK     [NSString stringWithFormat:@"/api/v1/user/%@/add_feedback",[User getUserInformation].userId]



//登录未登录发生改变的通知    XHT
#define SignInTypeChangeNotification   @"SignInTypeChangeNotification"

//定位后发出的通知          XHT
#define LocationNotificatiion          @"LocationNotification"

//购物车发生变化后发出通知           XHT
#define ShopCartNotification            @"ShopCartNotification"

//发出活动订单列表和商品订单列表需要刷新的请求
#define OrderListRefreshNotification    @"OrderListRefreshNotification"
