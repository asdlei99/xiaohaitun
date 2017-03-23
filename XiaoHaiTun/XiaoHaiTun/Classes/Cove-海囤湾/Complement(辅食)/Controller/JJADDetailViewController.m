//
//  JJADDetailViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/10/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJADDetailViewController.h"
#import "XPWebView.h"
#import "UINavigationBar+Awesome.h"

@interface JJADDetailViewController ()
@property (nonatomic, strong) XPWebView *webView;

@end

@implementation JJADDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.tableView.delegate = self;
//    [self scrollViewDidScroll:self.webView.scrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
    //    self.tableView.delegate = nil;
    //    [MXNavigationBarManager reStore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    self.navigationItem.title = @"详情";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    // Do any additional setup after loading the view.
}
//创建webView
- (void)createWebView {
    self.webView = [[XPWebView alloc]init];
//    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    //    self.webView.backgroundColor = [UIColor redColor];
    self.webView.scalesPageToFit = YES;
    [self.webView setRemoteUrl:self.url];
    self.webView.delegate = self;
    
}

#pragma mark - UIScrollerViewDelegate & UIWebViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
//    UIColor * color = NORMAL_COLOR;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%lf",offsetY);
//    if (offsetY < 100) {
//        CGFloat alpha = MIN(1, 1 - ((100  - offsetY) / 100));
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    } else {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
//    }
//}

@end
