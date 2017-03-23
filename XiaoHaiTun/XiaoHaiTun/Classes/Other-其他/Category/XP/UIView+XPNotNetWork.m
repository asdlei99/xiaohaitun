//
//  UIView+EmptyData.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//


#import "UIView+XPNotNetWork.h"
#import "JJTipTryOnceView.h"
#import <ReactiveCocoa.h>

@interface UIView (_XPNotNetWork)

@property (nonatomic, strong) JJTipTryOnceView *noNetWorkVIew;
//无网络时
@property (nonatomic, copy) TryOnceAgainBlock noNetWorkBlock;

@property (nonatomic, strong) JJTipTryOnceView  *noDateView;
//无数据时
@property (nonatomic, copy) TryOnceAgainBlock tryOnceAgainBlock;
@end

@implementation UIView (_XPNotNetWork)
//关联无网络时按钮点击
static char noNetWorkKey;
-(void)setNoNetWorkBlock:(TryOnceAgainBlock)noNetWorkBlock{
    objc_setAssociatedObject(self, &noNetWorkKey, noNetWorkBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(TryOnceAgainBlock)noNetWorkBlock{
    return objc_getAssociatedObject(self, &noNetWorkKey);
}


//关联无数据时按钮点击
static char tryOnceAgainKey;
-(void)setTryOnceAgainBlock:(TryOnceAgainBlock)tryOnceAgainBlock{
    objc_setAssociatedObject(self, &tryOnceAgainKey, tryOnceAgainBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(TryOnceAgainBlock)tryOnceAgainBlock{
    return objc_getAssociatedObject(self, &tryOnceAgainKey);
}



- (JJTipTryOnceView *)noNetWorkVIew
{
    UIView *existingView = [self viewWithTag:80000];
    if(existingView) {
        if(![existingView isKindOfClass:[JJTipTryOnceView class]]) {
            DebugLog(@"Unexpected view of class %@ found with badge tag.", existingView);
            return nil;
        } else {
            return (JJTipTryOnceView *)existingView;
        }
    }
    JJTipTryOnceView *_noNetWorkVIew = [JJTipTryOnceView tipTryOnceView];
    _noNetWorkVIew.tag = 80000;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_noNetWorkVIew addGestureRecognizer:pan];
    
    DebugLog(@"%@",NSStringFromCGRect(self.bounds));
    _noNetWorkVIew.frame =CGRectMake(0, 0, self.width, self.height);// self.bounds;
//    if([self isKindOfClass:[UICollectionView class]]) {
//        //此处为何要修改,因为MJ的框架问题  差评
//        UICollectionView *collectionVIew = self;
//
////        _noNetWorkVIew.top = 0;
//    }

    return _noNetWorkVIew;
}
- (JJTipTryOnceView *)noDateView {
    UIView *existingView = [self viewWithTag:80001];
    if(existingView) {
        if(![existingView isKindOfClass:[JJTipTryOnceView class]]) {
            DebugLog(@"Unexpected view of class %@ found with badge tag.", existingView);
            return nil;
        } else {
            return (JJTipTryOnceView *)existingView;
        }
    }
    JJTipTryOnceView *_noNetWorkVIew = [JJTipTryOnceView tipTryOnceView];
    _noNetWorkVIew.tag = 80001;
    DebugLog(@"%@",NSStringFromCGRect(self.bounds));
    _noNetWorkVIew.frame =CGRectMake(0, 0, self.width, self.height);// self.bounds;
    return _noNetWorkVIew;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
}

@end

@implementation UIView (XPNotNetWork)

- (void)showNoNetWorkWithTryAgainBlock:(TryOnceAgainBlock)block
{
    self.noNetWorkVIew.hidden = NO;
    [self addSubview:self.noNetWorkVIew];
    
    
    
    if(block) {
        self.noNetWorkBlock = block;
    }
    [self.noNetWorkVIew.tryLoadButton addTarget:self action:@selector(noNetWorkBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
//按钮点击
- (void)noNetWorkBtnClick {
    self.noNetWorkBlock();
}
- (void)hideNoNetWork
{
    self.noNetWorkVIew.hidden = YES;
//    if([self isKindOfClass:[UITableView class]] &&
//       !self.userInteractionEnabled) {
//        self.userInteractionEnabled = YES;
//    }
}



- (void)showNoDateWithImageName:(NSString *)imageName title:(NSString *)title btnName:(NSString *)btnName TryAgainBlock:(TryOnceAgainBlock)block
{
    self.noDateView.hidden = NO;
    [self addSubview:self.noDateView];
    self.noDateView.tipLabel.text = title;
    
    if (imageName.length != 0){
         self.noDateView.noInternetImageView.image = [UIImage imageNamed:imageName];
    }else {
        self.noDateView.noInternetImageView.image = [UIImage imageNamed:@"NO_CART_GOODS"];
    }
    
    if(btnName.length != 0) {
        [self.noDateView.tryLoadButton setTitle:btnName forState:UIControlStateNormal];
        if(block) {
            self.tryOnceAgainBlock = block;
        }
        [self.noDateView.tryLoadButton addTarget:self action:@selector(tryOnceAgainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.noDateView.tryLoadButton.hidden = YES;
    }
    
}
//按钮点击
- (void)tryOnceAgainBtnClick {
    self.tryOnceAgainBlock();
}

- (void)hideNoDate
{
    self.noDateView.hidden = YES;
    //    if([self isKindOfClass:[UITableView class]] &&
    //       !self.userInteractionEnabled) {
    //        self.userInteractionEnabled = YES;
    //    }
}

@end
