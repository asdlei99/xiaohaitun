
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString *token; // 请求的token

@property (nonatomic, strong) NSString *userId; // 用户id

@property (nonatomic, copy) NSString *username; //昵称

@property (nonatomic, copy) NSString *nickname; // 用户名

@property (nonatomic, strong) NSNumber *gender; //性别

@property (nonatomic, assign) NSInteger birthday; //出生年月

@property (nonatomic, copy) NSString *avatar; // 头像

@property (nonatomic, copy) NSString *baby_name; //昵称

@property (nonatomic, strong) NSNumber *baby_gender;//宝宝性别

@property (nonatomic, assign) NSInteger baby_birthday; //宝宝出生年月

@property (nonatomic, copy) NSString *mobile; // 手机号

@property (nonatomic, copy) NSString *balance;//余额

@property (nonatomic, strong) NSNumber *city;//城市



//- (id) initWithDicionary:(NSDictionary *)dic;
//
//- (void)updateUserInfo:(NSDictionary *)dic;


/**
 *  保存用户信息
 *
 *  @param user 用户
 */
+ (void)saveUserInformation:(User *)user;

/**
 *  获取用户信息
 *
 *  @return 用户
 */
+ (User *)getUserInformation;

/**
 *  注销用户信息
 */
+ (void)removeUserInformation;


@end


//"error_code": 0,
//"token": "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
//"user": [
//         "id": 12,
//         "username": "蓝求",
//         "nickname": "张三",
//         "gender": 1,
//         "avatar": "http://adf2212sss.jgp",
//         "baby_gender": 1,
//         "baby_birthday": 123412341234123,
//         "mobile":1852222222,
//         "balance":12,
//         ],
