//
//  JJInformationCell.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/5.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHobbyModel.h"
@interface JJInformationCell : UICollectionViewCell

@property (nonatomic, strong) JJHobbyModel *hobbyModel;


//底部照片
@property (nonatomic, strong) UIImageView *imageV;
//名称
@property (nonatomic, strong) UILabel *nameLabel;
////遮罩
//@property (nonatomic, strong) UIView *shadowView;
//勾号
@property (nonatomic, strong) UIImageView *chooseImageView;


@end
