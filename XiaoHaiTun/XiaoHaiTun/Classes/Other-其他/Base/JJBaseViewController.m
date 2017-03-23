//
//  JJBaseViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJBaseViewController ()


@end

@implementation JJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //此处主要是不知道什么原因导航条跳着跳着会自己变透明,所以经过查看层次 ios9至以下是_UINavigationBarBackground变透明
    //ios10是_UIBarBackground变透明
    for(UIView* view in self.navigationController.navigationBar.subviews){
        
        if([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]){//ios10以下
                    view.alpha = 1.0;
        }
        if([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {//ios10
            view.alpha = 1.0;
        }
        
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (JJTipTryOnceView *)tipTryOnceView {
//    if(!_tipTryOnceView) {
//        _tipTryOnceView = [JJTipTryOnceView tipTryOnceView];
//        _tipTryOnceView.hidden = YES;
//        [self.view addSubview:_tipTryOnceView];
//        [_tipTryOnceView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(_tipTryOnceView.superview);
//        }];
//    }
//    return _tipTryOnceView;
//}

- (void)dealloc {
    DebugLog(@"销毁 %s",__func__);
}


@end
