//
//  JJAboutAppViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 2016/10/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAboutAppViewController.h"

@interface JJAboutAppViewController ()

@end

@implementation JJAboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = NORMAL_COLOR;
    label.font = [UIFont systemFontOfSize:14];
    self.navigationItem.title = @"关于小海囤";
    self.view.backgroundColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    
    NSString *string = @"    小海囤 | 口袋里的养娃神器\n\n   【臻选商品】专业的孕婴童跨境电商，汇集全球数十个国家的臻选儿童商品，助你不出国门囤尽全球好货。\n\n   【臻享活动】24位资深玩家为孩子精心筛选最值得体验的儿童活动，周末去哪从此不愁。\n\n    我们既有好买的，也有好玩的，每周一款特别推荐，只为助你轻松养娃！\n\n    微信：小海囤\n\n    客服电话：010-81530054";
    NSMutableAttributedString *attributeStringM = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    //    [paragraphStyle1 setFirstLineHeadIndent:40.0];
    //    paragraphStyle1.headIndent = 30;          //行首缩进
    [attributeStringM addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    label.attributedText = attributeStringM;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
    }];
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
