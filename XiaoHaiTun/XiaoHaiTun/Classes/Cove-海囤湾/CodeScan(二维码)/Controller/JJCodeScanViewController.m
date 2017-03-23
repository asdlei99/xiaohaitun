//
//  JJCodeScanViewController.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/30.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCodeScanViewController.h"
//#import "MyQRViewController.h"
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"
#import "JJGoodsDetailViewController.h"
#import "UIViewController+Alert.h"


@interface JJCodeScanViewController ()

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;

@end

@implementation JJCodeScanViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    
    //创建右边的Button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto)];
    self.navigationItem.rightBarButtonItem = rightButton;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (_isQQSimulator) {
//        
//        [self drawBottomItems];
//        [self drawTitle];
//        [self.view bringSubviewToFront:_topTitle];
//    }
//    else
//        _topTitle.hidden = YES;
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}



- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        DebugLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
     [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        
        //点击完，继续扫码
        [weakSelf reStartDevice];
    } buttonsStatement:@"知道了",nil];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = strResult.imgScanned;
    vc.strCodeType = strResult.strBarCodeType;
    vc.strScan = strResult.strScanned;
    NSInteger i = [strResult.strScanned integerValue];
    //若扫描的不是商品
    if(i == 0) {
        //取消扫描
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.scanObj stopScan];
        [self.qRScanView stopScanAnimation];
        [self showAlertWithTitle:@"扫描失败" message:@"无法识别该二维码" cancelTitle:@"确定" cancelBlock:^{
            [self drawScanView];
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
        }];
    }else{
        JJGoodsDetailViewController *goodsDetailVC = [[JJGoodsDetailViewController alloc]init];
        goodsDetailVC.goodsID = strResult.strScanned;
        goodsDetailVC.name = @"商品详情";
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }

}






#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

 @end
