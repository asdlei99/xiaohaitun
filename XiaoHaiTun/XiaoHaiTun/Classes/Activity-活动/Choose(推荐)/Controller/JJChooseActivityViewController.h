//
//  JJChooseActivityViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseTableViewController.h"
@class JJActivityChooseADViewModel;

@protocol JJChooseActivityDelegate <NSObject>
- (void)chooseActivityViewControllerscrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)chooseActivityViewControllerscrollViewDidScroll:(UIScrollView *)scrollView;

- (void)chooseActivityViewControllerscrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)chooseActivityViewControllerscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)chooseActivityViewControllerSendRequestAndResultModelArray:(NSArray<JJActivityChooseADViewModel *> *)modelArray;

@end

@interface JJChooseActivityViewController : JJBaseTableViewController

@property (nonatomic, weak) id<JJChooseActivityDelegate> chooseDelegate;

@end
