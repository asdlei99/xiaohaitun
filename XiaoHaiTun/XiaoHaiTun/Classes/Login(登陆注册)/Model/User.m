
//


#import "User.h"
#import "HFNetWork.h"
#import "MJExtension.h"
#import "JPUSHService.h"

@implementation User

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"userId":@"id"};
}
//用了MJExtension
//写上下面这句后直接就能自定义对象归档解档了,也就是可以变成2进制了
MJCodingImplementation

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.userId = value;
//    }
//}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@", self.nickname, self.avatar];
}

+ (void)saveUserInformation:(User *)user {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //发出通知登陆状态发生改变
    [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
    
}

+ (User *)getUserInformation {
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (!userData) {
        return nil;
    }
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}

+ (void)removeUserInformation {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
}


- (NSString *)userId{
    if(_userId == nil){
        _userId = @"";
    }
    return _userId;
}
@end
