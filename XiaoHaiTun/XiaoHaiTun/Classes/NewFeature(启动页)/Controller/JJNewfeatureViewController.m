//
//  BeginViewController.m
//  大作业
//
//  Created by tarena on 15/9/22.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "JJNewfeatureViewController.h"
#import "JJTabBarController.h"
#import "UIView+FrameExpand.h"
#import "UIButton+Enlarge.h"
//#import "MyNavigationController.h"
//#import "MyMusicViewController.h"
//#import "SelectedViewController.h"
//#import "StoreViewController.h"
//#import "MoreViewController.h"

#define ImageCount 3
@interface JJNewfeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView* scrollerView;
@property(nonatomic,strong)NSArray* imageNames;
@property(nonatomic,strong)UIPageControl* pageController;
@property (nonatomic, strong) UIButton *jumpButton;


@end

@implementation JJNewfeatureViewController

-(NSArray*)imageNames{
    if(!_imageNames){
        NSMutableArray* arrayM=[NSMutableArray array];
        for(int i=0;i<ImageCount;i++){
            [arrayM addObject:[NSString stringWithFormat:@"Welcome_0%d",i+1]];
        }
        _imageNames=arrayM;
    }
    return _imageNames;
}

-(void)nextPage{
    NSInteger index=self.pageController.currentPage;
    [self.scrollerView setContentOffset:CGPointMake(self.view.frame.size.width*((index+1)%5), 0) animated:YES];
}

-(UIScrollView*)scrollerView{
    if(_scrollerView==nil){
        _scrollerView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollerView.backgroundColor=[UIColor redColor];
        _scrollerView.contentSize=CGSizeMake(self.view.frame.size.width*self.imageNames.count, 0);
        _scrollerView.pagingEnabled=YES;
        _scrollerView.delegate=self;
        _scrollerView.bounces=NO;
        _scrollerView.showsHorizontalScrollIndicator=NO;
        _scrollerView.frame=self.view.bounds;
        [self.view addSubview:_scrollerView];
    }
    
    return _scrollerView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(int i=0;i<self.imageNames.count;i++){
        UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageNames[i]]];
        imageView.frame=CGRectMake(i*self.scrollerView.frame.size.width, 0, self.scrollerView.frame.size.width, self.scrollerView.frame.size.height);
        [self.scrollerView addSubview:imageView];
        if(i==self.imageNames.count-1){
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finish)];
            [imageView addGestureRecognizer:tapGR];
        }
    }
    self.pageController;
    self.jumpButton;
}

-(void)finish{
    JJTabBarController* tabBarController=[[JJTabBarController alloc]init];
    self.view.window.rootViewController=tabBarController;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point= scrollView.contentOffset;

    NSInteger index=round(point.x/self.scrollerView.frame.size.width);
    self.pageController.currentPage=index;    
}

//欢迎页面不显示电池条
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - 懒加载
- (UIPageControl*)pageController{
    if(_pageController==nil){
        _pageController=[[UIPageControl alloc]init];
        _pageController.hidden = YES;
        _pageController.numberOfPages=self.imageNames.count;
        _pageController.center=CGPointMake(self.view.center.x, self.view.frame.size.height-30) ;
        _pageController.pageIndicatorTintColor=[UIColor whiteColor];
        _pageController.currentPageIndicatorTintColor=[UIColor blackColor];
        [self.view addSubview:_pageController];
    }
    return _pageController;
}

- (UIButton *)jumpButton {
    if(_jumpButton == nil) {
        _jumpButton = [[UIButton alloc]init];
        [_jumpButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [_jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpButton setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [self.view addSubview:_jumpButton];
        _jumpButton.top = 20;
        _jumpButton.width = 30;
        _jumpButton.height = 30;
        _jumpButton.right = SCREEN_WIDTH -20;
        [_jumpButton createBordersWithColor:RGBA(88, 211, 245, 1) withCornerRadius:15 andWidth:2];
        [_jumpButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpButton;
}
@end
