//
//  JJBaseCollectionViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseCollectionViewController.h"

@interface JJBaseCollectionViewController ()

@end

@implementation JJBaseCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for(UIView* view in self.navigationController.navigationBar.subviews){
        if([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]){
                view.alpha = 1.0;
        }
        if([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {//ios10
            view.alpha = 1.0;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//- (JJTipTryOnceView *)tipTryOnceView {
//    if(!_tipTryOnceView) {
//        _tipTryOnceView = [JJTipTryOnceView tipTryOnceView];
//        _tipTryOnceView.hidden = YES;
//        [self.view addSubview:_tipTryOnceView];
//        [_tipTryOnceView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(self.view);
//        }];
//    }
//    return _tipTryOnceView;
//}

- (void)dealloc {
    NSLog(@"销毁 %s",__func__);
}

@end
