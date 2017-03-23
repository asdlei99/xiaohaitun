//
//  JJSuggessionViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSuggessionViewController.h"
#import "MBProgressHUD+gifHUD.h"
#import "User.h"
#import "HFNetWork.h"
#import "UIView+FrameExpand.h"
#import "UIViewController+KeyboardCorver.h"
//#import "UIView+FrameExpand.h"

@interface JJSuggessionViewController ()<UITextViewDelegate>
//反馈意见
@property (nonatomic, strong) UITextView *contentTextView;
//联系信息
@property (nonatomic,strong) UITextView *contactMessageTextView;
//提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UILabel *placeHoldercontentLabel;
@property (nonatomic, strong) UILabel *placeHoldercontactMessageLabel;


@property (nonatomic, strong)UIView *v ;

@end

@implementation JJSuggessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.v];
    [self initBaseView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initBaseView {
    self.view.backgroundColor = RGBA(238, 238, 238, 1);
    self.navigationItem.title = @"意见反馈";
    _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(20 * KWIDTH_IPHONE6_SCALE, 84, (SCREEN_WIDTH - 40)*KWIDTH_IPHONE6_SCALE, ((SCREEN_WIDTH - 40)*KWIDTH_IPHONE6_SCALE) * (44.0 / 67))];
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.delegate = self;
    _contentTextView.returnKeyType=UIReturnKeyDone;
    _contentTextView.font = [UIFont systemFontOfSize:13];
    [self.v addSubview:_contentTextView];
    
    _placeHoldercontentLabel = [[UILabel alloc]init];
    _placeHoldercontentLabel.frame = CGRectMake(3, 5, SCREEN_WIDTH, 20);
    _placeHoldercontentLabel.text = @"请输入您的宝贵意见";
    _placeHoldercontentLabel.enabled = NO;
    _placeHoldercontentLabel.backgroundColor = [UIColor clearColor];
    _placeHoldercontentLabel.font = [UIFont systemFontOfSize:13];
    [_contentTextView addSubview:_placeHoldercontentLabel];
   
    _contactMessageTextView = [[UITextView alloc]init] ;//]WithFrame:CGRectMake((20 * KWIDTH_IPHONE6_SCALE), 20 * KWIDTH_IPHONE6_SCALE + _contentTextView.bottom, (SCREEN_WIDTH - 40)*KWIDTH_IPHONE6_SCALE, 200)];
    _contactMessageTextView.backgroundColor = [UIColor whiteColor];
    _contactMessageTextView.delegate = self;
    _contactMessageTextView.returnKeyType=UIReturnKeyDone;
    _contactMessageTextView.font = [UIFont systemFontOfSize:13];
    [self.v addSubview:_contactMessageTextView];
    [_contactMessageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.v).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(_contentTextView.mas_bottom).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.v).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(self.v.mas_width).multipliedBy(20.0 / 67);
    }];
    _placeHoldercontactMessageLabel = [[UILabel alloc]init];
    _placeHoldercontactMessageLabel.frame = CGRectMake(3, 5, SCREEN_WIDTH, 20);
    _placeHoldercontactMessageLabel.text = @"请留下您的联系方式(QQ/邮箱/电话号码)";
    _placeHoldercontactMessageLabel.enabled = NO;
    _placeHoldercontactMessageLabel.backgroundColor = [UIColor clearColor];
    _placeHoldercontactMessageLabel.font = [UIFont systemFontOfSize:13];
    [_contactMessageTextView addSubview:_placeHoldercontactMessageLabel];
    
    self.submitBtn = [[UIButton alloc]init];
    _submitBtn.backgroundColor = NORMAL_COLOR;
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:6 andWidth:0];
    [self.v addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.v).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(_contactMessageTextView.mas_bottom).with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.v).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@42);
    }];
    [self.submitBtn addTarget:self action:@selector(submitRequest:) forControlEvents:UIControlEventTouchUpInside];
    
      [self addNotification];
}

#pragma mark - 意见反馈提交请求
- (void)submitRequest:(UIButton *)btn {
    NSString *content = self.contentTextView.text;
    NSString *information = self.contactMessageTextView.text;
    NSDictionary *params = @{@"content" : content, @"information" : information};
    // 发送意见反馈请求
    NSString *addFeedBackRequesturl = [NSString stringWithFormat:@"%@%@",DEVELOP_BASE_URL, API_ADD_FEEDBACK];
    
    
    [HFNetWork postWithURL:addFeedBackRequesturl params:params success:^(id response) {
        
        [MBProgressHUD hideHUD];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //失败返回
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            [MBProgressHUD showHUDWithDuration:1.0 information:codeMessage hudMode:MBProgressHUDModeText];
            return ;
        }
        [MBProgressHUD showHUDWithDuration:1.0 information:@"意见提交成功" hudMode:MBProgressHUDModeText];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSInteger errCode = [error code];
        DebugLog(@"errCode = %ld", errCode);
        
        [MBProgressHUD showHUDWithDuration:1.0 information:@"加载失败" hudMode:MBProgressHUDModeText];
    }];
}


-(void)textview:(UITextView *)textView
{
    if(textView == _contentTextView){
        if (textView.text.length == 0) {
            _placeHoldercontentLabel.text = @"请输入您的宝贵意见";
        }else{
            _placeHoldercontentLabel.text = @"";
        }
    }
    if(textView == _contactMessageTextView){
        if (textView.text.length == 0) {
            _placeHoldercontactMessageLabel.text = @"请留下您的联系方式(QQ/邮箱/电话号码";
        }else{
            _placeHoldercontactMessageLabel.text = @"";
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    DebugLog(@"--%@--",text);
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    }

- (void)textViewDidChange:(UITextView *)textView {
    if(textView == self.contentTextView){
        if(textView.text.length == 0){
            _placeHoldercontentLabel.text = @"请输入您的宝贵意见";
            
        }else{
            _placeHoldercontentLabel.text = @"";
        }
    }
    if(textView == self.contactMessageTextView){
        
        if(textView.text.length == 0){
            _placeHoldercontactMessageLabel.text = @"请留下您的联系方式(QQ/邮箱/电话号码";
        }else{
            _placeHoldercontactMessageLabel.text = @"";
        }
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.contentTextView endEditing:YES];
    [self.contactMessageTextView endEditing:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;{
    [self.contentTextView endEditing:YES];
    [self.contactMessageTextView endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    DebugLog(@"123");
}

- (void)dealloc
{
    [self clearNotificationAndGesture];
}
@end


