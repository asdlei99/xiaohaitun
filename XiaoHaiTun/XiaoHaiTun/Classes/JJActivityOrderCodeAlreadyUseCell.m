//
//  JJActivityOrderCodeAlreadyUseCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJActivityOrderCodeAlreadyUseCell.h"
#import "UILabel+LabelStyle.h"
#import "JJAvatarBrowser.h"

@interface JJActivityOrderCodeAlreadyUseCell ()

////描述
//@property (nonatomic, weak) UILabel *addressLabel;


@end

@implementation JJActivityOrderCodeAlreadyUseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseView];
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //    self.backgroundColor = RGBA(247, 247, 247, 1);
    //二维码图片
    UIImageView *codeIcon = [[UIImageView alloc]init];
//    [JJAvatarBrowser showImage:codeIcon];
    [codeIcon createBordersWithColor:RGBA(238, 238, 238, 1) withCornerRadius:0 andWidth:1];
    codeIcon.image = [UIImage imageNamed:@"defaultUserIcon"];
    self.codeIcon = codeIcon;
    [self.contentView addSubview:codeIcon];
    [_codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self.contentView).with.offset(-47 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.contentView).with.offset(14 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(_codeIcon.mas_height);
    }];
    //验证码
    UILabel *codeLabel = [[UILabel alloc]init];
    [codeLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16] text:@"验证码:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    self.codeLabel = codeLabel;
    [self.contentView addSubview:self.codeLabel];
    _codeLabel.numberOfLines = 0;
    _codeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeIcon.mas_right).with.offset(10 * KWIDTH_IPHONE6_SCALE);
                make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(23 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //消费凭证
    UILabel *proveExpendLabel = [[UILabel alloc]init];
    [self.contentView addSubview:proveExpendLabel];
    [proveExpendLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"消费凭证" textColor:RGBA(153, 153, 153, 1) textAlignment:NSTextAlignmentLeft];
    [proveExpendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.codeIcon);
    }];
    //使用时间Label
    UILabel *useTimeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:useTimeLabel];
    self.useTimeLabel = useTimeLabel;
    self.useTimeLabel.numberOfLines = 1;
    [useTimeLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] text:@"" textColor:RGBA(153,153,153, 1) textAlignment:NSTextAlignmentLeft];
    [useTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.codeIcon.mas_right).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-23 * KWIDTH_IPHONE6_SCALE);
        make.height.equalTo(@17);

    }];
    
    //说明Label
    UILabel *instructLabel = [[UILabel alloc]init];
    instructLabel.numberOfLines = 2;
    [self.contentView addSubview:instructLabel];
    [instructLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"到现场验票点请出示二维码或验证码给工作人员,完成如此" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentLeft];
    [instructLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useTimeLabel.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.codeIcon.mas_right).with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(self.contentView).with.offset(-23 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UIView *spaceView = [[UIView alloc]init];
    spaceView.backgroundColor = RGBA(238, 238, 238, 1);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(10 * KWIDTH_IPHONE6_SCALE));
    }];
    
    UIView *maskingView = [[UIView alloc]init];
    [self.contentView addSubview:maskingView];
    maskingView.backgroundColor = [UIColor whiteColor];
    maskingView.alpha = 0.5;
    [maskingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}
@end
