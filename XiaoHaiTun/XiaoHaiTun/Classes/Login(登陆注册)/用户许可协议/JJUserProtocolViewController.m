//
//  JJUserProtocolViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 2016/10/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJUserProtocolViewController.h"
#import "XPWebView.h"

@interface JJUserProtocolViewController ()

@property (nonatomic, strong) XPWebView *webView;


@end

@implementation JJUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.title = @"用户许可协议";
    self.webView = [[XPWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.remoteUrl = self.url;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
