//
//  JJHelpCenterTableViewCell.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHelpCenterTableViewCell.h"
#import "UILabel+LabelStyle.h"
#import <Masonry.h>

@implementation JJHelpCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
         self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initBaseViews];
    }
    return self;
}

- (void)initBaseViews {
    
    UILabel * nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    [nameLabel jj_setLableStyleWithBackgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] text:@"购物流程" textColor:[UIColor blackColor] textAlignment:nil];
    [self.contentView addSubview:nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
}

- (void)setHelpCellModel:(JJHelpCellModel *)helpCellModel {
    _helpCellModel = helpCellModel;
    self.nameLabel.text = helpCellModel.title;
}

@end
