//
//  JJReceiveAddressCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReceiveAddressCell.h"
#import "UILabel+LabelStyle.h"
#import <ReactiveCocoa.h>
#import "UIView+viewController.h"
#import "JJEditReceiveAddressViewController.h"
#import "UIView+viewController.h"

@interface JJReceiveAddressCell ()


//姓名
@property (nonatomic, weak) UILabel *nameLabel;
//手机
@property (nonatomic, weak) UILabel *phoneLabel;
//默认label
@property (nonatomic, weak) UILabel *defaultLabel;
//地址
@property (nonatomic, weak) UILabel *addressLabel;
//编辑按钮
@property (nonatomic, weak) UIButton *editButton;


@end

@implementation JJReceiveAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//创建基本视图
- (void)initBaseView{
    //勾选按钮
    UIImageView *chooseImage = [[UIImageView alloc]init];
    
    chooseImage.contentMode = UIViewContentModeCenter;
    self.chooseImage = chooseImage;
    [chooseImage setImage:[UIImage imageNamed:@"shopCar_Normal"]];
    [chooseImage setHighlightedImage:[UIImage imageNamed:@"shopCar_Select"]];
    [self.contentView addSubview:self.chooseImage];
    [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(@(56 * KWIDTH_IPHONE6_SCALE));
    }];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"王杰" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.chooseImage.mas_right);
    }];
    
    //手机
    UILabel *phoneLabel = [[UILabel alloc]init];
    self.phoneLabel = phoneLabel;
    [self.phoneLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"18394154100" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(22 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(22 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //默认label
    UILabel *defaultLabel = [[UILabel alloc]init];
    defaultLabel.hidden = YES;
    self.defaultLabel = defaultLabel;
    [self.contentView addSubview:self.defaultLabel];
    [self.defaultLabel jj_setLableStyleWithBackgroundColor:NORMAL_COLOR font:[UIFont systemFontOfSize:10] text:@"默认" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(25 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.phoneLabel.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(@30);
        make.height.equalTo(@15);
    }];
    
    //编辑按钮
    UIButton *editButton = [[UIButton alloc]init];
    [editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = editButton;
    [self.contentView addSubview:self.editButton];
    [self.editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    [self.editButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.equalTo(@(83 * KWIDTH_IPHONE6_SCALE));
    }];
    
    //地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.numberOfLines = 2;
    self.addressLabel = addressLabel;
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] text:@"河北省北京市朝阳区疆外soho十号楼2303" textColor:RGBA(102,102,102,1) textAlignment:NSTextAlignmentLeft];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseImage.mas_right);
        make.top.equalTo(self.phoneLabel.mas_bottom).with.offset(8);
        make.right.equalTo(self.editButton.mas_left).with.offset(-13 * KWIDTH_IPHONE6_SCALE);
        
    }];
    
    [self racobserveChange];
    
}

//RAC观察
- (void)racobserveChange{
    [[RACObserve(self, model.is_default)ignore:nil]subscribeNext:^(NSNumber *hightlite) {
//        self.chooseImage.highlighted = hightlite.boolValue;
        self.defaultLabel.hidden = !hightlite.boolValue;
    }];
    [[RACObserve(self, model.isSelected)ignore:nil]subscribeNext:^(NSNumber *selected) {
        self.chooseImage.highlighted = selected.boolValue;
    }];

}

//进入编辑界面
- (void)edit {
    JJEditReceiveAddressViewController *editReceiveAddressViewController = [[JJEditReceiveAddressViewController alloc]init];
    UITableViewController *tableViewController = self.viewController;
    __weak typeof(tableViewController) weakTableViewController = tableViewController;
    editReceiveAddressViewController.editBlock = ^{
        [weakTableViewController.tableView.mj_header beginRefreshing];
    };
    editReceiveAddressViewController.model = self.model;
    JJReceiveAddressModel *mode = self.model;
    [self.viewController.navigationController pushViewController:editReceiveAddressViewController animated:YES];
}

- (void)setModel:(JJReceiveAddressModel *)model {
    _model = model;
    self.chooseImage.highlighted = model.isSelected;
    self.nameLabel.text = model.shipping_user;
    self.addressLabel.text =[ NSString stringWithFormat:@"%@ %@ %@ %@",model.province,model.city,model.area, model.address];
    self.phoneLabel.text = model.mobile;
    self.defaultLabel.hidden = !model.is_default;
    
}

@end
