//
//  VKMessageCell.m
//  VKApp
//
//  Created by Sergey Lyubeznov on 02.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import "VKMessageCell.h"
#import "UIImageView+UIImageViewExtension.h"

@implementation VKMessageCell

- (void)initImageModel {
    
    self.imageModel = [[VKImageModel alloc]init];
    __weak id weakSelf = self;
    self.imageModel.delegate = weakSelf;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - VKModelsProtocolDelegate

- (void)processCompletedImage {
    
    [self.userImageView setCornerRadius:25.f andBorderWidth:0.f andBorderColor:[UIColor blackColor]];
    
    self.userImageView.image = self.imageModel.image;
    self.cellIndicatorView.hidden = YES;
    
}

@end
