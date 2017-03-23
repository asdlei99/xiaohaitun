//
//  JJNearActivityViewController.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseTableViewController.h"

@protocol JJNearActivityDelegate <NSObject>
- (void)nearActivityViewControllerscrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)nearActivityViewControllerscrollViewDidScroll:(UIScrollView *)scrollView;

- (void)nearActivityViewControllerscrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)nearActivityViewControllerscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@interface JJNearActivityViewController : JJBaseTableViewController

@property (nonatomic, weak) id<JJNearActivityDelegate> nearDelegate;


@end
