//
//  VKMessageCell.h
//  VKApp
//
//  Created by Sergey Lyubeznov on 02.06.15.
//  Copyright (c) 2015 Sergey Lyubeznov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKImageModel.h"

@interface VKMessageCell : UITableViewCell <VKModelsProtocolDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *cellIndicatorView;
@property (strong, nonatomic) VKImageModel *imageModel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)initImageModel;

@end
