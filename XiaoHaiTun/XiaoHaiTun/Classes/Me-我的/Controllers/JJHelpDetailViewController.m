//
//  JJHelpDetailViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 2016/10/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHelpDetailViewController.h"

@interface JJHelpDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation JJHelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.model.title;
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
//    [_webView setOpaque:NO];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
    [self.webView loadHTMLString:self.model.content baseURL:nil];
    // Do any additional setup after loading the view.
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
