//
//  JJCity.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCity.h"
#import "MJExtension.h"


@implementation JJCity


+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"cityID":@"id" , @"cityName":@"name"};
}
//用了MJExtension
//写上下面这句后直接就能自定义对象归档解档了,也就是可以变成2进制了
MJCodingImplementation

+ (void)saveCityArrayInformation:(NSArray *)cityArray {
//    NSMutableArray *cityMutableArray = [NSMutableArray array];
//    for(JJCity * city in cityArray) {
//        NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:city];
//        [cityMutableArray addObject:cityData];
//    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cityArray];//[NSJSONSerialization dataWithJSONObject:cityArray options:NSJSONWritingPrettyPrinted error:NULL];// JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error]
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cityArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getcityArrayInformation {
    NSData *cityArrayData = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityArray"];
    
//    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityArray"];
    if (!cityArrayData) {
        return nil;
    }
    NSArray *cityArray = [NSKeyedUnarchiver unarchiveObjectWithData:cityArrayData];//[NSJSONSerialization JSONObjectWithData:cityArrayData options:NSJSONReadingMutableContainers error:NULL];
//    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return cityArray;
}

+ (void)removeCityArrayInformation {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cityArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
